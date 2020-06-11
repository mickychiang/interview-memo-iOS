//
//  NSTimer+WeakTimer.m
//  iOS
//
//  Created by MickyChiang on 2020/6/6.
//  Copyright © 2020 JXT. All rights reserved.
//

#import "NSTimer+WeakTimer.h"

// 中间对象
@interface TimerWeakObject : NSObject
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector; // 定时器到时的回调方法
@property (nonatomic, weak) NSTimer *timer;
- (void)fire:(NSTimer *)timer;
@end

@implementation TimerWeakObject

- (void)fire:(NSTimer *)timer {
    if (self.target) {
        if ([self.target respondsToSelector:self.selector]) {
            [self.target performSelector:self.selector withObject:timer.userInfo];
        }
    } else {
        [self.target  invalidate];
    }
}

@end

@implementation NSTimer (WeakTimer)

+ (NSTimer *)scheduledWeakTimerWithTimeInterval:(NSTimeInterval)interval
                                         target:(id)target
                                       selector:(SEL)selector
                                       userInfo:(id)userInfo
                                        repeats:(BOOL)repeats {
    
    TimerWeakObject *object = [[TimerWeakObject alloc] init];
    object.target = target;
    object.selector = selector;
    object.timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                    target:object selector:@selector(fire:)
                                                  userInfo:userInfo
                                                   repeats:repeats];
    
    return object.timer;
}

@end
