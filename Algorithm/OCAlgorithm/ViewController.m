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
#import "OCAlgorithm-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self reverseList];
    
    // Swift版 - 简单算法
//    [SwiftAlgorithm baseAlgorithm];
    // Swift版 - 排序算法
//    [SortAlgorithm sortAlgorithm];
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


@end
