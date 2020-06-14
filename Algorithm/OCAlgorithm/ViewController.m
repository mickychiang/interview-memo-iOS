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
    
    // 单链表反转
    struct Node *head = constructList();
    printList(head);
    printf("----------\n");
    struct Node *newHead = reverseList(head);
    printList(newHead);
    
    
    [SwiftAlgorithm baseAlgorithm]; // 简单算法
//    [SortAlgorithm sortAlgorithm]; // 排序算法
}


@end
