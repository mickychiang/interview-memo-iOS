//
//  GCDMemo.h
//  multi-thread
//
//  Created by MickyChiang on 2021/3/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCDMemo : NSObject

- (void)main_queue_dispatch_sync;
- (void)main_queue_dispatch_async;

- (void)global_queue_dispatch_sync;
- (void)global_queue_dispatch_async;

- (void)custom_serial_queue_dispatch_sync;
- (void)custom_serial_queue_dispatch_async;

- (void)custom_concurrent_queue_dispatch_sync;
- (void)custom_concurrent_queue_dispatch_async;

@end

NS_ASSUME_NONNULL_END
