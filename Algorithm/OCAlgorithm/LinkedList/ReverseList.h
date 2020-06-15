//
//  ReverseList.h
//  OCAlgorithm
//  数据结构：链表
//  Created by JXT on 2020/6/14.
//  Copyright © 2020 JXT. All rights reserved.
//
//  链表是一串在存储空间上非连续性、顺序的存储结构。
//  由节点进行头尾依次连接而形成链表。
//  每个结点包括两个部分：数据域和下个节点的指针域。

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 定义一个链表
struct Node {
    int data; // 结点数据
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
