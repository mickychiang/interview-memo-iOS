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
    
//    [self interview1]; // 123
//    [self interview2]; // 132
//    [self interview3]; // 132
//    [self interview4]; // 123
//    [self interview5]; // 12
    
    [self gcd_memo];
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
    // 信号量
//    [gcdMemo dispatch_semaphore];
}







// MARK: - ******************************************
- (void)interview1 {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1---%@", [NSThread currentThread]);
        [self performSelector:@selector(printLog)
                   withObject:nil
                   afterDelay:0]; // performSelector:withObject:afterDelay:的本质是往Runloop中添加定时器
        [[NSRunLoop currentRunLoop] run]; // 保证performSelector:withObject:afterDelay:方法有效执行
        NSLog(@"3---%@", [NSThread currentThread]);
    });
}

- (void)interview2 {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"1---%@", [NSThread currentThread]);
        [self performSelector:@selector(printLog)
                   withObject:nil
                   afterDelay:0];
        NSLog(@"3---%@", [NSThread currentThread]);
    });
}

- (void)interview3 {
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1---%@", [NSThread currentThread]);
        [self performSelector:@selector(printLog)
                   withObject:nil
                   afterDelay:0];
        NSLog(@"3---%@", [NSThread currentThread]);
    });
}

- (void)interview4 {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"1---%@", [NSThread currentThread]);
        [self performSelector:@selector(printLog)
                   withObject:nil]; // 不涉及计时器，所以不会添加到RunLoop 方法名中包含afterDelay、waitUntilDone的都是和计时器有关的
        NSLog(@"3---%@", [NSThread currentThread]);
    });
}

// MARK: - ******************************************
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

- (void)printLog {
    NSLog(@"2---%@", [NSThread currentThread]);
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
