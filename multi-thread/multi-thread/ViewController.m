//
//  ViewController.m
//  multi-thread
//
//  Created by jiangxintong on 2021/3/3.
//

#import "ViewController.h"
#import "GCDMemo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self interview1];
//    [self interview1Change];
//    [self interview2];
//    [self interview3];
//    [self interview4];
//    [self interview5];
    
//    [self gcd_memo];
}

// MARK: - ********************** GCD Memo **********************
- (void)gcd_memo {
    GCDMemo *gcdMemo = [[GCDMemo alloc] init];
    
//    // 主队列同步函数 - crash：因队列引起的循环等待而产生死锁
//    [gcdMemo main_queue_dispatch_sync];
//    
//    // 主队列异步函数
//    [gcdMemo main_queue_dispatch_async];
//    
//    // 全局队列同步函数
//    [gcdMemo global_queue_dispatch_sync];
//    
//    // 全局列异步函数
//    [gcdMemo global_queue_dispatch_async];
//    
//    // 自定义串行队列同步函数
//    [gcdMemo custom_serial_queue_dispatch_sync];
//    
//    // 自定义串行队列异步函数
//    [gcdMemo custom_serial_queue_dispatch_async];
//    
//    // 自定义并发队列同步函数
//    [gcdMemo custom_concurrent_queue_dispatch_sync];
//    
//    // 自定义并发队列异步函数
//    [gcdMemo custom_concurrent_queue_dispatch_async];
//
//    // 同步栅栏函数
//    [gcdMemo dispatch_barrier_sync];
//    
//    // 异步栅栏函数
//    [gcdMemo dispatch_barrier_async];
//
//    // dispatch_group
//    // dispatch_group_enter() + dispatch_group_leave() + dispatch_async()
//    [gcdMemo GCDGroup1];
//
//    // dispatch_group_async
//    [gcdMemo GCDGroup2];
//    
//    // dispatch_after
//    [gcdMemo dispatch_after];
//    // 单例
//    [gcdMemo dispatch_once_use];
//    // 信号量
//    [gcdMemo dispatch_semaphore];
}

// MARK: - interview multi-thread
- (void)printLog {
    NSLog(@"2---%@", [NSThread currentThread]);
}

/*
 2021-04-16 00:35:19.428340+0800 multi-thread[8675:210363] 1---<NSThread: 0x6000030e4f00>{number = 4, name = (null)}
 2021-04-16 00:35:19.428667+0800 multi-thread[8675:210363] 3---<NSThread: 0x6000030e4f00>{number = 4, name = (null)}
 
 分析：
 由于异步函数dispatch_async是开启一个新的子线程去执行任务，而子线程默认是没有启动Runloop的，所以并不会执行`printLog`方法。
 我们可以手动启动runLoop来确保`printLog`被调用，也就是在block里面添加一行代码`[[NSRunLoop currentRunLoop] run];`。
 */
- (void)interview1 {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1---%@", [NSThread currentThread]);
        [self performSelector:@selector(printLog)
                   withObject:nil
                   afterDelay:0]; // performSelector:withObject:afterDelay:的本质是往Runloop中添加定时器
        NSLog(@"3---%@", [NSThread currentThread]);
    });
}

/*
 2021-04-16 00:30:44.055849+0800 multi-thread[8293:204597] 1---<NSThread: 0x6000002e55c0>{number = 7, name = (null)}
 2021-04-16 00:30:44.056171+0800 multi-thread[8293:204597] 2---<NSThread: 0x6000002e55c0>{number = 7, name = (null)}
 2021-04-16 00:30:44.056364+0800 multi-thread[8293:204597] 3---<NSThread: 0x6000002e55c0>{number = 7, name = (null)}
 */
- (void)interview1Change {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1---%@", [NSThread currentThread]);
        [self performSelector:@selector(printLog)
                   withObject:nil
                   afterDelay:0]; // performSelector:withObject:afterDelay:的本质是往Runloop中添加定时器
         [[NSRunLoop currentRunLoop] run]; // 手动启动runLoop 保证performSelector:withObject:afterDelay:方法有效执行
        NSLog(@"3---%@", [NSThread currentThread]);
    });
}

/*
 2021-04-16 00:31:36.586932+0800 multi-thread[8315:205455] 1---<NSThread: 0x600002f640c0>{number = 1, name = main}
 2021-04-16 00:31:36.587213+0800 multi-thread[8315:205455] 3---<NSThread: 0x600002f640c0>{number = 1, name = main}
 2021-04-16 00:31:36.587752+0800 multi-thread[8315:205455] 2---<NSThread: 0x600002f640c0>{number = 1, name = main}
 */
- (void)interview2 {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"1---%@", [NSThread currentThread]);
        [self performSelector:@selector(printLog)
                   withObject:nil
                   afterDelay:0];
        NSLog(@"3---%@", [NSThread currentThread]);
    });
}

/*
 2021-04-16 00:32:35.513359+0800 multi-thread[8488:206675] 1---<NSThread: 0x6000006449c0>{number = 1, name = main}
 2021-04-16 00:32:35.513869+0800 multi-thread[8488:206675] 3---<NSThread: 0x6000006449c0>{number = 1, name = main}
 2021-04-16 00:32:35.547090+0800 multi-thread[8488:206675] 2---<NSThread: 0x6000006449c0>{number = 1, name = main}
 
 分析：
 同步函数添加的任务是在当前线程中执行，当前线程就是主线程，而主线程的runLoop是启动的，所以`printLog`会调用。
 虽然延迟时间时0秒，但是添加到runLoop中的计时器不是立马触发的，而是要先唤醒runLoop，这是需要消耗一定时间的，所以会先打印3再打印2。
 */
- (void)interview3 {
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1---%@", [NSThread currentThread]);
        [self performSelector:@selector(printLog)
                   withObject:nil
                   afterDelay:0];
        NSLog(@"3---%@", [NSThread currentThread]);
    });
}

/*
 2021-04-16 00:33:03.459458+0800 multi-thread[8518:207643] 1---<NSThread: 0x60000032c080>{number = 6, name = (null)}
 2021-04-16 00:33:03.459673+0800 multi-thread[8518:207643] 2---<NSThread: 0x60000032c080>{number = 6, name = (null)}
 2021-04-16 00:33:03.459836+0800 multi-thread[8518:207643] 3---<NSThread: 0x60000032c080>{number = 6, name = (null)}
 
 分析：
 `performSelector:withObject:`函数是不涉及到计时器的，所以不会添加到runLoop中，所以是按照1、2、3的顺序执行。
 
 注意：
 `performSelector`系列方法中只要是方法名中包含`afterDelay`、`waitUntilDone`的都是和计时器有关的，都要注意前面出现的这些问题。
 */
- (void)interview4 {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1---%@", [NSThread currentThread]);
        [self performSelector:@selector(printLog)
                   withObject:nil]; // 不涉及计时器，所以不会添加到RunLoop 方法名中包含afterDelay、waitUntilDone的都是和计时器有关的
        NSLog(@"3---%@", [NSThread currentThread]);
    });
}

/*
 2021-04-16 00:33:37.341412+0800 multi-thread[8632:208621] 1---<NSThread: 0x600002285a80>{number = 7, name = (null)}
 2021-04-16 00:33:37.341734+0800 multi-thread[8632:208621] 2---<NSThread: 0x600002285a80>{number = 7, name = (null)}
 */
- (void)interview5 {
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

// NSThread + RunLoop 实现常驻线程
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

@end
