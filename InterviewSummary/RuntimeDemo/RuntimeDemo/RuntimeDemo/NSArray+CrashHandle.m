//
//  NSArray+CrashHandle.m
//  RuntimeDemo
//  Method Swizzling - 防奔溃处理：数组越界问题
//  Created by jiangxintong on 2018/11/12.
//  Copyright © 2018年 jiangxintong. All rights reserved.
//

#import "NSArray+CrashHandle.h"
#import "JXTMethodSwizzling.h"

@implementation NSArray (CrashHandle)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = objc_getClass("__NSArrayI");
        SEL originalSEL = @selector(objectAtIndex:);
        SEL swizzledSEL = @selector(tt_objectAtIndex:);
        [JXTMethodSwizzling exchangeInstanceMethod:class originalSEL:originalSEL swizzledSEL:swizzledSEL];
    });
}

- (id)tt_objectAtIndex:(NSUInteger)index {
    if (self.count-1 < index) { // 判断下标是否越界，如果越界就进入异常拦截
        @try {
            return [self tt_objectAtIndex:index];
        }
        @catch (NSException *exception) {
            // 在崩溃后会打印崩溃信息。如果是线上，可以在这里将崩溃信息发送到服务器
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
    } else { // 如果没有问题，则正常进行方法调用
        return [self tt_objectAtIndex:index];
    }
}

/*
 里面调用了自身？这是递归吗？
 其实不是。这个时候方法替换已经有效了，tt_objectAtIndex这个SEL指向的其实是原来系统的objectAtIndex:的IMP。因而不是递归。
 */

@end
