//
//  CommonSuperFind.m
//  OCAlgorithm
//
//  Created by MickyChiang on 2020/6/17.
//  Copyright © 2020 JXT. All rights reserved.
//

#import "CommonSuperFind.h"

@implementation CommonSuperFind

/// 查找两个视图的共同父视图
- (NSArray<UIView *> *)findCommonSuperView:(UIView *)viewOne other:(UIView *)viewOther {
    
    NSMutableArray *result = [NSMutableArray array];
    
    // 查找第一个视图的所有父视图
    NSArray *arrayOne = [self findSuperViews:viewOne];
    // 查找第二个视图的所有父视图
    NSArray *arrayOther = [self findSuperViews:viewOther];
    
    int i = 0;
    // 越界限制条件
    while (i < MIN((int)arrayOne.count, (int)arrayOther.count)) {
        // 倒序方式获取各个视图的父视图
        UIView *superOne = [arrayOne objectAtIndex:arrayOne.count - i -1];
        UIView *superOther = [arrayOther objectAtIndex:arrayOther.count - i - 1];
        
        if (superOne == superOther) {
            // 如果相等 则为共同父视图
            [result addObject:superOne];
            i++;
        } else {
            // 如果不相等 则结束遍历
            break;
        }
    }
    
    return result;
}

/// 返回当前视图的所有父视图
- (NSArray<UIView *> *)findSuperViews:(UIView *)view {
    // 初始化当前视图的第一父视图
    UIView *tempSuperView = view.superview;
    // 保存所有父视图的数组
    NSMutableArray *result = [NSMutableArray array];
    while (tempSuperView) {
        [result addObject:tempSuperView];
        // 顺着superview指针一直向上查找
        tempSuperView = tempSuperView.superview;
    }
    return result;
}

@end
