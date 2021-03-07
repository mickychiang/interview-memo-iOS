//
//  GCDMemo.m
//  multi-thread
//
//  Created by MickyChiang on 2021/3/5.
//

#import "GCDMemo.h"

@implementation GCDMemo

/*
 主队列同步函数
 
 运行结果：crash
 原因：因队列引起的循环等待而产生死锁
 
 分析：当前线程是主线程
 1.同步函数是在当前线程中执行任务，不具备开启新线程的能力；同步任务会阻塞当前线程。
 2.主队列是串行队列，如果通过同步函数向主队列中添加任务，那么并不会开启子线程来执行这个任务，而是在主线程中执行。
 3.将main_queue_dispatch_sync方法称作task1，将dispatch_sync同步函数添加的任务称作task2。
 4.队列遵循先进先出原则，task1和task2都在主队列中，主队列先安排task1到主线程执行，等task1执行完了才能安排task2到主线程执行，而task1又必须等task2执行完了才能继续往下执行，
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

/*
 主队列异步函数
 
 运行结果：
 2021-03-05 20:50:44.520862+0800 multi-thread[13329:4238571] 主队列异步函数
 2021-03-05 20:50:44.521147+0800 multi-thread[13329:4238571] ----end----
 2021-03-05 20:50:45.546323+0800 multi-thread[13329:4238571] 0--<NSThread: 0x600000b04380>{number = 1, name = main}
 2021-03-05 20:50:46.546926+0800 multi-thread[13329:4238571] 1--<NSThread: 0x600000b04380>{number = 1, name = main}
 2021-03-05 20:50:47.548554+0800 multi-thread[13329:4238571] 2--<NSThread: 0x600000b04380>{number = 1, name = main}
 2021-03-05 20:50:48.550152+0800 multi-thread[13329:4238571] 3--<NSThread: 0x600000b04380>{number = 1, name = main}
 2021-03-05 20:50:49.551625+0800 multi-thread[13329:4238571] 4--<NSThread: 0x600000b04380>{number = 1, name = main}
 
 分析：当前线程是主线程
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

/*
 全局队列同步函数
 
 运行结果：
 2021-03-05 21:13:56.015161+0800 multi-thread[13691:4251767] 全局队列同步函数
 2021-03-05 21:13:57.016766+0800 multi-thread[13691:4251767] 0--<NSThread: 0x600002c985c0>{number = 1, name = main}
 2021-03-05 21:13:58.017288+0800 multi-thread[13691:4251767] 1--<NSThread: 0x600002c985c0>{number = 1, name = main}
 2021-03-05 21:13:59.018509+0800 multi-thread[13691:4251767] 2--<NSThread: 0x600002c985c0>{number = 1, name = main}
 2021-03-05 21:14:00.020028+0800 multi-thread[13691:4251767] 3--<NSThread: 0x600002c985c0>{number = 1, name = main}
 2021-03-05 21:14:01.020616+0800 multi-thread[13691:4251767] 4--<NSThread: 0x600002c985c0>{number = 1, name = main}
 2021-03-05 21:14:01.020999+0800 multi-thread[13691:4251767] ----end----
 
 分析：当前线程是主线程
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

/*
 全局队列异步函数
 
 运行结果：
 2021-03-05 21:15:08.304741+0800 multi-thread[13734:4253807] 全局队列异步函数
 2021-03-05 21:15:08.304971+0800 multi-thread[13734:4253807] ----end----
 2021-03-05 21:15:09.307090+0800 multi-thread[13734:4253887] 1--<NSThread: 0x600001e3f780>{number = 3, name = (null)}
 2021-03-05 21:15:09.307085+0800 multi-thread[13734:4253884] 4--<NSThread: 0x600001e44d00>{number = 4, name = (null)}
 2021-03-05 21:15:09.307091+0800 multi-thread[13734:4253885] 0--<NSThread: 0x600001e424c0>{number = 7, name = (null)}
 2021-03-05 21:15:09.307091+0800 multi-thread[13734:4253882] 2--<NSThread: 0x600001e3b3c0>{number = 5, name = (null)}
 2021-03-05 21:15:09.307216+0800 multi-thread[13734:4253889] 3--<NSThread: 0x600001e48340>{number = 8, name = (null)}
 
 分析：当前线程是主线程
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

/*
 自定义串行队列同步函数
 
 运行结果：
 2021-03-05 22:57:11.760386+0800 multi-thread[14883:4306213] 自定义串行队列同步函数
 2021-03-05 22:57:12.761464+0800 multi-thread[14883:4306213] 0--<NSThread: 0x600003388040>{number = 1, name = main}
 2021-03-05 22:57:13.762059+0800 multi-thread[14883:4306213] 1--<NSThread: 0x600003388040>{number = 1, name = main}
 2021-03-05 22:57:14.762558+0800 multi-thread[14883:4306213] 2--<NSThread: 0x600003388040>{number = 1, name = main}
 2021-03-05 22:57:15.762842+0800 multi-thread[14883:4306213] 3--<NSThread: 0x600003388040>{number = 1, name = main}
 2021-03-05 22:57:16.763464+0800 multi-thread[14883:4306213] 4--<NSThread: 0x600003388040>{number = 1, name = main}
 2021-03-05 22:57:16.763777+0800 multi-thread[14883:4306213] ----end----
 
 分析：当前线程是主线程
 1.同步函数是在当前线程中执行任务，不具备开启新线程的能力；同步任务会阻塞当前线程。
 2.通过同步函数向自定义串行队列中添加的任务都是在当前线程中执行，不会开启新的线程，而且是串行执行(FIFO)。
 3.注意这个和通过同步函数向主队列添加任务不同。
 将custom_serial_queue_dispatch_sync方法称作task1，将同步函数添加的任务称作task2。
 这里两个task属于2个不同的队列，task1由主队列安排执行，task2由自定义串行队列来安排执行。
 首先主队列安排task1到主线程中执行，当执行到task2的地方时，由自定义串行队列安排task2到主线程中执行(无需等待task1完成)，等task2执行完后继续执行task1，所以这里不会造成线程堵塞。
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

/*
 自定义串行队列异步函数
 
 运行结果：
 2021-03-05 22:58:26.405791+0800 multi-thread[14920:4307665] 自定义串行队列异步函数
 2021-03-05 22:58:26.406325+0800 multi-thread[14920:4307665] ----end----
 2021-03-05 22:58:27.406469+0800 multi-thread[14920:4307741] 0--<NSThread: 0x600001fbc480>{number = 6, name = (null)}
 2021-03-05 22:58:28.406959+0800 multi-thread[14920:4307741] 1--<NSThread: 0x600001fbc480>{number = 6, name = (null)}
 2021-03-05 22:58:29.412585+0800 multi-thread[14920:4307741] 2--<NSThread: 0x600001fbc480>{number = 6, name = (null)}
 2021-03-05 22:58:30.413534+0800 multi-thread[14920:4307741] 3--<NSThread: 0x600001fbc480>{number = 6, name = (null)}
 2021-03-05 22:58:31.416662+0800 multi-thread[14920:4307741] 4--<NSThread: 0x600001fbc480>{number = 6, name = (null)}
 
 分析：当前线程是主线程
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

/*
 自定义并发队列同步函数
 
 运行结果：
 2021-03-05 22:59:09.580891+0800 multi-thread[14949:4308578] 自定义并发队列同步函数<##>
 2021-03-05 22:59:10.581620+0800 multi-thread[14949:4308578] 0--<NSThread: 0x600003120180>{number = 1, name = main}
 2021-03-05 22:59:11.582128+0800 multi-thread[14949:4308578] 1--<NSThread: 0x600003120180>{number = 1, name = main}
 2021-03-05 22:59:12.582819+0800 multi-thread[14949:4308578] 2--<NSThread: 0x600003120180>{number = 1, name = main}
 2021-03-05 22:59:13.583128+0800 multi-thread[14949:4308578] 3--<NSThread: 0x600003120180>{number = 1, name = main}
 2021-03-05 22:59:14.584434+0800 multi-thread[14949:4308578] 4--<NSThread: 0x600003120180>{number = 1, name = main}
 2021-03-05 22:59:14.584671+0800 multi-thread[14949:4308578] ----end----
 
 分析：当前线程是主线程
 通过同步函数向自定义并发队列中添加的任务是在当前线程中执行，而且是串行执行(FIFO)。
 */
- (void)custom_concurrent_queue_dispatch_sync {
    NSLog(@"自定义并发队列同步函数<##>");
    dispatch_queue_t concurrent_queue = dispatch_queue_create("com.memo.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    for (NSInteger i = 0; i < 5; i++) {
        dispatch_sync(concurrent_queue, ^{
            [NSThread sleepForTimeInterval:1.0f]; // 模拟耗时操作
            NSLog(@"%ld--%@", i, [NSThread currentThread]);
        });
    }
    
    NSLog(@"----end----");
}

/*
 自定义并发队列异步函数
 
 运行结果：
 2021-03-05 22:59:44.289713+0800 multi-thread[14974:4309431] 自定义并发队列异步函数<##>
 2021-03-05 22:59:44.289935+0800 multi-thread[14974:4309431] ----end----
 2021-03-05 22:59:45.294478+0800 multi-thread[14974:4309532] 3--<NSThread: 0x600002be74c0>{number = 5, name = (null)}
 2021-03-05 22:59:45.294497+0800 multi-thread[14974:4309535] 1--<NSThread: 0x600002b952c0>{number = 6, name = (null)}
 2021-03-05 22:59:45.294478+0800 multi-thread[14974:4309529] 0--<NSThread: 0x600002b9ef00>{number = 8, name = (null)}
 2021-03-05 22:59:45.294478+0800 multi-thread[14974:4309534] 2--<NSThread: 0x600002b9cb00>{number = 3, name = (null)}
 2021-03-05 22:59:45.294596+0800 multi-thread[14974:4309530] 4--<NSThread: 0x600002be2440>{number = 9, name = (null)}
 
 分析：当前线程是主线程
 通过异步函数向自定义并发队列添加的任务不是在当前线程执行，而是多个任务是在不同的线程中执行，并且是并发执行。
 */
- (void)custom_concurrent_queue_dispatch_async {
    NSLog(@"自定义并发队列异步函数<##>");
    dispatch_queue_t concurrent_queue = dispatch_queue_create("com.memo.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    
    for (NSInteger i = 0; i < 5; i++) {
        dispatch_async(concurrent_queue, ^{
            [NSThread sleepForTimeInterval:1.0f]; // 模拟耗时操作
            NSLog(@"%ld--%@", i, [NSThread currentThread]);
        });
    }
    
    NSLog(@"----end----");
}

@end
