# iOS面试题备忘录(七) - 多线程

![multi-thread.png](https://i.loli.net/2021/02/24/RDuT1bgNvxXdlo2.png)

# 基础知识

## 一. 进程和线程

### 1. 进程 process[ˈprɑːses]

- **进程是操作系统分配资源的基本单元**    
进程是一个具有一定独立功能的程序关于某次数据集合的一次运行活动，它是操作系统分配资源的基本单元。  

- **进程是指在系统中正在运行的一个应用程序**  
进程是指在系统中正在运行的一个应用程序，即是一段程序的执行过程，我们可以理解为手机上的一个App。  

- **进程拥有独立运行所需的全部资源**  
每个进程之间是独立的，每个进程均运行在其专用且受保护的内存空间内，拥有独立运行所需的全部资源。  

### 2. 线程 thread[θred]

- **线程是任务调度的基本单元**  
线程是程序执行流的最小单元，线程是进程中的一个实体。  

- **一个进程至少有一个线程**  
一个进程要想执行任务，必须至少有一个线程。**应用程序启动的时候，系统会默认开启一条线程，也就是主线程。**

### 3. 进程和线程的关系

- 线程是任务调度的基本单元，进程是操作系统分配资源的基本单元。

- 线程是进程的执行单元，进程的所有任务都在线程中执行。

- 一个程序可以对应多个进程(多进程)，一个进程中可有多个线程或至少要有一个线程。

- 同一个进程内的所有线程共享进程资源。

## 二. 多进程和多线程

### 1. 多进程 multi-process[ˈmʌlti ˈprɑːses] 

打开Mac的活动监视器，可以看到有多个进程同时运行。

- 进程是程序在计算机上的一次执行活动。  
当你运行一个程序，你就启动了一个进程。显然，程序是死的(静态的)，进程是活的(动态的)。

- 进程可以分为系统进程和用户进程。  
系统进程：用于完成操作系统的各种功能的进程，它们是处于运行状态下的操作系统本身。  
用户进程：由用户启动的进程。

- 进程又被细化为线程，也就是一个进程下有多个能独立运行的更小的单位。  
在同一个时间里，同一个计算机系统中如果允许两个或两个以上的进程处于运行状态，这便是多进程。

### 2. 多线程 multi-thread[ˈmʌlti θred]  

- 同一时间内，单核CPU只能处理一个线程，即只有一个线程在执行。多线程并发执行，其实是CPU快速地在多条线程之间调度(切换)。如果CPU调度线程的时间足够快，就造成了多线程同时执行的假象。

- 如果线程非常非常多，CPU会在N多个线程之间调度，会消耗大量的CPU资源，每条线程被调度执行的频次会降低(线程的执行效率降低)。

#### **多线程的优点**：  
- 能适当的提高程序的执行效率；  
- 能适当的提高资源利用率(CPU、内存利用率)。

#### **多线程的缺点**：  
开启线程需要占用一定的内存空间(默认情况下，主线程占用1M，子线程占用512KB)，如果开启大量的线程，会占用大量的内存空间，降低程序的性能。    
线程越多，CPU在调度线程上的开销就越大。    
程序设计更加复杂，比如线程之间的通信、多线程的数据共享。

## 三. GCD 任务和队列

### 1. 任务 task

任务：就是执行操作的意思，也就是在线程中执行的那段代码。在GCD中是放在block中的。

**执行任务有两种方式：同步执行(sync)和异步执行(async)。**  

同步和异步主要体现在能不能开启新的线程，以及会不会阻塞当前线程。  

- **同步 sync[sɪŋk]**  
在当前线程中执行任务，不具备开启新线程的能力。  
同步任务会阻塞当前线程。

- **异步 async**    
在新的线程中执行任务，具备开启新线程的能力。并不一定会开启新线程，比如在主队列中通过异步执行任务并不会开启新线程。  
异步任务不会阻塞当前线程。

### 2. 队列 dispatch queue[dɪˈspætʃ kjuː] 

**这里的队列代表：GCD中的调度队列**  

队列：指执行任务的等待队列，即用来存放任务的队列。  
队列是一种特殊的线性表，采用FIFO(先进先出)的原则。即新任务总是被插入到队列的末尾，读取任务的时候总是从队列的头部开始读取。每读取一个任务，则从队列中释放一个任务。  

在GCD中，有两种调度队列：`串行队列`和`并发队列`。

两者都符合**FIFO**(**先进先出**)的原则。

两者的主要**区别**是：**执行顺序不同**，以及**开启线程数不同**。

- **串行队列 Serial[ˈsɪəriəl] Dispatch Queue**  
同一时间内，队列中只能执行一个任务。  
只有当前的任务执行完成之后，才能执行下一个任务。(只开启一个线程，一个任务执行完毕后，再执行下一个任务)。  
**主队列是主线程上的一个串行队列，是系统自动为我们创建的。**

- **并发队列 Concurrent[kənˈkʌrənt] Dispatch Queue**  
同一时间内，允许多个任务并发执行。(可以开启多个线程，并且同时执行任务)。  
并发队列的并发功能只有在异步(dispatch_async)函数下才有效。  
**全局队列是系统提供的并发队列。**

### 3. 串行、并行和并发三者的区别

- 串行：表示在某个时刻只有一个任务在执行
- 并行：表示在某个时刻有多个任务在执行
- 并发：表示在某个时间间隔有多个任务在执行

![multi-thread2.png](https://pic2.zhimg.com/v2-e474a26c5a4485d3c378e95f8c9979e9_r.jpg)

举例：CPU执行任务 
- 单核CPU非并发执行任务：单核CPU一次处理一个完整任务。
- 单核CPU并发执行任务：单核CPU交替处理多个任务，每次只处理某个任务的一部分。
- 多核CPU非并发执行任务：多核CPU一次处理一个任务，将任务拆分成多个子任务，多个核心同时单独的执行这些子任务。
- 多核CPU并发执行任务：多核CPU一次处理多个任务，将任务拆分，多个核心同时单独的执行这些子任务。

问题：既然串行和并行是反义词，为什么都说并发队列，而不说并行队列？

计算机硬件和系统可能并非能真正的并行执行任务。比如单核CPU，也可以实现并发，但是不具有并行能力。

# 四. iOS中的多线程

- NSThread
- NSOperation和NSOperationQueue
- GCD

## 1. NSThread

NSThread：轻量级别的多线程技术。  
管理多线程困难，推荐使用NSOperation和GCD。

```
[NSThread currentThread]; // 获取当前线程 
[NSThread mainThread]; // 获取主线程
```

### 1.1 开辟子线程

#### 使用NSThread开辟子线程

NSThread是我们自己手动开辟的子线程。

- 如果使用的是初始化方式，需要我们自己启动；  
- 如果使用的是构造器方式，它就会自动启动。

只要是我们手动开辟的线程，都需要我们自己管理该线程，不只是启动，还有该线程使用完毕后的资源回收。

```
// 1. 通过初始化方式开辟子线程
NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(testThread:) object:@"我是参数"];

// 使用初始化方法创建的子线程需要启动start
[thread start];

// 可以为开辟的子线程起名字
thread.name = @"NSThread线程";

// 调整thread的权限：线程权限的范围值为0~1，默认值是0.5。
// 范围值越大权限越高，所以先执行的概率就会越高。
// 由于是概率，所以并不能很准确的实现我们想要的执行顺序。
thread.threadPriority = 1;

// 取消当前已经启动的线程
[thread cancel];

// 2. 通过遍历构造器开辟子线程
[NSThread detachNewThreadSelector:@selector(testThread:) toTarget:self withObject:@"构造器方式"];
```

#### 使用performSelector开辟子线程

只要是NSObject的子类或者对象都可以通过调用`performSelector方法`进入子线程和主线程，其实这些方法所开辟的子线程也是NSThread的另一种体现方式。  

在编译阶段并不会去检查方法是否有效存在，如果不存在只会给出警告。

```
// 使用performSelector开辟子线程
[self performSelector:@selector(testThread:) withObject:nil afterDelay:1];

// 回到主线程
// waitUntilDone：是否将该回调方法执行完再执行后面的代码。
// 如果为YES：就必须等回调方法执行完成之后才能执行后面的代码，说白了就是阻塞当前的线程；
// 如果是NO：就是不等回调方法结束，不会阻塞当前线程。
[self performSelectorOnMainThread:@selector(testThread:) withObject:nil waitUntilDone:YES];

// 开辟子线程
[self performSelectorInBackground:@selector(testThread:) withObject:nil];

// 在指定线程执行
[self performSelector:@selector(testThread:) onThread:[NSThread currentThread] withObject:nil waitUntilDone:YES]
```

**注意**：  
1. 如果是带`afterDelay`的延时函数，会在内部创建一个NSTimer，然后添加到当前线程的RunLoop中。  
如果当前线程没有开启RunLoop，该方法会失效。  
在子线程中，需要启动RunLoop(注意调用顺序)。

2. `performSelector:withObject:`只是一个单纯的消息发送，和时间没有一点关系。所以不需要添加到子线程的RunLoop中也能执行。

```
[self performSelector:@selector(testThread:) withObject:nil afterDelay:1];
[[NSRunLoop currentRunLoop] run];
```

### 1.2 应用场景

NSThread和runLoop结合实现常驻线程。

## 2. NSOperation和NSOperationQueue

### 2.1 操作 NSOperation
operation：执行操作的意思，即在线程中执行的那段代码。

在GCD中是放在block中的。而在NSOperation中，使用NSOperation的子类NSInvocationOperation、NSBlockOperation或者自定义子类来封装操作。

#### 特点
- 可以控制暂停、恢复、停止：suspended、cancel、cancelAllOperations  
- 可以控制任务的优先级：threadPriority、queuePriority
- 可以设置任务依赖：addDependency、removeDependency 
- 可以设置最大并发操作数，来控制串行或并发：maxConcurrentOperationCount
- NSOperation有两个封装的便利子类，他们都使用了并发队列：NSBlockOperation、NSInvocationOperation

### 2.2 操作队列 NSOperationQueue
operation queue：这里的队列指操作队列，即用来存放操作的队列。

不同于GCD中的调度队列FIFO(先进先出)的原则。NSOperationQueue对于添加到队列中的操作，首先进入准备就绪的状态(就绪状态取决于操作之间的依赖关系)，然后进入就绪状态的操作的开始执行顺序(非结束执行顺序)由操作之间相对的优先级决定(优先级是操作对象自身的属性)。

#### 种类
- 主队列：[NSOperationQueue mainQueue]  
运行在主线程上，是串行队列。

- 自定义队列：[NSOperationQueue new]  
在后台执行，是并发队列。

### 2.3 NSOperationQueue与GCD关系

GCD是面向底层的C语言的API；NSOpertaionQueue用GCD构建封装的，是GCD的高级抽象。

- GCD执行效率更高  
由于队列中执行的是由block构成的任务，这是一个轻量级的数据结构，写起来更方便。

- GCD只支持FIFO的队列，而NSOperationQueue可以通过设置最大并发数、设置优先级、添加依赖关系等调整执行顺序。

- NSOperationQueue可以跨队列设置依赖关系，但是GCD只能通过设置串行队列或者在队列内添加`barrier(dispatch_barrier_async)`任务，才能控制执行顺序，较为复杂。

- NSOperationQueue因为面向对象，所以支持KVO，可以监测operation是否正在执行(isExecuted)、是否结束(isFinished)、是否取消(isCanceld)等。

**注意**：

- 实际项目开发中，很多时候只是会用到异步操作，不会有特别复杂的线程关系管理，所以苹果推崇的且优化完善、运行快速的GCD是首选。

- 如果考虑异步操作之间的事务性、顺序性、依赖关系，比如多线程并发下载，GCD需要自己写更多的代码来实现，而NSOperationQueue已经内建了这些支持。

- 不论是GCD还是NSOperationQueue，我们接触的都是任务和队列，都没有直接接触到线程。  
事实上，线程管理也的确不需要我们操心，系统对于线程的创建、调度管理和释放都做得很好。  
而NSThread需要我们自己去管理线程的生命周期，还要考虑线程同步、加锁问题，会造成一些性能上的开销。

## 3. GCD

### 3.1 队列

GCD共有三种队列类型

- 主队列(main queue)：通过`dispatch_get_main_queue()`获得，这是一个与主线程相关的串行队列(**主队列是串行队列**)。
- 全局队列(global queue)：**全局队列是并发队列**，由整个进程共享。存在着高、中、低三种优先级的全局队列。调用`dispath_get_global_queue`并传入优先级来访问队列。
- 自定义队列：通过函数`dispatch_queue_create`创建的队列。

### 3.2 同步/异步和串行/并发

GCD调动的4种组合

- `同步串行`：同步分派任务到串行队列上
```
dispatch_sync(serial_queue, ^{ //任务 });
```

- `异步串行`：异步分派任务到串行队列上
```
dispatch_async(serial_queue, ^{ //任务 });
```

- `同步并发`：同步分派任务到并发队列上
```
dispatch_sync(concurrent_queue, ^{ //任务 });
```

- `异步并发`：异步分派任务到并发队列上
```
dispatch_async(concurrent_queue, ^{ //任务 });
```

### 3.3 栅栏函数dispatch_barrier_async和dispatch_barrier_sync

- dispatch_barrier_sync：同步栅栏调用。  
将添加到queue前面的任务执行完之后，才会执行后面的任务，并不会阻塞当前的线程。

- dispatch_barrier_async：异步栅栏调用，用来解决多读单写的问题。   
将添加到queue前面的任务执行完之后，才会执行后面的任务，并且会阻塞当前的线程。

dispatch_barrier_sync和dispatch_barrier_async的区别：在于会不会阻塞当前线程

dispatch_barrier_sync用法
```
dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);

for (NSInteger i = 0; i < 10; i++) {
    dispatch_async(concurrentQueue, ^{
        NSLog(@"%zd", i);
    });
}

dispatch_barrier_sync(concurrentQueue, ^{
    NSLog(@"dispatch_barrier_sync");
});

for (NSInteger i = 10; i < 20; i++) {
    dispatch_async(concurrentQueue, ^{
        NSLog(@"%zd", i);
    });
}
```
这里的dispatch_barrier_sync上的队列要和需要阻塞的任务在同一队列上，否则是无效的。   
从打印上看，任务0-9和任务10-19因为是异步并发的原因，彼此是无序的。  
而由于栅栏函数的存在，导致顺序必然是先执行任务0-9，再执行栅栏函数，再去执行任务10-19。

### 3.4 dispatch_group_async和dispatch_group_notify

实际开发的使用场景  
1.并发请求多个图片，当所有图片都下载完成之后，把他们拼接成一张图片来使用。  
2.在多个网络请求完成后去刷新UI页面。

### 3.5 延时函数dispatch_after

dispatch_after 能让我们添加进队列的任务延时执行，该函数并不是在指定时间后执行处理，而只是在指定 时间追加处理到 dispatch_queue 由于其内部使用的是 dispatch_time_t 管理时间，而不是 NSTimer。 所以如果在子线程中调用，相比 performSelector:afterDelay,不用关心 runloop 是否开启

```
// 第一个参数是time，第二个参数是dispatch_queue，第三个参数是要执行的block dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
      NSLog(@"dispatch_after");
  });
```

### 3.6 使用dispatch_once实现单例

```
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static id instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
```

# 面试题 

## 一. GCD - 同步/异步和串行/并发

### 1. 以下代码是否有问题？如果有问题，怎样解决？
```
- (void)viewDidLoad {
    // dispatch_sync(serial_queue, ^{//任务}); - 同步串行 
    // dispatch_get_main_queue() - 主队列是串行队列
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self doSomething];
    });
}
```

回答：

![sync_main.png](https://i.loli.net/2021/02/24/7o2saxWpzLMmrYy.png)

**以上代码会因`队列`引起的`循环等待`而产生`死锁`**。  

根据代码可知：  
- -viewDidLoad方法是在主线程中执行；同步函数添加的Block任务是在当前线程中执行，当前线程就是主线程，所以Block也在主线程中执行。
- 根据顺序，首先会在主线程中执行-viewDidLoad方法。在执行-viewDidLoad方法过程中需要调用Block任务，当Block任务同步调用完成之后，-viewDidLoad方法才能继续向下走。因此，-viewDidLoad方法的调用能否结束需要依赖于后续提交的Block任务。
- 而Block任务若想执行，需要依赖于**主队列先进先出**的特性，即Block任务需要等待-viewDidLoad方法处理完成后才能处理Block任务的提交。
- 由此发生了**相互等待**的情况，即产生**死锁**。

**注意：**  
- **主队列是串行队列。**
- **`主队列`中提交的`任务`，无论通过`同步`还是`异步`方式，最终都要`在主线程`中处理和执行。**
- **两个任务`同步`分派到串行队列时，就会产生`循环等待`的问题。**

解决方案1：异步串行
```
- (void)viewDidLoad {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self doSomething];
    });
}
```

解决方案2：自定义一个串行队列
```
- (void)viewDidLoad {
    // 自定义串行队列
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL); 
    dispatch_sync(serialQueue, ^{
        [self doSomething];
    });
}
```

### 2. 以下代码是否有问题？如果有问题，怎样解决？
```
dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL); 

dispatch_async(serialQueue, ^{ // 异步串行
    dispatch_sync(serialQueue, ^{ // 同步串行
        [self doSomething];
    });
});
```
回答：  
外面的函数无论是同步还是异步都会造成死锁。    
这是因为里面的任务和外面的任务都在同一个serialQueue队列内，又是同步，这就和上边主队列同步的例子一样造成了死锁。  
解决方法也和上边一样，将里面的同步改成异步dispatch_async，或者将serialQueue换成其他串行或并发队列，都可以解决。  

解决：  
这样是不会死锁的，并且serialQueue和serialQueue2是在同一个线程中的。
```
dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL); 
dispatch_queue_t serialQueue2 = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL); 

dispatch_async(serialQueue, ^{
    dispatch_sync(serialQueue2, ^{
        [self doSomething];
    });
});
```

### 3. 以下代码是否有问题？
```
- (void)viewDidLoad {
    // 自定义串行队列
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL); 
    dispatch_sync(serialQueue, ^{
        [self doSomething];
    });
}
```

![sync_serial.png](https://i.loli.net/2021/02/24/iXkWAcUeo5RFLBJ.png)

回答：  
以上代码运行没有问题。 

原因如下：
1. -viewDidLoad方法在主队列中处理；Block任务是在自定义的串行队列中处理。
2. 在主队列提交-viewDidLoad方法，-viewDidLoad分派到主线程中执行。
3. -viewDidLoad方法执行到某一时刻时，需要同步block任务到对应的自定义的串行队列中；自定义串行队列中的block任务由于是同步方式提交的，即同步提交意味在**当前线程执行**，因此，串行队列的block任务最终也会在主线程中执行。
4. 当串行队列的block任务在主线程中执行完成后，再继续执行主队列中的-viewDidLoad方法当中的后续的代码逻辑。

### 4. 以下代码输出什么结果？
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

回答： 
输出日志
```
12345
```

- **全局队列是并发队列。**
- **只要以同步方式提交任务，无论提交到串行队列还是并发队列，最终都是在当前线程中执行。**

### 5. 异步串行

>dispatch_async(serial_queue, ^{//任务});

```
- (void)viewDidLoad {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self doSomething];
    });
}
```

### 6. 以下代码输出什么结果？
```
dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);

NSLog(@"1");

dispatch_async(serialQueue, ^{
    NSLog(@"2");
});

NSLog(@"3");

dispatch_sync(serialQueue, ^{
    NSLog(@"4");
});

NSLog(@"5");

```

回答：输出日志
```
13245
```

1. 首先，打印"1"；   
2. 接下来将任务"2"添加至串行队列上，由于任务"2"是异步任务，不会阻塞线程，所以继续向下执行；  
3. 打印"3"；  
4. 然后是将任务"4"添加至串行队列上，由于任务"4"和任务"2"在同一个串行队列中，根据**队列先进先出**的原则，任务"4"必须等任务"2"执行完成后才能执行，所以，打印"2"；  
5. 又因为任务"4"是同步任务，会阻塞线程，所以只有执行完任务"4"才能继续向下执行，所以，打印"4"；
6. 最后打印"5"。

注意：  
这里的任务"4"在主线程中执行，而任务"2"在子线程中执行。  
如果任务"4"是添加到另一个串行队列或者并发队列，则任务"2"和任务"4"无序执行。(可以添加多个任务看效果)

### 7. 以下代码输出什么结果？
前提：interview方法在主线程中调用
```
- (void)interview {
    NSLog(@"1");
    
    dispatch_queue_t serial_queue = dispatch_queue_create("serial_queue", DISPATCH_QUEUE_SERIAL);

    dispatch_async(serial_queue, ^{
        NSLog(@"2");
        
        dispatch_sync(serial_queue, ^{
            NSLog(@"3");
        });
    
        NSLog(@"4");
    });
    
    NSLog(@"5");
}
```
回答：  
```
输出1、5、2后卡死
由于队列引起的循环等待而产生死锁。
```

解释：  
- 首先打印"1"
- 然后自己创建了一个串行队列，并通过异步函数向这个队列中添加一个任务块(block1)；异步函数会开启一个子线程并将block1放入子线程中去执行，开启子线程是要耗时的，而且异步任务不需要等待就可以继续执行它后面的代码，所以打印"5"在block1前面执行。  
- 再来看block1任务块，先打印"2"，然后通过同步函数添加的block2任务块需要立马执行，而block1所在的队列是串行队列，block1任务块还没执行完，所以要先等block1执行，而block1又要等block2执行完了才能继续往下执行，所以就造成了相互等待而死锁。

### 8. 以下代码输出什么结果？
前提：interview方法在主线程中调用
```
- (void)interview {

    NSLog(@"1");

    dispatch_queue_t serial_queue = dispatch_queue_create("serial_queue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t serial_queue2 = dispatch_queue_create("serial_queue2", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        NSLog(@"2");
        
        dispatch_sync(queue2, ^{
            NSLog(@"3");
        });
        
        NSLog(@"4");
    });
    
    NSLog(@"5");
}
```
输出
```
15234
```
解释： 
- block1任务块和block2任务块分别放在不同的队列中。  
- 先打印"1"再打印"5"和前面是一样的。  
- 然后异步函数会开启子线程去执行block1任务块，block1中先打印"2"，然后通过同步函数向另一个队列中添加block2任务块，由于两个block属于不同的队列，block2可以立马被安排执行而不会死锁，所以接着是打印"3"，最后打印"4"。

### 9. 以下代码输出什么结果？
前提：interview方法在主线程中调用
```
- (void)interview {
    NSLog(@"1");
    
    dispatch_queue_t concurrent_queue = dispatch_queue_create("concurrent_queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrent_queue, ^{
        NSLog(@"2");
        
        dispatch_sync(concurrent_queue, ^{
            NSLog(@"3");
        });
        
        NSLog(@"4");
    });
    
    NSLog(@"5");
}
```
回答：输出
```
15234
```
- 先打印任务1再打印任务5和前面是一样的。
- 然后异步函数会开启子线程去执行block1任务块，block1中先打印任务2，然后通过同步函数向并发队列中添加block2任务块，并发队列不需要等前一个任务完成就可以安排下一个任务执行，所以block2可以立马执行打印任务3，最后再打印任务4。

### 10. 以下代码输出什么结果？
```
- (void)viewDidLoad {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1");
        [self performSelector:@selector(printLog)
                   withObject:nil 
                   afterDelay:0];
        NSLog(@"3");
    });
}

- (void)printLog {
    NSLog(@"2");
}
```

回答：输出日志
```
13
```

1. `performSelector:withObject:afterDelay:`的本质是在`RunLoop`中添加定时器(即使延时时间是0秒)。
2. 在全局(并发)队列中通过异步函数执行Block任务会开启一个新的子线程，而子线程默认是没有启动RunLoop的，所以`performSelector:withObject:afterDelay:`方法会失效，不会执行`printLog`方法。 
3. 如果需要`performSelector:withObject:afterDelay:`有效执行，那么这个方法所属的**当前线程必须有RunLoop**。

#### ***** 解决方案1： 
**手动开启RunLoop，即在Block里面添加一行代码`[[NSRunLoop currentRunLoop] run]; `。**
```
- (void)viewDidLoad {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1");
        [self performSelector:@selector(printLog)
                   withObject:nil 
                   afterDelay:0];
        [[NSRunLoop currentRunLoop] run];
        NSLog(@"3");
    });
}

- (void)printLog {
    NSLog(@"2");
}
```
输出日志
```
123
```

#### ***** 解决方案2：
**将dispatch_get_global_queue(0, 0)改为dispatch_get_main_queue()**  
主队列所在的主线程默认开启RunLoop，所以可以执行printLog。输出日志132。
解释：  
在主(串行)队列中通过异步函数执行Block任务并不会开启新线程，异步任务是在当前线程即主线程中执行，而主线程的RunLoop默认是启动的，所以printLog会调用。  
虽然延迟时间时0秒，但是添加到RunLoop中的计时器不是立马触发的，而是要先唤醒RunLoop，这是需要消耗一定时间的，所以会先打印3再打印2。
```
- (void)viewDidLoad {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"1");
        [self performSelector:@selector(printLog)
                   withObject:nil 
                   afterDelay:0];
        NSLog(@"3");
    });
}

- (void)printLog {
    NSLog(@"2");
}
```
输出日志
```
132
```

#### ***** 解决方案3：
**将dispatch_async改成dispatch_sync**  
**同步**是在当前线程执行，那么如果当前线程是主线程，可以执行printLog，输出132。
解释：  
同步函数添加的任务是在当前线程中执行，当前线程就是主线程，而主线程的RunLoop是启动的，所以printLog会调用。  
虽然延迟时间时0秒，但是添加到RunLoop中的计时器不是立马触发的，而是要先唤醒RunLoop，这是需要消耗一定时间的，所以会先打印3再打印2。
```
- (void)viewDidLoad {
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1");
        [self performSelector:@selector(printLog)
                   withObject:nil 
                   afterDelay:0];
        NSLog(@"3");
    });
}

- (void)printLog {
    NSLog(@"2");
}
```
输出日志
```
132
```

### 11. 以下代码输出什么结果？
```
- (void)viewDidLoad {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1");
        [self performSelector:@selector(printLog)
                   withObject:nil];
        NSLog(@"3");
    });
}

- (void)printLog {
    NSLog(@"2");
}
```
回答：输出日志
```
123
``` 
1. `performSelector:withObject:`函数是不涉及到计时器的，所以不会添加到RunLoop中，所以是按照1、2、3的顺序执行。
2. performSelector系列方法中只要是方法名中包含**afterDelay**、**waitUntilDone**的都是和计时器有关的，都要注意前面出现的这些问题。


## 二. GCD - dispatch_barrier_async

### 1. 怎样利用GCD实现多读单写？

利用GCD的栅栏异步调用`dispatch_barrier_async(concurrent_queue, ^{//写操作});`实现多读单写。

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

// 读者
- (id)objectForKey:(NSString *)key
{
    __block id obj;
    // 同步读取指定数据
    dispatch_sync(concurrent_queue, ^{
        obj = [userCenterDic objectForKey:key];
    });
    
    return obj;
}

// 写者
- (void)setObject:(id)obj forKey:(NSString *)key
{
    // 异步栅栏调用设置数据
    dispatch_barrier_async(concurrent_queue, ^{
        [userCenterDic setObject:obj forKey:key];
    });
}

@end

```

### 2. 以下代码的执行结果是什么？

```
- (void)viewDidLoad {
    [super viewDidLoad];
    _queue = dispatch_queue_create("com.htmi.Zc", DISPATCH_QUEUE_CONCURRENT);
    [self barrier];
}

- (void)barrier {
    NSLog(@"start");

    dispatch_async(_queue, ^{
        NSLog(@"1");
    });

    dispatch_async(_queue, ^{
        NSLog(@"2");
    });

    dispatch_barrier_async(_queue, ^{
        NSLog(@"3");
    });

    NSLog(@"6");

    dispatch_async(_queue, ^{
        NSLog(@"4");
    });

    dispatch_async(_queue, ^{
        NSLog(@"5");
    });

    NSLog(@"end");
}
```

回答：
```
执行顺序:
start  6  1  2  end   3  4  5 
```

### 3. 以下代码的执行结果是什么？

```
- (void)barrier {
    NSLog(@"start");

    dispatch_async(_queue, ^{
        sleep(3);
        NSLog(@"1");
    });

    dispatch_async(_queue, ^{
        NSLog(@"2");
    });

    dispatch_sync(_queue, ^{
        sleep(1);
        NSLog(@"7");
    });

    dispatch_barrier_async(_queue, ^{
        NSLog(@"3");
    });

    NSLog(@"6");

    dispatch_async(_queue, ^{
        NSLog(@"4");
    });

    dispatch_async(_queue, ^{
        NSLog(@"5");
    });

    NSLog(@"end");
}
```

回答：
```
执行顺序:
start  2  6  7  end  1  3  4  5
```

### 4. 以下代码的执行结果是什么？

```
- (void)barrier{
    NSLog(@"start");

    dispatch_async(_queue, ^{
        sleep(3);
        NSLog(@"1");
    });

    dispatch_async(_queue, ^{
        NSLog(@"2");
    });

    dispatch_sync(_queue, ^{
        sleep(1);
        NSLog(@"7");
    });

    dispatch_barrier_sync(_queue, ^{
        NSLog(@"3");
    });

    NSLog(@"6");

    dispatch_async(_queue, ^{
        NSLog(@"4");
    });

    dispatch_async(_queue, ^{
        NSLog(@"5");
    });

    NSLog(@"end");
}
```

回答：
```
执行顺序:
start  2  7  1  3  6  end  4  5
```

## 三. GCD - dispatch_group_async和dispatch_group_notify

### 1. 使用GCD实现以下需求：A、B、C三个任务并发，完成后执行D?

![dispatch_group.png](https://i.loli.net/2021/02/25/8KeuTiRCcG3rbSD.png)

在n个耗时并发任务都完成后，再去执行接下来的任务。

实际开发的使用场景  
1.并发请求多个图片，当所有图片都下载完成之后，把他们拼接成一张图片来使用。  
2.在多个网络请求完成后去刷新UI页面。

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
            // 根据url去下载图片
            ...
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

## 四. NSOperation

### 1. 利用NSOperation实现多线程方案有哪些优势和特点呢？

NSOperation和NSOperationQueue配合使用来实现多线程方案。

优势和特点
- 可以添加任务依赖，方便控制执行顺序；    
通过NSOperation的addDependency、removeDependency来为相应的任务添加依赖或移除依赖。GCD和NSThread不具备这种特点。

- 可是设置操作执行的优先级；

- 可以控制任务的执行状态；  
NSOperation类提供了几种任务状态的判断，可以重写对应的方法来实现对应状态的控制。(任务状态：isReady、isExecuting、isFinished、isCancelled)

- 可以设置最大并发量：通过NSOperationQueue的成员变量maxConcurrentOperationCount来控制最大并发量。

### 2. 我们可以控制NSOperation的哪些任务状态？
- isReady：当前任务是否处于**就绪**的状态。
- isExecuting：当前任务是否处于**正在执行中**的状态。
- isFinished：当前任务是否处于**已完成**的状态。
- isCancelled：当前任务是否处于**已取消**的状态。

### 3. 怎样控制NSOperation的状态？

关于NSOperation状态的控制，主要看是否重写了NSOperation的start方法和main方法。

- 如果只重写了NSOperation的main方法，则系统底层会为我们控制变更任务的执行及完成状态，以及后续的线程Operation的退出。  

- 如果重写了NSOperation的start方法，则我们需要自行控制任务的状态。

### 4. 系统是怎样移除一个`isFinished = YES`的NSOperation的？

系统通过`KVO`方式来移除NSOperationQueue中所对应的Operation的，从而能够销毁NSOperation的对象。

### 5. 那你是否了解KVO的原理或机制呢？

请查阅其他章节。


## 五. NSThread

## NSThread的启动流程

1. 调用`start()`方法，创建`pthread`；
2. 调用`main()`方法；
3. 调用`[target performSelector:selector]`方法；
4. 调用`exit()`方法。

![NSThread.png](https://i.loli.net/2021/02/26/aXireNf5x1gpEHU.png)

### 1. 以下代码会输出什么结果？
```
- (void)viewDidLoad {
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"1---%@",[NSThread currentThread]);
    }];
    [thread start];
    
    [self performSelector:@selector(printLog) onThread:thread withObject:nil waitUntilDone:YES];
}

- (void)printLog {
    NSLog(@"2");
}
```
回答：运行闪退
```
1
*** Terminating app due to uncaught exception 'NSDestinationInvalidException', reason: '*** -[Interview performSelector:onThread:withObject:waitUntilDone:modes:]: target thread exited while waiting for the perform'
```
解释：  
从运行结果可以看出闪退的原因是target thread exited(目标线程退出)。  
因为printLog方法是在线程thread上执行的，但是线程thread在执行完`NSLog(@"1");`这句代码后就结束了，所以等到执行printLog方法时线程thread已经不存在了(严格来说是线程对象是还存在的，只是已经失活了，不能再执行任务了)。  

如果想要代码能正常运行，我们可以利用RunLoop知识来保活线程。  
先向当前runloop中添加一个source（如果runloop中一个source、NSTimer或Obserer都没有的话就会退出），然后启动runloop。  
也就是在线程thread的block中添加2行代码，如下所示：会输出：12。
```
- (void)viewDidLoad {
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"1---%@",[NSThread currentThread]);
        // 线程保活
        // 不写以下 runloop 代码的话 运行到performSelector:onThread:withObject:waitUntilDone:会闪退
        // 先向当前runloop中添加一个source（如果runloop中一个source、NSTime或Obserer都没有的话就会退出）
        [[NSRunLoop currentRunLoop] addPort:[NSPort new] forMode:NSRunLoopCommonModes];
        // 然后启动runloop
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }];
    [thread start];
    
    [self performSelector:@selector(printLog) onThread:thread withObject:nil waitUntilDone:YES];
}

- (void)printLog {
    NSLog(@"2");
}
```

### 2. 如何实现常驻线程？如何通过NSThread和runLoop来实现常驻线程？

由于每次开辟子线程都会消耗cpu，在需要频繁使用子线程的情况下，频繁开辟子线程会消耗大量的cpu，而且创建线程都是任务执行完成之后也就释放了，不能再次利用，那么如何创建一个线程可以让它可以再次工作呢？也就是创建一个常驻线程。

```
+ (NSThread *)shareThread {
    static NSThread *shareThread = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadTest) object:nil];
        [shareThread setName:@"threadTest"];
        [shareThread start];
    });
    return shareThread;
}

+ (void)threadTest {
    @autoreleasepool {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [runLoop run];
    }
}
```

### 3. NSThread的实现机制是什么？或start方法的内部原理？



## 六. 多线程与锁

### 1. 你都用过哪些琐？结合实际谈谈你是怎样使用的？

知识点梳理会尽量全部写出来，但是当面试题时回答实际用过的就好。

- @synchronized  
应用场景 - 创建单例对象的时候使用，保证多线程环境下创建的对象是唯一的。

- atomic：是修饰属性的关键字  
应用场景 - 对被修饰对象进行原子操作(不负责使用)，即对被修饰对象的`赋值`操作是可以`保证线程安全`，但对被修饰对象的`使用`是`不能保证线程安全`的。   
代码示例如下：
```
@property(atomic) NSMutableArray *array;

self.array = [NSMutableArray array]; // 能保证线程安全

[self.array addObject: obj]; // 不能保证线程安全！
```

- OSSpinLock：自旋锁，是一种循环等待的锁。   
应用场景 - 实际开发中没有使用过自旋锁，但是通过分析runtime的源码来学习系统关于自旋锁的使用。     
特点 -
    - `循环等待`访问，不释放当前资源。即类似于while循环，一直在访问是否能得到锁，如果不能获取到则继续轮询，直到获取到锁才停止循环。  
    - 用于轻量级的数据访问，比如，简单的int值+1/-1操作。(对内存管理和runtime的底层源码分析得知使用了自旋锁，即对引用计数进行+1或-1操作)   

- NSLock   
应用场景 - 解决细粒度的线程同步问题，来保证各个线程互斥，进入自己的临界区。    

- NSRecursiveLock：递归锁   
应用场景 - 递归锁用于递归方法中，或者涉及到锁重入的问题。

- dispatch_semaphore_t：信号量，是持有计数的信号。   
应用场景 -  
    - 保持线程同步，将异步执行任务转换为同步执行任务； 
    - 保证线程安全，为线程加锁。
```
// 创建一个信号量并初始化信号的总量
dispatch_semaphore_create(1);

// 发送一个信号，让信号总量加1
dispatch_semaphore_signal(semaphore);

// 可以使总信号量减1，当信号总量为0时就会一直等待(阻塞所在线程)，否则就可以正常执行。
// 参数1：等待的信号量是哪个，参数2：等待的时长
dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
```

**dispatch_semaphore_create()方法的内部实现**  
```
struct semaphore {
    int value;
    List <thread>;
}
```
在该方法中，实例化了struct semaphore，其中value是信号量的值，list是关于线程的PCB或者线程唯一标识所维护的线程列表或者队列。  

**dispatch_semaphore_wait()方法的内部实现**   
```
{
    S.value = S.value - 1;
    if S.value < 0 then Block(S.list); // 阻塞是一个主动行为
}
```
即P操作：  
if value < 0，将该进程状态置为等待状态并阻塞，将该进程的PCB插入响应等待队列中。  
阻塞是一个主动行为。

**dispatch_semaphore_signal()方法的内部实现**  
```
{
    S.value = S.value + 1;
    if S.value <= 0 then wakeup(S.list); // 唤醒是一个被动行为
}
```
即V操作：  
if value < 0，则会唤醒响应等待队列中等待的一个进程，改变其状态为就绪状态，并将其插入就绪队列。    
唤醒是一个被动行为。    

### 2. 以下代码会有什么问题？如何解决？
```
- (void)methodA {
    [lock lock];
    [self methodB];
    [lock unlock];
}

- (void)methodB {
    [lock lock];
    // 操作逻辑
    ...
    [lock unlock];
}
```

问题 - 会产生死锁。    
原因 - 对同一把锁重入：由于某个线程的`methodA`方法已经调用了`lock`方法，加锁之后获取了这把锁，接着又调用了`methodB`方法，`methodB`方法中对同一把锁也调用了`lock`方法，这相当于**已经获取了这把锁又再次获取这把锁**，这种重入导致了死锁。        
解决方案 - 使用递归锁，NSRecursiveLock特性是可重入。

```
- (void)methodA {
    [recursiveLock lock];
    [self methodB];
    [recursiveLock unlock];
}

- (void)methodB {
    [recursiveLock lock];
    // 操作逻辑
    ...
    [recursiveLock unlock];
}
```

### 3. 我们在什么场景下使用信号量dispatch_semaphore_t呢？

- 保持线程同步：将异步执行任务转换为同步执行任务。
- 保证线程安全：为线程加锁。

#### 保持线程同步：将异步执行任务转换为同步执行任务。

多次运行的结果都是A,B,C顺序执行，让A,B,C异步执行变成同步执行，dispatch_semaphore相当于加锁效果。
```
// 信号量初始化必须大于等于0，因为dispatch_semaphore_wait执行的是-1操作。
dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

// 创建异步队列
dispatch_queue_t queue = dispatch_get_global_queue(0, 0);

// 异步并发
dispatch_async(queue, ^{
    sleep(1);
    NSLog(@"执行任务: A");
    // 让信号量+1
    dispatch_semaphore_signal(semaphore);
});

// 当前的信号量值=0时，会阻塞线程；如果大于0的话，信号量-1，不阻塞线程。(相当于加锁)
dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

// 异步并发
dispatch_async(queue, ^{
    sleep(1);
    NSLog(@"执行任务: B");
    // 让信号量+1（相当于解锁）
    dispatch_semaphore_signal(semaphore);
});

// 当前的信号量值=0时，会阻塞线程；如果大于0的话，信号量-1，不阻塞线程。
dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

// 异步并发
dispatch_async(queue, ^{    
    sleep(1);
    NSLog(@"执行任务: C");
    dispatch_semaphore_signal(semaphore);
});
```

#### 保证线程安全：为线程加锁。

```
- (void)viewDidLoad() {
    // 初始化信号量是1
    _semaphore = dispatch_semaphore_create(1);
    
    for (NSInteger i = 0; i < 100; i++) {
        // 异步并发调用asyncTask
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self asyncTask];
        });
    }
}

- (void)asyncTask {
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
    count ++;
    sleep(1);
    NSLog(@"执行任务：%zd", count);
    dispatch_semaphore_signal(_semaphore);
}
```
打印是从任务"1"顺序执行到"100"，没有发生两个任务同时执行的情况。

原因如下：  
在子线程中并发执行asyncTask，那么第一个添加到并发队列里的，会将信号量减1，此时信号量等于0，可以执行接下来的任务。而并发队列中其他任务，由于此时信号量不等于0，必须等当前正在执行的任务执行完毕后调用dispatch_semaphore_signal，将信号量加1，才可以继续执行接下来的任务，以此类推，从而达到线程加锁的目的。

### 4. 自旋锁与互斥锁

- 自旋锁：是一种用于保护多线程共享资源的锁  
与一般互斥锁(mutex)不同之处在于，当自旋锁尝试获取锁时，以忙等待(busy waiting)的形式不断地循环检查锁是否可用。  
当上一个线程的任务没有执行完毕的时候(被锁住)，那么下一个线程会一直等待(不会睡眠)；  
当上一个线程的任务执行完毕，那么下一个线程会立即执行。  
在多CPU的环境中，对持有锁较短的程序来说，使用自旋锁代替一般的互斥锁往往能够提高程序的性能。

- 互斥锁  
当上一个线程的任务没有执行完毕的时候(被锁住)，那么下一个线程会进入睡眠状态等待任务执行完毕；  
当上一个线程的任务执行完毕，那么下一个线程会自动唤醒然后执行任务。

**总结**：  
- 自旋锁会忙等：所谓忙等，即在访问被锁资源时，调用者线程不会休眠，而是不停循环在那里，直到被锁资源释放了锁。

- 互斥锁会休眠：所谓休眠，即在访问被锁资源时，调用者线程会休眠，此时CPU可以调度其他线程工作，直到被锁资源释放锁，此时会唤醒休眠线程。

**优缺点**：   
自旋锁的优点在于，因为自旋锁不会引起调用者睡眠，所以不会进行线程调度、CPU时间片轮转等耗时操作。所有如果能在很短的时间内获得锁，自旋锁的效率远高于互斥锁。  
缺点在于，自旋锁一直占用CPU，他在未获得锁的情况下，一直运行--自旋，所以占用着CPU，如果不能在很短的时间内获得锁，这无疑会使CPU效率降低。自旋锁不能实现递归调用。

自旋锁：atomic、OSSpinLock、dispatch_semaphore_t  
互斥锁：pthread_mutex、@synchronized、NSLock、NSConditionLock、NSCondition、NSRecursiveLock









1. 怎样用GCD实现多读单写？
2. iOS系统为我们提供的几种多线程技术各自的特点是怎样的？
- GCD：实现简单的线程同步，比如实现子线程的分派、实现多读单写等场景。
- NSOperation和NSOperationQueue：常见于第三方框架，如AFNetworking、SDWebImage，其特点是可以方便我们对任务状态的控制：添加依赖、移除依赖。
- NSThread：用来实现常驻线程。
3. NSOperation对象在finished之后是怎样从队列queue中移除掉的？  
NSOperation对象在finished之后，会在内部通过KVO方式通知内部的NSOperationQueue移除。
4. 你都用过哪些琐？结合实际谈谈你是怎样使用的？








