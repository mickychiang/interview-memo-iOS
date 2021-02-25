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


## 二. dispatch_barrier_async

>dispatch_barrier_async(concurrent_queue, ^{//写操作});

### 1. 怎样利用GCD实现多读单写？

- 读者、读者并发
- 读者、写者互斥
- 写者、写者互斥

![dispatch_barrier_async_mode.png](https://i.loli.net/2021/02/25/wXTUVbMxP5fOGFz.png)

![dispatch_barrier_async.png](https://i.loli.net/2021/02/25/g1QPdqFy3AaBoZD.png)


```
//
//  UserCenter.m
//  GCD
//  dispatch_barrier_async

#import "UserCenter.h"

@interface UserCenter()
{
    // 定义一个并发队列
    dispatch_queue_t concurrent_queue;
    
    // 用户数据中心, 可能多个线程需要数据访问
    NSMutableDictionary *userCenterDic;
}

@end

// 多读单写模型
@implementation UserCenter

- (id)init
{
    self = [super init];
    if (self) {
        // 通过宏定义 DISPATCH_QUEUE_CONCURRENT 创建一个并发队列
        concurrent_queue = dispatch_queue_create("read_write_queue", DISPATCH_QUEUE_CONCURRENT);
        // 创建数据容器
        userCenterDic = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (id)objectForKey:(NSString *)key
{
    __block id obj;
    // 同步读取指定数据
    dispatch_sync(concurrent_queue, ^{
        obj = [userCenterDic objectForKey:key];
    });
    
    return obj;
}

- (void)setObject:(id)obj forKey:(NSString *)key
{
    // 异步栅栏调用设置数据
    dispatch_barrier_async(concurrent_queue, ^{
        [userCenterDic setObject:obj forKey:key];
    });
}

@end

```

## 三. dispatch_group

>dispatch_group_async

>dispatch_group_notify

### 1. 使用GCD实现以下需求：A、B、C三个任务并发，完成后执行D?

实际开发的使用场景
1.并发请求多个图片，当所有图片都下载完成之后，把他们拼接成一张图片来使用
2.蓝牙打印(公司项目需求)

![dispatch_group.png](https://i.loli.net/2021/02/25/8KeuTiRCcG3rbSD.png)

```
//
//  GroupObject.m
//  GCD
//  dispatch_group
//

#import "GroupObject.h"

@interface GroupObject()
{
    dispatch_queue_t concurrent_queue;
    NSMutableArray <NSURL *> *arrayURLs;
}

@end

@implementation GroupObject

- (id)init
{
    self = [super init];
    if (self) {
        // 创建并发队列
        concurrent_queue = dispatch_queue_create("concurrent_queue", DISPATCH_QUEUE_CONCURRENT);
        arrayURLs = [NSMutableArray array];
    }

    return self;
}

- (void)handle
{
    // 创建一个group
    dispatch_group_t group = dispatch_group_create();
    
    // for循环遍历各个元素执行操作
    for (NSURL *url in arrayURLs) {
        
        // 异步组分派到并发队列当中
        dispatch_group_async(group, concurrent_queue, ^{
            
            //根据url去下载图片
            
            NSLog(@"url is %@", url);
        });
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 当添加到组中的所有任务执行完成之后会调用该Block
        NSLog(@"所有图片已全部下载完成");
    });
}




@end

```


# NSOperation

### 1. 利用NSOperation实现多线程方案有哪些优势或特点呢？

NSOperation需要和NSOperationQueue配合使用来实现多线程方案

优势
- 添加任务依赖
- 任务执行状态控制
- 最大并发量

### 2. 我们可以控制NSOperation的哪些任务状态？
- isReady：当前任务是否处于就绪状态。
- isExecuting：当前任务是否处于正在执行中状态。
- isFinished：当前任务是否处于已执行完成状态。
- isCancelled：当前任务是否处于已取消状态。

