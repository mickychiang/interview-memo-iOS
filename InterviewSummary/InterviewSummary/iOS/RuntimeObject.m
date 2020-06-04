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

// Method Swizzling
//+ (void)load {
//    // 获取test方法
//    Method test = class_getInstanceMethod(self, @selector(test));
//    // 获取otherTest方法
//    Method otherTest = class_getInstanceMethod(self, @selector(otherTest));
//    // 交换两个方法的实现
//    method_exchangeImplementations(test, otherTest);
//}
//
//- (void)test {
//    NSLog(@"test");
//}
//
//- (void)otherTest {
//    // 这样调用不会产生死循环的原因：
//    // 已经利用methodSwizzling将两个方法的实现互相替换，
//    // 所以[self otherTest]; => 会输出：test 即调用test方法的实现
//    [self otherTest];
//    NSLog(@"otherTest");
//}




//void testImp (void) {
//    NSLog(@"test invoke");
//}
//
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    // 如果调用了test方法，打印日志
//    if (sel == @selector(test)) {
//        NSLog(@"resolveInstanceMethod:");
////        return NO;
//        // 动态添加test方法的实现
//        class_addMethod(self, @selector(test), testImp, "v@:");
//        return YES;
//    } else {
//        // 返回父类的默认调用
//        return [super resolveInstanceMethod:sel];
//    }
//}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    // 如果调用了test方法，打印日志
    if (sel == @selector(test)) {
        NSLog(@"resolveInstanceMethod:");
        return NO;
    } else {
        // 返回父类的默认调用
        return [super resolveInstanceMethod:sel];
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"forwardingTargetForSelector:");
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(test)) {
        NSLog(@"methodSignatureForSelector:");
        // 返回正确的方法签名
        // v -> void类型
        // @ -> 第一个参数是id类型 即self
        // : -> 第二个参数是SEL类型 即@selector(test)
        return [NSMethodSignature methodSignatureForSelector:(SEL)"v@:"];
    } else {
        return [super methodSignatureForSelector:aSelector];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"forwardInvocation:");
}

@end
