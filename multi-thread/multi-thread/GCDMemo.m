//
//  GCDMemo.m
//  multi-thread
//
//  Created by MickyChiang on 2021/3/5.
//

#import "GCDMemo.h"
/*
 同步和异步主要体现在能不能开启新的线程，以及会不会阻塞当前线程。
 同步：在当前线程中执行任务，不具备开启新线程的能力。同步任务会阻塞当前线程。
 异步：在新的线程中执行任务，具备开启新线程的能力。并不一定会开启新线程，比如在主队列中通过异步执行任务并不会开启新线程。异步任务不会阻塞当前线程。
 
 串行和并发主要影响任务的执行方式。
 串行：一个任务执行完毕后，再执行下一个任务。
 并发：多个任务并发(同时)执行。
 注意：如果当前队列是串行队列，通过同步函数向当前队列中添加任务会造成死锁。(串行队列中添加异步任务和并发队列中添加同步任务都不会死锁。)
 */
@implementation GCDMemo

// MARK: - 一.主队列 dispatch_get_main_queue
// MARK: - 1.主队列同步
/*
 主队列同步
 
 运行结果：crash
 原因：因队列引起的循环等待而产生死锁
 
 分析：
 [前提条件：当前线程是主线程]
 1.同步函数是在当前线程中执行任务，不具备开启新线程的能力；同步任务会阻塞当前线程。
 2.主队列是串行队列，如果通过同步函数向主队列中添加任务，那么并不会开启子线程来执行这个任务，而是在主线程中执行。
 3.将main_queue_dispatch_sync方法称作task1，将dispatch_sync同步函数添加的任务称作task2。
 4.队列遵循先进先出原则：task1和task2都在主队列中，主队列先安排task1到主线程执行，等task1执行完了才能安排task2到主线程执行，而task1又必须等task2执行完了才能继续往下执行，
 而task2又必须等task1执行完了才能被主队列安排执行，这样就造成了相互等待而卡死(死锁)。
 5.只要当前队列是串行队列，通过同步函数往当前队列添加任务都会造成死锁。
 */
- (void)main_queue_dispatch_sync {
    NSLog(@"主队列同步函数");
    
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    
    for (NSInteger i = 0; i < 5; i++) {
        dispatch_sync(main_queue, ^{
            [NSThread sleepForTimeInterval:1.0f]; // 模拟耗时操作
            NSLog(@"%ld--%@", i, [NSThread currentThread]);
        });
    }
    
    NSLog(@"----end----");
}

// MARK: - 2.主队列同步
/*
 主队列异步
 
 运行结果：
 2021-03-05 20:50:44.520862+0800 multi-thread[13329:4238571] 主队列异步函数
 2021-03-05 20:50:44.521147+0800 multi-thread[13329:4238571] ----end----
 2021-03-05 20:50:45.546323+0800 multi-thread[13329:4238571] 0--<NSThread: 0x600000b04380>{number = 1, name = main}
 2021-03-05 20:50:46.546926+0800 multi-thread[13329:4238571] 1--<NSThread: 0x600000b04380>{number = 1, name = main}
 2021-03-05 20:50:47.548554+0800 multi-thread[13329:4238571] 2--<NSThread: 0x600000b04380>{number = 1, name = main}
 2021-03-05 20:50:48.550152+0800 multi-thread[13329:4238571] 3--<NSThread: 0x600000b04380>{number = 1, name = main}
 2021-03-05 20:50:49.551625+0800 multi-thread[13329:4238571] 4--<NSThread: 0x600000b04380>{number = 1, name = main}
 
 分析：
 [前提条件：当前线程是主线程]
 1.异步函数是在新的线程中执行任务，具备开启新线程的能力，但并不一定会开启新线程，比如在主队列中通过异步执行任务并不会开启新线程；异步任务不会阻塞当前线程。
 2.主队列是串行队列，通过异步函数向主队列中添加任务，并不会开启新线程，即任务都是在主线程执行，并且是串行执行(FIFO原则)。
 */
- (void)main_queue_dispatch_async {
    NSLog(@"主队列异步函数");
    
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    
    for (NSInteger i = 0; i < 5; i++) {
        dispatch_async(main_queue, ^{
            [NSThread sleepForTimeInterval:1.0f]; // 模拟耗时操作
            NSLog(@"%ld--%@", i, [NSThread currentThread]);
        });
    }
    
    NSLog(@"----end----");
}

// MARK: - 二.全局队列 dispatch_get_global_queue
// MARK: - 1.全局队列同步
/*
 全局队列同步
 
 运行结果：
 2021-03-05 21:13:56.015161+0800 multi-thread[13691:4251767] 全局队列同步函数
 2021-03-05 21:13:57.016766+0800 multi-thread[13691:4251767] 0--<NSThread: 0x600002c985c0>{number = 1, name = main}
 2021-03-05 21:13:58.017288+0800 multi-thread[13691:4251767] 1--<NSThread: 0x600002c985c0>{number = 1, name = main}
 2021-03-05 21:13:59.018509+0800 multi-thread[13691:4251767] 2--<NSThread: 0x600002c985c0>{number = 1, name = main}
 2021-03-05 21:14:00.020028+0800 multi-thread[13691:4251767] 3--<NSThread: 0x600002c985c0>{number = 1, name = main}
 2021-03-05 21:14:01.020616+0800 multi-thread[13691:4251767] 4--<NSThread: 0x600002c985c0>{number = 1, name = main}
 2021-03-05 21:14:01.020999+0800 multi-thread[13691:4251767] ----end----
 
 分析：
 [前提条件：当前线程是主线程]
 1.同步函数是在当前线程中执行任务，不具备开启新线程的能力；同步任务会阻塞当前线程。
 2.全局队列是并发队列，如果通过同步函数向全局队列中添加任务，那么并不会开启子线程来执行这个任务，而是在主线程中执行。并且是串行执行(FIFO原则)。
 */
- (void)global_queue_dispatch_sync {
    NSLog(@"全局队列同步函数");
    
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (NSInteger i = 0; i < 5; i++) {
        dispatch_sync(global_queue, ^{
            [NSThread sleepForTimeInterval:1.0f]; // 模拟耗时操作
            NSLog(@"%ld--%@", i, [NSThread currentThread]);
        });
    }
    
    NSLog(@"----end----");
}

// MARK: - 2.全局队列异步
/*
 全局队列异步
 
 运行结果：
 2021-03-05 21:15:08.304741+0800 multi-thread[13734:4253807] 全局队列异步函数
 2021-03-05 21:15:08.304971+0800 multi-thread[13734:4253807] ----end----
 2021-03-05 21:15:09.307090+0800 multi-thread[13734:4253887] 1--<NSThread: 0x600001e3f780>{number = 3, name = (null)}
 2021-03-05 21:15:09.307085+0800 multi-thread[13734:4253884] 4--<NSThread: 0x600001e44d00>{number = 4, name = (null)}
 2021-03-05 21:15:09.307091+0800 multi-thread[13734:4253885] 0--<NSThread: 0x600001e424c0>{number = 7, name = (null)}
 2021-03-05 21:15:09.307091+0800 multi-thread[13734:4253882] 2--<NSThread: 0x600001e3b3c0>{number = 5, name = (null)}
 2021-03-05 21:15:09.307216+0800 multi-thread[13734:4253889] 3--<NSThread: 0x600001e48340>{number = 8, name = (null)}
 
 分析：
 [前提条件：当前线程是主线程]
 1.异步函数是在新的线程中执行任务，具备开启新线程的能力，但并不一定会开启新线程，比如在主队列中通过异步执行任务并不会开启新线程；异步任务不会阻塞当前线程。
 2.全局队列是并发队列，通过异步函数向全局队列添加的任务不是在当前线程执行，而是多个任务是在不同的线程中执行，并且是并发执行。
 */
- (void)global_queue_dispatch_async {
    NSLog(@"全局队列异步函数");
    
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (NSInteger i = 0; i < 5; i++) {
        dispatch_async(global_queue, ^{
            [NSThread sleepForTimeInterval:1.0f]; // 模拟耗时操作
            NSLog(@"%ld--%@", i, [NSThread currentThread]);
        });
    }
    
    NSLog(@"----end----");
}

// MARK: - 三.自定义队列 dispatch_queue_create
// MARK: - 1.自定义串行队列 DISPATCH_QUEUE_SERIAL
// MARK: - 1-1.自定义串行队列同步
/*
 自定义串行队列同步
 
 运行结果：
 2021-03-05 22:57:11.760386+0800 multi-thread[14883:4306213] 自定义串行队列同步函数
 2021-03-05 22:57:12.761464+0800 multi-thread[14883:4306213] 0--<NSThread: 0x600003388040>{number = 1, name = main}
 2021-03-05 22:57:13.762059+0800 multi-thread[14883:4306213] 1--<NSThread: 0x600003388040>{number = 1, name = main}
 2021-03-05 22:57:14.762558+0800 multi-thread[14883:4306213] 2--<NSThread: 0x600003388040>{number = 1, name = main}
 2021-03-05 22:57:15.762842+0800 multi-thread[14883:4306213] 3--<NSThread: 0x600003388040>{number = 1, name = main}
 2021-03-05 22:57:16.763464+0800 multi-thread[14883:4306213] 4--<NSThread: 0x600003388040>{number = 1, name = main}
 2021-03-05 22:57:16.763777+0800 multi-thread[14883:4306213] ----end----
 
 分析：
 [前提条件：当前线程是主线程]
 1.同步函数是在当前线程中执行任务，不具备开启新线程的能力；同步任务会阻塞当前线程。
 2.通过同步函数向自定义串行队列中添加的任务都是在当前线程中执行，不会开启新的线程，而且是串行执行(FIFO)。
 3.注意这个和通过同步函数向主队列添加任务不同。
 将custom_serial_queue_dispatch_sync方法称作task1，将同步函数添加的任务称作task2。
 这里两个task属于2个不同的队列，task1由主队列安排执行，task2由自定义串行队列来安排执行。
 首先主队列安排task1到主线程中执行，当执行到task2的地方时，由自定义串行队列安排task2到主线程中执行(无需等待task1完成)，
 等task2执行完后继续执行task1，所以这里不会造成线程堵塞。
 */
- (void)custom_serial_queue_dispatch_sync {
    NSLog(@"自定义串行队列同步函数");
    
    dispatch_queue_t serial_queue = dispatch_queue_create("com.memo.serialQueue", DISPATCH_QUEUE_SERIAL);
    
    for (NSInteger i = 0; i < 5; i++) {
        dispatch_sync(serial_queue, ^{
            [NSThread sleepForTimeInterval:1.0f]; // 模拟耗时操作
            NSLog(@"%ld--%@", i, [NSThread currentThread]);
        });
    }
    
    NSLog(@"----end----");
}

// MARK: - 1-2.自定义串行队列异步
/*
 自定义串行队列异步
 
 运行结果：
 2021-03-05 22:58:26.405791+0800 multi-thread[14920:4307665] 自定义串行队列异步函数
 2021-03-05 22:58:26.406325+0800 multi-thread[14920:4307665] ----end----
 2021-03-05 22:58:27.406469+0800 multi-thread[14920:4307741] 0--<NSThread: 0x600001fbc480>{number = 6, name = (null)}
 2021-03-05 22:58:28.406959+0800 multi-thread[14920:4307741] 1--<NSThread: 0x600001fbc480>{number = 6, name = (null)}
 2021-03-05 22:58:29.412585+0800 multi-thread[14920:4307741] 2--<NSThread: 0x600001fbc480>{number = 6, name = (null)}
 2021-03-05 22:58:30.413534+0800 multi-thread[14920:4307741] 3--<NSThread: 0x600001fbc480>{number = 6, name = (null)}
 2021-03-05 22:58:31.416662+0800 multi-thread[14920:4307741] 4--<NSThread: 0x600001fbc480>{number = 6, name = (null)}
 
 分析：
 [前提条件：当前线程是主线程]
 通过异步函数向自定义串行队列中添加的任务是在新开启的线程中执行，而且所有任务都是在同一个子线程中执行(也就是说多个任务只会开启一个子线程)，而且是串行执行(FIFO)。
 */
- (void)custom_serial_queue_dispatch_async {
    NSLog(@"自定义串行队列异步函数");
    
    dispatch_queue_t serial_queue = dispatch_queue_create("com.memo.serialQueue", DISPATCH_QUEUE_SERIAL);
    
    for (NSInteger i = 0; i < 5; i++) {
        dispatch_async(serial_queue, ^{
            [NSThread sleepForTimeInterval:1.0f]; // 模拟耗时操作
            NSLog(@"%ld--%@", i, [NSThread currentThread]);
        });
    }
    
    NSLog(@"----end----");
}

// MARK: - 2.自定义并发队列 DISPATCH_QUEUE_CONCURRENT
// MARK: - 2-1.自定义并发队列同步
/*
 自定义并发队列同步
 
 运行结果：
 2021-03-05 22:59:09.580891+0800 multi-thread[14949:4308578] 自定义并发队列同步函数
 2021-03-05 22:59:10.581620+0800 multi-thread[14949:4308578] 0--<NSThread: 0x600003120180>{number = 1, name = main}
 2021-03-05 22:59:11.582128+0800 multi-thread[14949:4308578] 1--<NSThread: 0x600003120180>{number = 1, name = main}
 2021-03-05 22:59:12.582819+0800 multi-thread[14949:4308578] 2--<NSThread: 0x600003120180>{number = 1, name = main}
 2021-03-05 22:59:13.583128+0800 multi-thread[14949:4308578] 3--<NSThread: 0x600003120180>{number = 1, name = main}
 2021-03-05 22:59:14.584434+0800 multi-thread[14949:4308578] 4--<NSThread: 0x600003120180>{number = 1, name = main}
 2021-03-05 22:59:14.584671+0800 multi-thread[14949:4308578] ----end----
 
 分析：
 [前提条件：当前线程是主线程]
 通过同步函数向自定义并发队列中添加的任务是在当前线程中执行，而且是串行执行(FIFO)。
 */
- (void)custom_concurrent_queue_dispatch_sync {
    NSLog(@"自定义并发队列同步函数");
    
    dispatch_queue_t concurrent_queue = dispatch_queue_create("com.memo.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    for (NSInteger i = 0; i < 5; i++) {
        dispatch_sync(concurrent_queue, ^{
            [NSThread sleepForTimeInterval:1.0f]; // 模拟耗时操作
            NSLog(@"%ld--%@", i, [NSThread currentThread]);
        });
    }
    
    NSLog(@"----end----");
}

// MARK: - 2-2.自定义并发队列异步
/*
 自定义并发队列异步
 
 运行结果：
 2021-03-05 22:59:44.289713+0800 multi-thread[14974:4309431] 自定义并发队列异步函数<##>
 2021-03-05 22:59:44.289935+0800 multi-thread[14974:4309431] ----end----
 2021-03-05 22:59:45.294478+0800 multi-thread[14974:4309532] 3--<NSThread: 0x600002be74c0>{number = 5, name = (null)}
 2021-03-05 22:59:45.294497+0800 multi-thread[14974:4309535] 1--<NSThread: 0x600002b952c0>{number = 6, name = (null)}
 2021-03-05 22:59:45.294478+0800 multi-thread[14974:4309529] 0--<NSThread: 0x600002b9ef00>{number = 8, name = (null)}
 2021-03-05 22:59:45.294478+0800 multi-thread[14974:4309534] 2--<NSThread: 0x600002b9cb00>{number = 3, name = (null)}
 2021-03-05 22:59:45.294596+0800 multi-thread[14974:4309530] 4--<NSThread: 0x600002be2440>{number = 9, name = (null)}
 
 分析：
 [前提条件：当前线程是主线程]
 通过异步函数向自定义并发队列添加的任务不是在当前线程执行，而是多个任务是在不同的线程中执行，并且是并发执行。
 */
- (void)custom_concurrent_queue_dispatch_async {
    NSLog(@"自定义并发队列异步函数");
    
    dispatch_queue_t concurrent_queue = dispatch_queue_create("com.memo.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    for (NSInteger i = 0; i < 5; i++) {
        dispatch_async(concurrent_queue, ^{
            [NSThread sleepForTimeInterval:1.0f]; // 模拟耗时操作
            NSLog(@"%ld--%@", i, [NSThread currentThread]);
        });
    }
    
    NSLog(@"----end----");
}

// MARK: - 四.栅栏函数 dispatch_barrier
/*
 栅栏函数 dispatch_barrier
 
 [概念]
 栅栏函数是GCD提供的用于阻塞分割任务的一组函数。
 其主要作用就是在队列中设置栅栏，来人为干预队列中任务的执行顺序。
 也可以理解为用来设置任务之间的依赖关系。
 栅栏函数分为同步栅栏函数和异步栅栏函数。
 
 [同步栅栏函数和异步栅栏函数的异同点]
 相同点：
 它们都将多个任务分割成了3个部分。
 第一个部分是栅栏函数之前的任务，是最先执行的；
 第二个部分是栅栏函数添加的任务，这个任务要等栅栏函数之前的任务都执行完了才会执行；
 第三个部分是栅栏函数之后的任务，这个部分要等栅栏函数里面的任务执行完了才会执行。
 
 不同点：
 同步栅栏函数不会开启新线程，其添加的任务在当前线程执行，会阻塞当前线程；
 异步栅栏函数会开启新线程来执行其添加的任务，不会阻塞当前线程。
 
 [注意事项]
 1.全局队列对栅栏函数是不生效的，必须是自己创建的并发队列。
 2.所有任务(包括栅栏函数添加的任务)都必须在同一个派发队列中，否则栅栏函数不生效。
 使用第三方网络框架(比如AFNetworking)进行网络请求时使用栅栏函数无效的正是因为这个原因导致。
 */

// *************** 业务场景 ***************
/*
 场景：
 一个大文件被分成part1和part2两部分存在服务器上，现在要将part1和part2都下载下来后然后合并最后写入磁盘。
 
 分析：
 这里其实有4个任务：下载part1是task1；下载part2是task2；合并part1和part2是task3；将合并后的文件写入磁盘是task4。
 这4个任务执行顺序是task1和task2并发异步执行，这两个任务都执行完了后再执行task3，task3执行完了再执行task4。
 */

// MARK: - 1.同步栅栏函数
/*
 同步栅栏函数
 
 运行结果：
 2021-03-08 20:35:20.302444+0800 multi-thread[23824:4808821] 当前线程1
 2021-03-08 20:35:20.302679+0800 multi-thread[23824:4808821] 当前线程2
 2021-03-08 20:35:20.302745+0800 multi-thread[23824:4808907] 开始下载part1---<NSThread: 0x60000313e300>{number = 6, name = (null)}
 2021-03-08 20:35:20.302832+0800 multi-thread[23824:4808821] 当前线程3
 2021-03-08 20:35:20.302968+0800 multi-thread[23824:4808908] 开始下载part2---<NSThread: 0x60000313ee00>{number = 3, name = (null)}
 2021-03-08 20:35:21.307472+0800 multi-thread[23824:4808908] 完成下载part2---<NSThread: 0x60000313ee00>{number = 3, name = (null)}
 2021-03-08 20:35:22.306460+0800 multi-thread[23824:4808907] 完成下载part1---<NSThread: 0x60000313e300>{number = 6, name = (null)}
 2021-03-08 20:35:22.306897+0800 multi-thread[23824:4808821] 开始合并part1和part2---<NSThread: 0x60000317c300>{number = 1, name = main}
 2021-03-08 20:35:23.307473+0800 multi-thread[23824:4808821] 完成合并part1和part2---<NSThread: 0x60000317c300>{number = 1, name = main}
 2021-03-08 20:35:23.307838+0800 multi-thread[23824:4808821] 当前线程4
 2021-03-08 20:35:23.308116+0800 multi-thread[23824:4808821] 当前线程5
 2021-03-08 20:35:23.308201+0800 multi-thread[23824:4808907] 开始写入磁盘---<NSThread: 0x60000313e300>{number = 6, name = (null)}
 2021-03-08 20:35:24.312640+0800 multi-thread[23824:4808907] 完成写入磁盘---<NSThread: 0x60000313e300>{number = 6, name = (null)}
 
 分析：
 [前提条件：当前线程是主线程]
 运行结果可以看出，需求的功能是实现了，但是有个问题，同步栅栏函数在分割任务的同时也阻塞了当前线程，
 这里当前线程是主线程，这就意味着在task1、task2和task3这3个任务都完成之前，UI界面是出于卡死状态的，
 这种用户体验显然是非常糟糕的。
 */
- (void)dispatch_barrier_sync {
    NSLog(@"当前线程1");
    
    dispatch_queue_t concurrent_queue = dispatch_queue_create("com.memo.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrent_queue, ^{
        NSLog(@"开始下载part1---%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:2.0f]; // 模拟下载耗时2s
        NSLog(@"完成下载part1---%@", [NSThread currentThread]);
    });
    
    NSLog(@"当前线程2");
    
    dispatch_async(concurrent_queue, ^{
        NSLog(@"开始下载part2---%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0f]; // 模拟下载耗时1s
        NSLog(@"完成下载part2---%@", [NSThread currentThread]);
    });
    
    NSLog(@"当前线程3");
    
    dispatch_barrier_sync(concurrent_queue, ^{
        NSLog(@"开始合并part1和part2---%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0f]; // 模拟下载耗时1s
        NSLog(@"完成合并part1和part2---%@", [NSThread currentThread]);
    });
    
    NSLog(@"当前线程4");
    
    dispatch_async(concurrent_queue, ^{
        NSLog(@"开始写入磁盘---%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0f]; // 模拟下载耗时1s
        NSLog(@"完成写入磁盘---%@", [NSThread currentThread]);
    });
    
    NSLog(@"当前线程5");
}

// MARK: - 2.异步栅栏函数 [xxxxx]
/*
 异步栅栏函数
 
 运行结果：
 2021-03-08 20:39:03.289037+0800 multi-thread[23885:4812698] 当前线程1
 2021-03-08 20:39:03.289484+0800 multi-thread[23885:4812783] 开始下载part1---<NSThread: 0x6000001fa600>{number = 6, name = (null)}
 2021-03-08 20:39:03.289899+0800 multi-thread[23885:4812698] 当前线程2
 2021-03-08 20:39:03.290780+0800 multi-thread[23885:4812785] 开始下载part2---<NSThread: 0x6000001878c0>{number = 4, name = (null)}
 2021-03-08 20:39:03.290645+0800 multi-thread[23885:4812698] 当前线程3
 2021-03-08 20:39:03.291373+0800 multi-thread[23885:4812698] 当前线程4
 2021-03-08 20:39:03.292013+0800 multi-thread[23885:4812698] 当前线程5
 2021-03-08 20:39:04.291896+0800 multi-thread[23885:4812785] 完成下载part2---<NSThread: 0x6000001878c0>{number = 4, name = (null)}
 2021-03-08 20:39:05.291470+0800 multi-thread[23885:4812783] 完成下载part1---<NSThread: 0x6000001fa600>{number = 6, name = (null)}
 2021-03-08 20:39:05.291834+0800 multi-thread[23885:4812783] 开始合并part1和part2---<NSThread: 0x6000001fa600>{number = 6, name = (null)}
 2021-03-08 20:39:06.297010+0800 multi-thread[23885:4812783] 完成合并part1和part2---<NSThread: 0x6000001fa600>{number = 6, name = (null)}
 2021-03-08 20:39:06.297539+0800 multi-thread[23885:4812785] 开始写入磁盘---<NSThread: 0x6000001878c0>{number = 4, name = (null)}
 2021-03-08 20:39:07.301790+0800 multi-thread[23885:4812785] 完成写入磁盘---<NSThread: 0x6000001878c0>{number = 4, name = (null)}
 
 分析：
 [前提条件：当前线程是主线程]
 从上面运行结果可以看出，异步栅栏函数不会阻塞当前线程，也就是说UI界面并不会被卡死。
 */
- (void)dispatch_barrier_async {
    NSLog(@"当前线程1");
    
    dispatch_queue_t concurrent_queue = dispatch_queue_create("com.memo.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrent_queue, ^{
        NSLog(@"开始下载part1---%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:2.0f]; // 模拟下载耗时2s
        NSLog(@"完成下载part1---%@", [NSThread currentThread]);
    });
    
    NSLog(@"当前线程2");
    
    dispatch_async(concurrent_queue, ^{
        NSLog(@"开始下载part2---%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0f]; // 模拟下载耗时1s
        NSLog(@"完成下载part2---%@", [NSThread currentThread]);
    });
    
    NSLog(@"当前线程3");
    
    dispatch_barrier_async(concurrent_queue, ^{
        NSLog(@"开始合并part1和part2---%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0f]; // 模拟下载耗时1s
        NSLog(@"完成合并part1和part2---%@", [NSThread currentThread]);
    });
    
    NSLog(@"当前线程4");
    
    dispatch_async(concurrent_queue, ^{
        NSLog(@"开始写入磁盘---%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0f]; // 模拟下载耗时1s
        NSLog(@"完成写入磁盘---%@", [NSThread currentThread]);
    });
    
    NSLog(@"当前线程5");
}

// MARK: - 五.任务组 dispatch_group
// *************** 业务场景 ***************
/*
 场景：
 某个界面需要请求banner信息和产品列表信息，等这两个接口的数据都返回后再回到主线程刷新UI。
 
 分析：
 这个需求通过栅栏函数和任务组都可以实现，
 任务组可以通过dispatch_async、dispatch_group_enter和dispatch_group_leave这3个API配合使用来实现，
 也可以通过dispatch_group_async这个API来实现。
 */

// MARK: - 1. dispatch_group_create + dispatch_group_enter + dispatch_group_leave + dispatch_async + dispatch_group_notify
/*
 dispatch_group_enter() + dispatch_group_leave() + dispatch_async()
 
 运行结果：
 2021-03-08 20:47:42.609862+0800 multi-thread[24132:4820360] 当前线程1
 2021-03-08 20:47:42.610210+0800 multi-thread[24132:4820360] 当前线程2
 2021-03-08 20:47:42.610275+0800 multi-thread[24132:4820449] 开始请求banner数据---<NSThread: 0x600002300f40>{number = 7, name = (null)}
 2021-03-08 20:47:42.610531+0800 multi-thread[24132:4820446] 开始请求产品列表数据---<NSThread: 0x6000023050c0>{number = 6, name = (null)}
 2021-03-08 20:47:42.610571+0800 multi-thread[24132:4820360] 当前线程3
 2021-03-08 20:47:42.610770+0800 multi-thread[24132:4820360] 当前线程4
 2021-03-08 20:47:43.611887+0800 multi-thread[24132:4820449] 收到banner数据---<NSThread: 0x600002300f40>{number = 7, name = (null)}
 2021-03-08 20:47:45.614900+0800 multi-thread[24132:4820446] 收到产品列表数据---<NSThread: 0x6000023050c0>{number = 6, name = (null)}
 2021-03-08 20:47:45.615291+0800 multi-thread[24132:4820360] 回到主线程刷新UI---<NSThread: 0x600002344580>{number = 1, name = main}
 
 分析：
 dispatch_group_notify监听任务组并不会阻塞当前线程
 
 如果换成dispatch_group_wait会阻塞当前线程。
 // 将等待时间设置为DISPATCH_TIME_FOREVER，表示永不超时，等任务组中任务全部都完成后才会执行其后面的代码
 dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
 */
- (void)GCDGroup1 {
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t concurrent_queue = dispatch_queue_create("com.memo.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"当前线程1");
    
    dispatch_group_enter(group); // 开始任务前将任务交给任务组管理，任务组中任务数+1
    
    dispatch_async(concurrent_queue, ^{
        NSLog(@"开始请求banner数据---%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0f]; // 模拟下载耗时1s
        NSLog(@"收到banner数据---%@", [NSThread currentThread]);
        dispatch_group_leave(group); // 任务结束后将任务从任务组中移除，任务组中任务数-1
    });
    
    NSLog(@"当前线程2");
    
    dispatch_group_enter(group); // 任务组中任务数+1
    
    dispatch_async(concurrent_queue, ^{
        NSLog(@"开始请求产品列表数据---%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:3.0f]; // 模拟下载耗时1s
        NSLog(@"收到产品列表数据---%@", [NSThread currentThread]);
        dispatch_group_leave(group); // 任务组中任务数-1
    });
    
    NSLog(@"当前线程3");
    
    // 监听任务组中的任务的完成情况，当任务组中所有任务都完成时指定队列安排执行block中的代码
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"回到主线程刷新UI---%@", [NSThread currentThread]);
    });
    
    NSLog(@"当前线程4");
}

// MARK: - 2. dispatch_group_create + dispatch_group_async + dispatch_group_notify [xxxxx]
/*
 dispatch_group_async
 
 运行结果：
 2021-03-08 20:48:58.993022+0800 multi-thread[24166:4822124] 当前线程1
 2021-03-08 20:48:58.993249+0800 multi-thread[24166:4822124] 当前线程2
 2021-03-08 20:48:58.993319+0800 multi-thread[24166:4822188] 开始请求banner数据---<NSThread: 0x6000031385c0>{number = 7, name = (null)}
 2021-03-08 20:48:58.993402+0800 multi-thread[24166:4822124] 当前线程3
 2021-03-08 20:48:58.993473+0800 multi-thread[24166:4822194] 开始请求产品列表数据---<NSThread: 0x6000031403c0>{number = 6, name = (null)}
 2021-03-08 20:48:58.993553+0800 multi-thread[24166:4822124] 当前线程4
 2021-03-08 20:48:59.998748+0800 multi-thread[24166:4822188] 收到banner数据---<NSThread: 0x6000031385c0>{number = 7, name = (null)}
 2021-03-08 20:49:01.997657+0800 multi-thread[24166:4822194] 收到产品列表数据---<NSThread: 0x6000031403c0>{number = 6, name = (null)}
 2021-03-08 20:49:01.998010+0800 multi-thread[24166:4822124] 回到主线程刷新UI---<NSThread: 0x600003108a80>{number = 1, name = main}
 
 分析：
 dispatch_group_notify监听任务组并不会阻塞当前线程
 
 如果换成dispatch_group_wait会阻塞当前线程。
 // 将等待时间设置为DISPATCH_TIME_FOREVER，表示永不超时，等任务组中任务全部都完成后才会执行其后面的代码
 dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
 */
- (void)GCDGroup2 {
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t concurrent_queue = dispatch_queue_create("com.memo.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"当前线程1");
    
    dispatch_group_async(group, concurrent_queue, ^{
        NSLog(@"开始请求banner数据---%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0f]; // 模拟下载耗时1s
        NSLog(@"收到banner数据---%@", [NSThread currentThread]);
    });
    
    NSLog(@"当前线程2");
    
    dispatch_group_async(group, concurrent_queue, ^{
        NSLog(@"开始请求产品列表数据---%@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:3.0f]; // 模拟下载耗时1s
        NSLog(@"收到产品列表数据---%@", [NSThread currentThread]);
    });
    
    NSLog(@"当前线程3");
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"回到主线程刷新UI---%@", [NSThread currentThread]);
    });
    
    NSLog(@"当前线程4");
}

// MARK: - 六.GCD中用于延迟将某个任务添加到队列中 dispatch_after
/*
 dispatch_after
 
 需求：从现在开始，延迟3秒后在主线程刷新UI。
 
 运行结果：
 2021-03-08 20:52:34.267477+0800 multi-thread[24252:4825532] 现在时间--2021-03-08 12:52:34 +0000
 2021-03-08 20:52:37.268168+0800 multi-thread[24252:4825532] 到主线程刷新UI--2021-03-08 12:52:37 +0000
 */
- (void)dispatch_after {
    NSLog(@"现在时间--%@", [NSDate date]);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"到主线程刷新UI--%@", [NSDate date]);
    });
}

// MARK: - 七.单例 dispatch_once 
/*
 GCD提供了dispatch_once()函数保证在应用程序生命周期中只执行一次指定处理。比如来生成单例。
 
 运行结果：
 2021-03-08 20:56:20.950329+0800 multi-thread[24340:4829108] 第0次开始执行--<NSThread: 0x600003d4c300>{number = 1, name = main}
 2021-03-08 20:56:20.950329+0800 multi-thread[24340:4829275] 第2次开始执行--<NSThread: 0x600003d0c080>{number = 3, name = (null)}
 2021-03-08 20:56:20.950370+0800 multi-thread[24340:4829269] 第1次开始执行--<NSThread: 0x600003d04180>{number = 6, name = (null)}
 2021-03-08 20:56:20.950553+0800 multi-thread[24340:4829108] 是否只执行了一次--<NSThread: 0x600003d4c300>{number = 1, name = main}
 2021-03-08 20:56:20.950694+0800 multi-thread[24340:4829108] 第0次结束执行--<NSThread: 0x600003d4c300>{number = 1, name = main}
 2021-03-08 20:56:20.950696+0800 multi-thread[24340:4829275] 第2次结束执行--<NSThread: 0x600003d0c080>{number = 3, name = (null)}
 2021-03-08 20:56:20.950696+0800 multi-thread[24340:4829269] 第1次结束执行--<NSThread: 0x600003d04180>{number = 6, name = (null)}
 */
- (void)dispatch_once_use {
    static GCDMemo *vc = nil;
    static dispatch_once_t onceToken;
    dispatch_apply(3, dispatch_get_global_queue(0, 0), ^(size_t idx) {
        NSLog(@"第%ld次开始执行--%@", idx, [NSThread currentThread]);
        dispatch_once(&onceToken, ^{
            vc = [[GCDMemo alloc] init];
            NSLog(@"是否只执行了一次--%@", [NSThread currentThread]);
        });
        NSLog(@"第%ld次结束执行--%@", idx, [NSThread currentThread]);
    });
}

// MARK: - 八.信号量 dispatch_semaphore
/*
 信号量 dispatch_semaphore  [ˈseməfɔːr]

 运行结果：
 2021-03-08 21:02:08.785467+0800 multi-thread[24467:4834923] 第1次开始执行--<NSThread: 0x6000002e4d40>{number = 4, name = (null)}
 2021-03-08 21:02:08.785470+0800 multi-thread[24467:4834926] 第0次开始执行--<NSThread: 0x6000002a6980>{number = 7, name = (null)}
 2021-03-08 21:02:09.790585+0800 multi-thread[24467:4834926] 第0次结束执行--<NSThread: 0x6000002a6980>{number = 7, name = (null)}
 2021-03-08 21:02:09.790585+0800 multi-thread[24467:4834923] 第1次结束执行--<NSThread: 0x6000002e4d40>{number = 4, name = (null)}
 2021-03-08 21:02:09.791179+0800 multi-thread[24467:4834926] 第2次开始执行--<NSThread: 0x6000002a6980>{number = 7, name = (null)}
 2021-03-08 21:02:09.791194+0800 multi-thread[24467:4834923] 第3次开始执行--<NSThread: 0x6000002e4d40>{number = 4, name = (null)}
 2021-03-08 21:02:10.794924+0800 multi-thread[24467:4834926] 第2次结束执行--<NSThread: 0x6000002a6980>{number = 7, name = (null)}
 2021-03-08 21:02:10.794980+0800 multi-thread[24467:4834923] 第3次结束执行--<NSThread: 0x6000002e4d40>{number = 4, name = (null)}
 2021-03-08 21:02:10.795530+0800 multi-thread[24467:4834862] ******当前线程******
 2021-03-08 21:02:10.795559+0800 multi-thread[24467:4834926] 第4次开始执行--<NSThread: 0x6000002a6980>{number = 7, name = (null)}
 2021-03-08 21:02:11.800397+0800 multi-thread[24467:4834926] 第4次结束执行--<NSThread: 0x6000002a6980>{number = 7, name = (null)}
 
 分析：
 
 
 */
- (void)dispatch_semaphore {
    dispatch_queue_t concurrent_queue = dispatch_queue_create("com.memo.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    // 创建信号量并设置信号值(最大并发数)为2
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    
    for (NSInteger i = 0; i < 5; i++) {
        // 如果信号值大于0，信号值减1并执行后续代码
        // 如果信号值等于0，当前线程将被阻塞处于等待状态，直到信号值大于0或者等待超时为止
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(concurrent_queue, ^{
            NSLog(@"第%ld次开始执行--%@", i, [NSThread currentThread]);
            [NSThread sleepForTimeInterval:1.0f];
            NSLog(@"第%ld次结束执行--%@", i, [NSThread currentThread]);
            // 任务执行完后发送信号使信号值+1
            dispatch_semaphore_signal(semaphore);
        });
    }
    
    NSLog(@"******当前线程******");
}

// MARK: - 八.dispatch_semaphore 保证线程安全：为线程加锁。[xxxxx]
/*
 保证线程安全：为线程加锁。
 
 // 创建一个信号量并初始化信号的总量
 dispatch_semaphore_create(1);

 // 发送一个信号，让信号总量加1
 dispatch_semaphore_signal(semaphore);

 // 可以使总信号量减1，当信号总量为0时就会一直等待(阻塞所在线程)，否则就可以正常执行。
 // 参数1：等待的信号量是哪个，参数2：等待的时长
 dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
 
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
 
 打印是从任务"1"顺序执行到"100"，没有发生两个任务同时执行的情况。

 原因如下：
 在子线程中并发执行asyncTask，那么第一个添加到并发队列里的，会将信号量减1，此时信号量等于0，可以执行接下来的任务。
 而并发队列中其他任务，由于此时信号量不等于0，必须等当前正在执行的任务执行完毕后调用dispatch_semaphore_signal，将信号量加1，才可以继续执行接下来的任务。
 以此类推，从而达到线程加锁的目的。
 */
@end
