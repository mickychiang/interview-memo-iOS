//
//  UIControl+Limit.m
//  RuntimeDemo
//  Method Swizzling - 防止UI控件短时间多次激活事件
//  Created by jiangxintong on 2018/11/11.
//  Copyright © 2018年 jiangxintong. All rights reserved.
//

#import "UIControl+Limit.h"
#import "JXTMethodSwizzling.h"

@implementation UIControl (Limit)

#pragma mark - Runtime - Associated Object

// acceptEventInterval - 控件接受响应的时间间隔
- (void)setAcceptEventInterval:(NSTimeInterval)acceptEventInterval {
    objc_setAssociatedObject(self, @selector(acceptEventInterval), @(acceptEventInterval), OBJC_ASSOCIATION_ASSIGN);
}

- (NSTimeInterval)acceptEventInterval {
    return [objc_getAssociatedObject(self, @selector(acceptEventInterval)) doubleValue];
}

// ignoreEvent - 是否忽略响应事件
- (void)setIgnoreEvent:(BOOL)ignoreEvent {
    objc_setAssociatedObject(self, @selector(ignoreEvent), @(ignoreEvent), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)ignoreEvent {
    return [objc_getAssociatedObject(self, @selector(ignoreEvent)) boolValue];
}

#pragma mark - Runtime - Method Swizzling
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSEL = @selector(sendAction:to:forEvent:);
        SEL swizzledSEL = @selector(jxt_sendAction:to:forEvent:);
        [JXTMethodSwizzling exchangeInstanceMethod:class originalSEL:originalSEL swizzledSEL:swizzledSEL];
    });
}

- (void)jxt_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if (self.ignoreEvent) {
        NSLog(@"btnAction is intercepted");
        return;
    }
    if (self.acceptEventInterval > 0) {
        self.ignoreEvent = YES;
        // 拖延至acceptEventInterval设置的时间后将ignoreEvent置为NO
        [self performSelector:@selector(changeIgnoreEventWithNo) withObject:nil afterDelay:self.acceptEventInterval];
    }
    [self jxt_sendAction:action to:target forEvent:event];
}

#pragma mark - private method
- (void)changeIgnoreEventWithNo {
    self.ignoreEvent = NO;
}

@end
