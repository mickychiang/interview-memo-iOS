//
//  JXTMethodSwizzling.h
//  RuntimeDemo
//
//  Created by JXT on 2020/6/5.
//  Copyright © 2020 jiangxintong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXTMethodSwizzling : NSObject

+ (void)exchangeInstanceMethod:(Class)cls originalSEL:(SEL)originalSelector swizzledSEL:(SEL)swizzledSelector;
+ (void)exchangeClassMethod:(Class)cls originalSEL:(SEL)originalSelector swizzledSEL:(SEL)swizzledSelector;

@end

NS_ASSUME_NONNULL_END
