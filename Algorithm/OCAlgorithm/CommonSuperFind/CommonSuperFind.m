//
//  CommonSuperFind.m
//  OCAlgorithm
//
//  Created by MickyChiang on 2020/6/17.
//  Copyright © 2020 JXT. All rights reserved.
//

#import "CommonSuperFind.h"

@implementation CommonSuperFind

/// 查找两个子视图的共同父视图
/// 思路 - 分别记录两个子视图的所有父视图并保存到数组中，然后倒序寻找，直至找到第一个不一样的父视图。
- (NSArray<UIView *> *)findCommonSuperViewsForView1:(UIView *)view1 AndView2:(UIView *)view2 {
    
    NSMutableArray *result = [NSMutableArray array];
    
    // 查找第一个视图的所有父视图
    NSArray *array1 = [self findSuperViews:view1];
    // 查找第二个视图的所有父视图
    NSArray *array2 = [self findSuperViews:view2];
    
    int i = 0;
    // 越界限制条件
    while (i < MIN((int)array1.count, (int)array2.count)) {
        // 倒序方式获取两个子视图的父视图
        UIView *super1 = [array1 objectAtIndex:array1.count - i - 1];
        UIView *super2 = [array2 objectAtIndex:array2.count - i - 1];
        
        if (super1 == super2) { // 如果相等 则为共同父视图
            [result addObject:super1];
            i++;
        } else { // 如果不相等 则结束遍历
            break;
        }
    }
    
    return result;
}

/// 返回当前视图的所有父视图
- (NSArray<UIView *> *)findSuperViews:(UIView *)view {
    // 初始化当前视图的第一父视图
    UIView *curSuperView = view.superview;
    // 初始化存放所有父视图的数组
    NSMutableArray *result = [NSMutableArray array];
    while (curSuperView) {
        [result addObject:curSuperView];
        // 顺着superview指针一直向上查找，直到nil结束。
        curSuperView = curSuperView.superview;
    }
    return result;
}

@end
