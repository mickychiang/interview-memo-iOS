//
//  UIViewController+Logging.m
//  RuntimeDemo
//  Method Swizzling - 统计VC加载次数并打印
//  Created by jiangxintong on 2018/11/11.
//  Copyright © 2018年 jiangxintong. All rights reserved.
//

#import "UIViewController+Logging.h"
#import "JXTMethodSwizzling.h"

@implementation UIViewController (Logging)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSEL = @selector(viewDidAppear:);
        SEL swizzledSEL = @selector(jxt_viewDidAppear:);
        [JXTMethodSwizzling exchangeInstanceMethod:class originalSEL:originalSEL swizzledSEL: swizzledSEL];
    });
}

- (void)jxt_viewDidAppear:(BOOL)animated {
    [self jxt_viewDidAppear:animated];
    NSLog(@"%@", NSStringFromClass([self class]));
}

@end
