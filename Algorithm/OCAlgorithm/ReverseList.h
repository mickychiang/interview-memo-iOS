//
//  ReverseList.h
//  OCAlgorithm
//
//  Created by JXT on 2020/6/14.
//  Copyright © 2020 JXT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 定义一个链表
struct Node {
    int data; // 节点数据
    struct Node *next; // 链表的下一个节点
};

@interface ReverseList : NSObject

// 反转列表
struct Node* reverseList(struct Node *head);

// 构造一个链表
struct Node* constructList(void);

// 打印链表中的数据
void printList(struct Node *head);

@end

NS_ASSUME_NONNULL_END
