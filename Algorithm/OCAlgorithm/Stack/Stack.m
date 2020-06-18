//
//  Stack.m
//  OCAlgorithm
//  数据结构：栈，先进后出
//  Created by MickyChiang on 2020/5/21.
//  Copyright © 2020 JXT. All rights reserved.
//
// 模拟栈操作

#import "Stack.h"

@interface Stack ()
// 存储栈数据
@property (nonatomic, strong) NSMutableArray *stackArray;

@end

@implementation Stack

// 初始化操作
- (instancetype)initWithNumbers:(NSArray *)numbers {
    self = [super init];
    if (self) {
        for (NSNumber *number in numbers) {
            [self.stackArray addObject:number];
        }
    }
    return self;
}

/**
 入栈
 @param obj 指定入栈对象
*/
- (void)push:(id)obj {
    [self.stackArray addObject:obj];
}

/**
 出栈
*/
- (id)popObj {
    if ([self isEmpty]) {
        return nil;
    } else {
        id lastObject = self.stackArray.lastObject;
        [self.stackArray removeLastObject];
        return lastObject;
    }
}

/**
 返回栈顶元素
*/
- (id)topObj {
    if ([self isEmpty]) {
        return nil;
    } else {
        return self.stackArray.lastObject;
    }
}

/**
 栈是否为空
*/
- (BOOL)isEmpty {
    return !self.stackArray.count;
}

/**
 栈的长度
*/
- (NSInteger)stackLength {
    return self.stackArray.count;
}

/**
 从栈底开始遍历
 @param block 回调遍历的结果
*/
- (void)enumerateObjectsFromBottom:(StackBlock)block {
    [self.stackArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block ? block(obj) : nil;
    }];
}

/**
 从顶部开始遍历
 @param block 回调遍历的结果
*/
- (void)enumerateObjectsFromtop:(StackBlock)block {
    [self.stackArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block ? block(obj) : nil;
    }];
}

/**
 所有元素出栈，一边出栈一边返回元素
*/
- (void)enumerateObjectsPopStack:(StackBlock)block {
    __weak typeof(self) weakSelf = self;
    NSUInteger count = self.stackArray.count;
    for (NSUInteger i = count; i > 0; i --) {
        if (block) {
            block(weakSelf.stackArray.lastObject);
            [self.stackArray removeLastObject];
        }
    }
}

/**
 清空
*/
- (void)removeAllObjects {
    [self.stackArray removeAllObjects];
}

- (NSMutableArray *)stackArray {
    if (!_stackArray) {
        _stackArray = [NSMutableArray array];
    }
    return _stackArray;
}

@end
