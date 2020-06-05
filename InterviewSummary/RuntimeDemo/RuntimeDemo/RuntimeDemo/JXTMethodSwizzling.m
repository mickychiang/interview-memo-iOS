//
//  JXTMethodSwizzling.m
//  RuntimeDemo
//
//  Created by JXT on 2020/6/5.
//  Copyright © 2020 jiangxintong. All rights reserved.
//

#import "JXTMethodSwizzling.h"

@implementation JXTMethodSwizzling

/**
 *  对象方法的交换
 *
 *  @param cls 哪个类
 *  @param originalSelector 原本的方法
 *  @param swizzledSelector 要替换成的方法
 */
+ (void)exchangeInstanceMethod:(Class)cls originalSEL:(SEL)originalSelector swizzledSEL:(SEL)swizzledSelector {
    ExchangeInstanceMethod(originalSelector, swizzledSelector, cls);
}

/**
 *  类方法的交换
 *
 *  @param cls 哪个类
 *  @param originalSelector 原本的方法
 *  @param swizzledSelector 要替换成的方法
 */
+ (void)exchangeClassMethod:(Class)cls originalSEL:(SEL)originalSelector swizzledSEL:(SEL)swizzledSelector {
    ExchangeClassMethod(originalSelector, swizzledSelector, cls);
}

#pragma mark - Runtime 类方法的替换
static void ExchangeClassMethod(SEL originalSelector, SEL swizzledSelector, Class class) {
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

#pragma mark - Runtime 对象方法的替换
static void ExchangeInstanceMethod(SEL originalSelector, SEL swizzledSelector, Class class) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    /*
     方法添加 参数
     cls 被添加方法的类
     name 添加的方法的名称的SEL
     imp 方法的实现 该函数必须至少要有两个参数 self _cmd
     types 类型编码
     */
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
