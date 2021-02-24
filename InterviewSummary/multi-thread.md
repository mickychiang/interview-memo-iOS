# 多线程

![multi-thread.png](https://i.loli.net/2021/02/24/RDuT1bgNvxXdlo2.png)

# GCD
- 同步/异步 和 串行/并发
- dispatch_barrier_async 异步栅栏调用，用来解决多读单写的问题。 
- dispatch_group 

## 一. 同步/异步 和 串行/并发

**GCD调动的4种组合**

- `同步串行`：同步分派任务到串行队列上
```
dispatch_sync(serial_queue, ^{//任务});
```

- `异步串行`：异步分派任务到串行队列上
```
dispatch_async(serial_queue, ^{//任务});
```

- `同步并发`：同步分派任务到并发队列上
```
dispatch_sync(concurrent_queue, ^{//任务});
```

- `异步并发`：异步分派任务到并发队列上
```
dispatch_async(concurrent_queue, ^{//任务});
```

### 1. 同步串行

>dispatch_sync(serial_queue, ^{//任务});

#### 1.1 以下代码是否有问题？
```
- (void)viewDidLoad {
    // dispatch_get_main_queue：主队列
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self doSomething];
    });
}
```

以上代码的逻辑会产生死锁。  

![sync_main.png](https://i.loli.net/2021/02/24/7o2saxWpzLMmrYy.png)

**死锁原因：`队列`引起的循环等待。**
1. 首先，在主队列提交-viewDidLoad任务；接着，提交Block任务。
2. 最终，这两个任务都需要分派到主线程中执行。
3. 首先，需要将-viewDidLoad分派到主线程中执行，在执行-viewDidLoad过程中需要调用Block，当Block同步调用完成之后，-viewDidLoad才能继续向下走。
4. 因此，-viewDidLoad方法的调用是否结束需要依赖于后续提交的Block任务。
5. 而Block任务若想执行，需要依赖于**主队列先进先出**的特性，即Block任务需要等待-viewDidLoad方法处理完成才能处理Block任务的提交。
6. 由此产生**相互等待**的情况，产生了**死锁**。

**注意：**  
- **主队列是串行队列。**
- **`主队列`中提交的`任务`，无论通过`同步`还是`异步`方式，最终都要`在主线程`中处理和执行。**
- 如果viewDidLoad任务和Block任务都在一个串行队列中执行，那么也会产生死锁问题。**即`两个任务同步分派到串行队列`时，就会产生`循环等待`的问题。**

#### 1.2 以下代码是否有问题？
```
- (void)viewDidLoad {
    // serialQueue: 自定义的串行队列
    dispatch_sync(serialQueue, ^{
        [self doSomething];
    });
}
```

以上代码运行没有问题。

![sync_serial.png](https://i.loli.net/2021/02/24/iXkWAcUeo5RFLBJ.png)

原因如下：
1. -viewDidLoad在主队列中处理；Block任务是在自定义的串行队列中处理。
2. 在主队列提交-viewDidLoad任务，-viewDidLoad分派到主线程中执行。
3. viewDidLoad执行到某一时刻时，需要同步block任务到对应的自定义的串行队列中；自定义串行队列中的block任务由于是同步方式提交的，即同步提交意味在**当前线程执行**，因此，串行队列的block任务最终也会在主线程中执行。
4. 当串行队列的block任务在主线程中执行完成后，再继续执行主队列中的-viewDidLoad方法当中的后续的代码逻辑。

### 2. 同步并发

>dispatch_sync(concurrent_queue, ^{//任务});

#### 2.1 以下代码输出什么结果？
```
- (void)viewDidLoad {
    NSLog(@"1");
    // global_queue：全局队列
    dispatch_sync(global_queue, ^{
        NSLog(@"2");
        dispatch_sync(global_queue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}
```
- **全局队列是并发队列。**
- **只要以同步方式提交任务，无论提交到串行队列还是并行队列，最终都是在当前线程中执行。**

输出日志
```
12345
```

### 3. 异步串行

>dispatch_async(serial_queue, ^{//任务});

```
- (void)viewDidLoad {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self doSomething];
    });
}
```

### 4. 异步并发

>dispatch_async(concurrent_queue, ^{//任务});

#### 4.1 以下代码输出什么结果？
```
- (void)viewDidLoad {
    dispatch_async(global_queue, ^{
        NSLog(@"1");
        [self performSelector: @selector(printLog)
               withObject: nil 
               afterDelay: 0];
        NSLog(@"3");
    });
}

- (void)printLog {
    NSLog(@"2");
}
```

输出日志
```
13
```

1. Block通过异步方式分派到全局并发队列中，Block会在GCD底层维护的线程池中的某一个线程中执行。
2. GCD底层分派的线程默认情况下是没有开启对应的runLoop的。
3. performSelector:withObject:afterDelay:方法需要创建相应的一个提交到runLoop上的逻辑的。
4. 由于GCD底层的线程没有runLoop，performSelector:withObject:afterDelay:方法会失效。
5. 如果需要有效执行，那么必须是他方法调用所属的当前线程有runLoop。

