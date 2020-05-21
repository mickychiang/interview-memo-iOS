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

#pragma mark - push

- (void)push:(id)obj {
    [self.stackArray addObject:obj];
}

#pragma mark - get

- (id)popObj {
    if ([self isEmpty]) {
        return nil;
    } else {
        id lastObject = self.stackArray.lastObject;
        [self.stackArray removeLastObject];
        return lastObject;
    }
}

-(id)topObj {
    if ([self isEmpty]) {
        return nil;
    } else {
        return self.stackArray.lastObject;
    }
}

- (BOOL)isEmpty {
    return !self.stackArray.count;
}

- (NSInteger)stackLength {
    return self.stackArray.count;
}

#pragma mark - 遍历

// 从栈底开始遍历
-(void)enumerateObjectsFromBottom:(StackBlock)block {
    [self.stackArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block ? block(obj) : nil;
    }];
}

// 从顶部开始遍历
-(void)enumerateObjectsFromtop:(StackBlock)block {
    [self.stackArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block ? block(obj) : nil;
    }];
}

// 所有元素出栈，一边出栈一边返回元素
-(void)enumerateObjectsPopStack:(StackBlock)block {
    __weak typeof(self) weakSelf = self;
    NSUInteger count = self.stackArray.count;
    for (NSUInteger i = count; i > 0; i --) {
        if (block) {
            block(weakSelf.stackArray.lastObject);
            [self.stackArray removeLastObject];
        }
    }
}

#pragma mark - remove

-(void)removeAllObjects {
    [self.stackArray removeAllObjects];
}

#pragma mark - lazy

- (NSMutableArray *)stackArray {
    if (!_stackArray) {
        _stackArray = [NSMutableArray array];
    }
    return _stackArray;
}

@end
