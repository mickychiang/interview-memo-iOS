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
//    [SwiftAlgorithm baseAlgorithm];
    
    
    // Swift版 - 排序算法
//    [SortAlgorithm sortAlgorithm];
}

- (void)CLanguage {
    reverseChars("Hello World");
    
    
    //    [self reverseList];
    //    [self mergeList];
    //    [self hashSearch];
}

- (void)OCLanguage {
    
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
