//
//  NSTimer+WeakTimer.h
//  iOS
//  内存管理
//  Created by MickyChiang on 2020/6/6.
//  Copyright © 2020 JXT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (WeakTimer)

+ (NSTimer *)scheduledWeakTimerWithTimeInterval:(NSTimeInterval)interval
                                     target:(id)target
                                   selector:(SEL)selector
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats;

@end

NS_ASSUME_NONNULL_END
