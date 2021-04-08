//: [Previous](@previous)

// MARK: - ******************* 单链表 *******************

// MARK: - 节点 Node
// 每个节点包括两个部分：数据域和下个节点的指针域。
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

// MARK: - 单链表
class LinkedList {
    var headNode: Node?

    init(_ n: Int = 5) {
        var curNode: Node?
        for i in 0..<n {
            let node: Node = Node(i)
            if headNode == nil {
                headNode = node
            } else {
                curNode?.next = node
            }
            curNode = node
        }
    }
    
    // 删除头节点
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

// MARK: - 反转链表
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

// MARK: - 输出链表
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

var list = LinkedList(6)
print(list.description)
//list.remove(node: &list.headNode)
//print(list.description)
list.reversed()
print(list.description)

//: [Next](@next)
