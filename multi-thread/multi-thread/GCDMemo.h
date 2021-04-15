//
//  GCDMemo.h
//  multi-thread
//
//  Created by MickyChiang on 2021/3/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCDMemo : NSObject

/* 主队列同步 */
- (void)main_queue_dispatch_sync;
/* 主队列异步 */
- (void)main_queue_dispatch_async;

/* 全局队列同步 */
- (void)global_queue_dispatch_sync;
/* 全局队列异步 */
- (void)global_queue_dispatch_async;

/* 自定义串行队列同步 */
- (void)custom_serial_queue_dispatch_sync;
/* 自定义串行队列异步 */
- (void)custom_serial_queue_dispatch_async;

/* 自定义并发队列同步 */
- (void)custom_concurrent_queue_dispatch_sync;
/* 自定义并发队列异步 */
- (void)custom_concurrent_queue_dispatch_async;

/* 同步栅栏函数 */
- (void)dispatch_barrier_sync;
/* 异步栅栏函数 */
- (void)dispatch_barrier_async;

/* dispatch_group_create + dispatch_group_enter + dispatch_group_leave + dispatch_async + dispatch_group_notify */
- (void)GCDGroup1;
/* dispatch_group_create + dispatch_group_async + dispatch_group_notify */
- (void)GCDGroup2;

/* GCD中用于延迟将某个任务添加到队列中 dispatch_after */
- (void)dispatch_after;

/* 单例 dispatch_once */
- (void)dispatch_once_use;

/* 信号量 dispatch_semaphore */
- (void)dispatch_semaphore;

@end

NS_ASSUME_NONNULL_END
