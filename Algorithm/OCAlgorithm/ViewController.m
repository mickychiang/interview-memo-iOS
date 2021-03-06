//
//  ViewController.m
//  OCAlgorithm
//
//  Created by MickyChiang on 2020/5/21.
//  Copyright © 2020 JXT. All rights reserved.
//

#import "ViewController.h"
#import "OCAlgorithm.h"
#import "ReverseList.h"
#import "HashFind.h"
#import "OCAlgorithm-Swift.h"
#import "MedianFind.h"

#import "Stack.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 简单算法 - C版
//    [self CLanguage];
    
    // 简单算法 - OC版
//    [self OCLanguage];
    
    // 简单算法 - Swift版
    [SwiftAlgorithm baseAlgorithm];
    
    
    // Swift版 - 排序算法
//    [SortAlgorithm sortAlgorithm];
}

- (void)CLanguage {
    // 不用中间变量，交换A和B的值
    NSLog(@"不用中间变量，交换A和B的值");
    int a = 7, b = 17;
    NSLog(@"origin: a = %d, b = %d", a, b);
    [OCAlgorithm swap1A:a andB:b];
    [OCAlgorithm swap2A:a andB:b];
    NSLog(@"---------------");
    
    
    
//    reverseChars("Hello World");
    
    
    //    [self reverseList];
    //    [self mergeList];
    //    [self hashSearch];
    
    
    int list[9] = {12, 3, 10, 8, 6, 7, 11, 13, 9};
    int median = findMedian(list, 9);
    printf("the median is %d \n", median);
}

- (void)OCLanguage {
    NSLog(@"模拟栈操作");
    Stack *stack = [[Stack alloc] initWithNumbers:@[@(4), @(9), @(51), @(3), @(6), @(10)]];
    // 入栈
    [stack push:@(11)];
    [stack enumerateObjectsFromtop:^(id  _Nonnull obj) {
        NSLog(@"obj = %@", obj);
    }];
    // 出栈
    [stack popObj];
    [stack enumerateObjectsFromtop:^(id  _Nonnull obj) {
        NSLog(@"obj = %@", obj);
    }];
    
    [stack removeAllObjects];
    [stack enumerateObjectsFromtop:^(id  _Nonnull obj) {
        NSLog(@"obj = %@", obj);
    }];
    
    
//    IntegerStack *s = [[IntegerStack alloc] init];
}








- (void)reverseList {
    // 单链表反转
    printf("-----单链表反转-----\n");
    struct Node *head = constructList();
    printList(head);
    printf("----------\n");
    struct Node *newHead = reverseList(head);
    printList(newHead);
}

- (void)mergeList {
    // 有序数组的合并
    
    int a[5] = {1,4,6,7,9};
    int b[8] = {2,3,5,6,8,10,11,12};
    
    // 用于存储归并结果
    int result[13];
    
    // 归并操作
    mergeList(a, 5, b, 8, result);
    // 打印归并结果
    printf("merge result is ");
    for (int i = 0; i < 13; i++) {
        printf("%d ", result[i]);
    }
}

- (void)hashSearch {
    // 查找第一个只出现一次的字符
    char cha[] = "a11baccdeff";
    char fc = findFirstChar(cha);
    printf("this char is %c \n", fc);
}

@end
