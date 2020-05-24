//
//  MObject.m
//  iOS
//
//  Created by MickyChiang on 2020/5/24.
//  Copyright © 2020 JXT. All rights reserved.
//

#import "MObject.h"

@implementation MObject

- (instancetype)init {
    if (self = [super init]) {
        _value = 0;
    }
    return self;
}

// 用来验证：KVC可以调用setter方法
//- (void)setValue:(int)value {
//    NSLog(@"%d", value);
//}

- (void)increase {
    // 仿写系统重写setter方法的实现：
    // 手动添加willChangeValueForKey:方法和didChangeValueForKey:方法
    [self willChangeValueForKey:@"value"];
    _value += 1; // 为成员变量赋值
    [self didChangeValueForKey:@"value"];
}

@end
