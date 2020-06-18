////
////  Demo.swift
////  OCAlgorithm
////
////  Created by JXT on 2020/6/18.
////  Copyright © 2020 JXT. All rights reserved.
////
//
//import Foundation
//
//
//func reverseString1111(str: String) -> String {
//    var strArray = Array(str)
//
//    var start = 0
//    var end = strArray.count - 1
//
//    while start < end {
//        (strArray[start], strArray[end]) = (strArray[end], strArray[start])
//        start += 1
//        end -= 1
//    }
//
//    return String(strArray)
//}
//
//
//class Node1: NSObject {
//    var data: Int?
//    var next: Node1?
//}
//
//class List1: NSObject {
//
//    override init() {
//        super.init()
//    }
//
//
//    func List() -> Node1 {
//        var head: Node1? = nil
//        var cur: Node1? = nil
//
//        for i in 0..<5 {
//            let node: Node1 = Node1()
//            node.data = i
//            node.next = nil
//
//            if head == nil {
//                head = node
//            } else {
//                cur?.next = node
//            }
//            cur = node
//        }
//
//        return head!
//    }
//
//    func printList(head: Node1) {
//        var temp: Node1? = head
//        while temp != nil {
//            print("node is \(String(describing: temp?.data))")
//            temp = temp?.next
//        }
//    }
//
//    func reverseList(head: Node1) -> Node1 {
//        var newHead: Node1? = nil
//        var p: Node1 = head
//        while p != nil {
//            var temp: Node1 = p.next!
//            p.next = newHead
//            newHead = p
//            p = temp
//        }
//        return newHead
//    }
//
//}
