//
//  ReverseList.m
//  OCAlgorithm
//  数据结构：链表
//  Created by JXT on 2020/6/14.
//  Copyright © 2020 JXT. All rights reserved.
//
//  链表是一串在存储空间上非连续性、顺序的存储结构。
//  由节点进行头尾依次连接而形成链表。
//  每个结点包括两个部分：数据域和下个节点的指针域。

#import "ReverseList.h"

@implementation ReverseList

/// 反转链表
/// @param head 原链表的头结点
/// returns 新链表的头结点
struct Node* reverseList(struct Node *head) {
    // 定义遍历指针，初始化为原链表的头结点
    struct Node *p = head;
    // 定义反转后的新链表头部
    struct Node *newH = NULL;
    // 遍历链表
    while (p != NULL) {
        // 记录下一个结点
        struct Node *temp = p->next;
        // 当前结点的next指向新链表的头部
        p->next = newH;
        // 更改新链表的头部为当前结点
        newH = p;
        // 移动p指针
        p = temp;
    }
    // 返回反转后的链表头结点
    return newH;
}

/// 构造一个链表
struct Node* constructList(void) {
    // 定义头结点
    struct Node *head = NULL;
    // 定义当前结点
    struct Node *cur = NULL;
    for (int i = 0; i < 5; i++) {
        // 创建结点
        struct Node *node = malloc(sizeof(struct Node));
        node->data = i;
        node->next = NULL;
        if (head == NULL) {
            // 头结点为空，新结点即为头结点
            head = node;
        } else {
            // 当前结点的next为新结点
            cur->next = node;
        }
        // 设置当前结点为新结点
        cur = node;
    }
    return head;
}

// 打印链表中的数据
void printList(struct Node *head) {
    struct Node *temp = head;
    while (temp != NULL) {
        printf("node is %d \n", temp->data);
        temp = temp->next;
    }
}

@end
