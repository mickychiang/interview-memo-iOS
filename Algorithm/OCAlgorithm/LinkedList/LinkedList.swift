//
//  LinkedList.swift
//  OCAlgorithm
//  数据结构：链表
//  Created by JXT on 2020/5/22.
//  Copyright © 2020 JXT. All rights reserved.
//
//  链表是一串在存储空间上非连续性、顺序的存储结构。
//  由节点进行头尾依次连接而形成链表。
//  每个结点包括两个部分：数据域和下个节点的指针域。

import Foundation

// MARK: - 节点
class Node {
    // 数据域
    var data: Int
    // 指针域
    var next: Node?
    
    init(_ data: Int) {
        self.data = data
        self.next = nil
    }
}

// MARK: - 链表
class LinkedList {
    var headNode: Node?
    
    init() {
        var curNode: Node?
        for i in 0..<5 {
            let node: Node = Node(i)
            if headNode == nil {
                headNode = node
            } else {
                curNode?.next = node
            }
            curNode = node
        }
    }
    
    func remove(node: inout Node?) {
        if let n = node {
            if let next = n.next {
                n.data = next.data
                n.next = next.next
            } else {
                node = nil
            }
        }
    }
}

// MARK: - 输出
extension LinkedList: CustomStringConvertible {
    var description: String {
        var text = "LinkedList: ["
        var pointer = headNode
        while let node = pointer {
            text += String(node.data) + (node.next == nil ? "" : " -> ")
            pointer = node.next
        }
        text += "]"
        return text
    }
}

// MARK: 1. 反转链表
extension LinkedList {
    func reversed() {
        /// nodeA.next 指向上一级 nodeB
        func reverse(curNode: Node?, preNode: Node?) -> Node? {
            if let node = curNode {
                let nextNode = node.next
                if nextNode == nil {
                    headNode = node
                }
                node.next = preNode
                return reverse(curNode: nextNode, preNode: node)
            } else {
                return preNode
            }
        }
        _ = reverse(curNode: headNode, preNode: nil)
    }
}

// MARK: - 2. 链表是否有环
extension LinkedList {
    func hasCycle() -> Bool {
        var fastPointer = headNode
        var slowPointer = headNode
        while let fast = fastPointer, let slow = slowPointer {
            fastPointer = fast.next?.next
            slowPointer = slow.next
            if fastPointer === slowPointer {
                return true
            }
        }
        return false
    }
    func makeACircle() {
        headNode?.next?.next?.next?.next = headNode?.next?.next
    }
}

// MARK: - 3. 两个链表是否有交点
extension LinkedList {
    func findIntersection(with anotherListHead: Node?) -> Node? {
        
        guard headNode != nil, anotherListHead != nil else {
            return nil
        }
        
        var pointerA = headNode
        var pointerB = anotherListHead

        while pointerA?.data != pointerB?.data {
            pointerA = pointerA == nil ? anotherListHead : pointerA?.next
            pointerB = pointerB == nil ? headNode : pointerB?.next
        }
        return pointerA
    }
}




// MARK: - ************************************ 最初代码 ************************************
class List {
    /// 创建一个链表
    static func constructList() -> Node {
        var headNode: Node?
        var curNode: Node?
        for i in 0..<5 {
            let node: Node = Node(i)
            if headNode == nil {
                headNode = node
            } else {
                curNode?.next = node
            }
            curNode = node
        }
        return headNode!
    }
    
    /// 反转链表
    static func reverseList(headNode: Node) -> Node {
        var pointer: Node? = headNode
        var newHeadNode: Node?
        while let node = pointer { // 头插法
            let nextNode = node.next // 指针指向下一个node
            node.next = newHeadNode
            newHeadNode = node
            pointer = nextNode // 指针向后移动
        }
        return newHeadNode!
    }
    
    /// 输出链表
    static func printList(headNode: Node) {
        var pointer: Node? = headNode
        var text = "LinkedList: ["
        while let node = pointer {
            text += String(node.data) + (node.next == nil ? "" : " -> ")
            pointer = node.next
        }
        text += "]"
        print(text)
    }
    
    /// 链表是否有环
    static func hasCycle(headNode: Node?) -> Bool {
        var fastPointer = headNode
        var slowPointer = headNode
        while let fast = fastPointer, let slow = slowPointer {
            fastPointer = fast.next?.next
            slowPointer = slow.next
            if fastPointer === slowPointer {
                return true
            }
        }
        return false
    }
}







// MARK: - 1 -> 3 -> 5 -> 2 -> 4 -> 2，当给定x=3时，要求返回 1 -> 2 -> 2 -> 3 -> 5 -> 4。
/*
 例题：1 -> 3 -> 5 -> 2 -> 4 -> 2，当给定x=3时，要求返回 1 -> 2 -> 2 -> 3 -> 5 -> 4。
 思路：将完整的链表通过条件判断(入参x)分割成2个新的链表，然后再将2个新链表拼接成完整的链表。
 */
/*
 注解:
 1. 首先创建左右两个Dummy节点，然后通过while判断node是否存在。
 2. 若存在再判断节点的数据val和判断条件x的关系，小于x则被链到左边链表上，大于x则被链到右边链表上。
 3. 执行完while，此时我们已经拿到左右两个新的链表。最后把左边的尾节点指向右边的头节点就完成了完整链表的拼接。
 
 注意：需要将右链表的尾节点置nil，防止构成环。
 关于检测链表中是否有环，可以通过 快行指针 来检测，若快指针和慢指针变成相等的了，就代表该链表有环，具体的就不在这里介绍了，比较简单。
 */
func partition(_ head: Node?, _ x: Int) -> Node? {
    let prevDummy = Node(0), postDummy = Node(0)
    var prev = prevDummy, post = postDummy
    
    var node = head
    // 判断是否存在node
    while node != nil {
        // 判断数据是否小于x
        if node!.data < x {
            // 小于x 则prev.next指针域指向node
            prev.next = node
            prev = node!
        } else {
            // 大于x 则构建新的链表
            post.next = node
            post = node!
        }
        // 判断下个节点
        node = node?.next
    }
    // 将尾节点next置为nil，防止构成环
    post.next = nil
    // 左右拼接(左边尾节点指向右边头节点)
    prev.next = postDummy.next
    
    return prevDummy.next
}
/*
 关于Dummy节点
 上面代码引入了Dummy节点，它的作用就是作为一个虚拟的头前结点。
 我们引入它的原因是我们不知道要返回的新链表的头结点是哪一个，它有可能是原链表的第一个节点，可能在原链表的中间，也可能在最后，甚至可能不存在（nil）。
 而Dummy节点的引入可以巧妙的涵盖所有以上情况，我们可以用dummy.next方便得返回最终需要的头结点。
*/


// 遗留的问题？
// 1. 检测链表中是否有环的方法？





/*
 ********** 二叉树 **********
 概念：二叉树中，每个节点最多有两个子节点，一般称为左子节点和右子节点，并且节点的顺序不能任意颠倒。
 第一层的节点称之为根节点，我们从根节点开始计算，到节点的最大层次为二叉树的深度。
 */
// 一个完整的二叉树节点包含数据val，左子节点和右子节点。
public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    
    public init(_ val: Int) {
        self.val = val
    }
}

// 例题1：求二叉树深度
/*
 注解：
 1. 首先判断入参二叉树节点是否为nil，若不存在的话返回0，若存在递归子节点取最大值。
 2. +1表示每递归一层，二叉树深度+1。
 3. max函数作用：左右子节点最大深度比较，取较大值。
 */
func treeMaxDepth(root: TreeNode?) -> Int {
    guard let root = root else {
        return 0
    }
    // max函数：比较两个入参的大小取最大值
    return max(treeMaxDepth(root: root.left), treeMaxDepth(root: root.right)) + 1
}

// 例题2：判断当前的二叉树是否为二叉查找树
/*
 二叉查找树(Binary Sort Tree)
 满足所有左子节点的值都小于它的根节点的值，所有右子节点的值都大于它的根子节点的值。
 */
/*
 注解：
 1. 首先判断当前节点是否存在，若不存在即代表已经递归到最后一层，返回true。
 2. 然后判断右子树和左子树的val是否满足判断条件，若都满足条件进行下一层的递归。
 3. 左右同时进行递归操作。
 */
func isValidBST(root: TreeNode?) -> Bool {
    return _helper(node: root, nil, nil)
}
func _helper(node: TreeNode?, _ min: Int?, _ max: Int?) -> Bool {
    // node不存在 则到了最底层 递归结束。
    // 这个要注意的是第一次传入的node不能为nil
    guard let node = node else {
        return true
    }
    // 右子树的值必须大于它的根节点值
    if let min = min, node.val <= min {
        return false
    }
    // 左子树的值必须小于它的根节点值
    if let max = max, node.val >= max {
        return false
    }
    // 左右子树同时递归
    return _helper(node: node.left, min, node.val) && _helper(node: node.right, node.val, max)
}

// 例题3. 二叉树的遍历
// 常见的二叉树遍历：前序、中序、后序和层级遍历(广度优先遍历)。
/*
 二叉树的遍历规则
 1. 前序遍历规则：访问根节点 -> 前序遍历左子树 -> 前序遍历右子树
 2. 中序遍历规则：中序遍历左子树 -> 访问根节点 -> 中序遍历右子树
 3. 后序遍历规则：后序遍历左子树 -> 后序遍历右子树 -> 访问根节点
 4. 层级遍历规则：以层为顺序，将某一层上的节点全部遍历完成后，才向下一层进行遍历，依次类推，至到最后一层。
 */
// 实现 略 暂时没研究 之后写上




//    // 实现头插法和尾插法
//    // 头插法：当前节点插到第一个节点之前
//    // 尾插法：当前节点插入到链表最后一个节点之后
//    var head: Node?
//    var tail: Node?
//
//    // MARK: - 链表 头插法
//    func appendToHead(_ data: Int) {
//        if head == nil {
//            head = Node(data)
//            tail = head
//        } else {
//            let temp = Node(data)
//            // 把当前head地址赋给temp的指针域
//            temp.next = head
//            head = temp
//        }
//    }
//
//    // MARK: - 链表 尾插法
//    func appendToTail(_ data: Int) {
//        if tail == nil {
//            tail = Node(data)
//            head = tail
//        } else {
//            tail?.next = Node(data)
//            tail = tail?.next
//        }
//    }
