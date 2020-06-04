//
//  RuntimeObject.m
//  iOS
//
//  Created by MickyChiang on 2020/6/1.
//  Copyright © 2020 JXT. All rights reserved.
//

#import "RuntimeObject.h"
#import <objc/runtime.h>

@implementation RuntimeObject

// MARK: - 动态添加方法
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    // 如果调用了test方法，打印日志
    if (sel == @selector(test)) {
        NSLog(@"resolveInstanceMethod:");
        // 动态添加test方法的实现
        class_addMethod(self, @selector(test), testIMP, "v@:");
        return YES;
    } else {
        // 返回父类的默认调用
        return [super resolveInstanceMethod:sel];
    }
}

void testIMP (void) {
    NSLog(@"test invoke");
}


// MARK: - Method Swizzling
+ (void)load {
    // 获取method1方法
    Method method1 = class_getInstanceMethod(self, @selector(method1));
    // 获取method2方法
    Method method2 = class_getInstanceMethod(self, @selector(method2));
    // 交换两个方法的实现
    method_exchangeImplementations(method1, method2);
}

- (void)method1 {
    NSLog(@"method1");
}

- (void)method2 {
    // 这样调用不会产生死循环的原因：
    // 已经利用methodSwizzling将两个方法的实现互相替换，
    // 所以[self method2]; => 会输出：method1 即调用method1方法的实现
    [self method2]; // 实际上是调用method1的具体实现
    NSLog(@"method2");
}

// MARK: - 消息转发流程
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    // 如果调用了test方法，打印日志
//    if (sel == @selector(test)) {
//        NSLog(@"resolveInstanceMethod:");
//        return NO;
//    } else {
//        // 返回父类的默认调用
//        return [super resolveInstanceMethod:sel];
//    }
//}
//
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    NSLog(@"forwardingTargetForSelector:");
//    return nil;
//}
//
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//    if (aSelector == @selector(test)) {
//        NSLog(@"methodSignatureForSelector:");
//        // 返回正确的方法签名
//        // v -> void类型
//        // @ -> 第一个参数是id类型 即self
//        // : -> 第二个参数是SEL类型 即@selector(test)
//        return [NSMethodSignature methodSignatureForSelector:(SEL)"v@:"];
//    } else {
//        return [super methodSignatureForSelector:aSelector];
//    }
//}
//
//- (void)forwardInvocation:(NSInvocation *)anInvocation {
//    NSLog(@"forwardInvocation:");
//}

@end
