//
//  Queue.swift
//  OCAlgorithm
//  数据结构：队列，先进先出
//  Created by MickyChiang on 2020/5/21.
//  Copyright © 2020 JXT. All rights reserved.
//
// 模拟队列操作
import Foundation
/*
 注解：
 代码里面分别用两个数组分别完成入队列和出队列的操作，用right存储入队列的元素。
 当出队列时会先判断left是否为空，如果为空，left数组指向倒序后的right数组，这时执行popLast，即实现了出队列的操作。
 size peek isEmpty属性也是充分通过左右两个数组来进行判断。
 关于书上用left right两个数组来形成一个队列的写法笔者自己也不是很清楚，希望有知道的同学可以给小弟指点一下。
 */
protocol Queue {
    // associatedtype：关联类型，相当于范型，在调用的时候可以根据associatedtype指定的Element来设置类型
    associatedtype Element
    // 队列是否为空
    var isEmpty: Bool { get }
    // 队列大小
    var size: Int { get }
    // 队列首元素
    var peek: Element? { get }
    // 入列
    mutating func enqueue(_ newElement: Element)
    // 出列
    mutating func dequeue() -> Element?
}

struct IntegerQueue: Queue {
    // typealias：类型别名，指定协议关联类型的具体类型，和associatedtype成对出现的
    typealias Element = Int
    // 声明左右2个数组
    private var left = [Element]()
    private var right = [Element]()
    // 队列是否为空
    var isEmpty: Bool { return left.isEmpty && right.isEmpty }
    // 队列大小
    var size: Int { return left.count + right.count }
    // 队列首元素
    var peek: Element? { return left.isEmpty ? right.first : left.last }
    // 在right数组中添加新元素
    mutating func enqueue(_ newElement: Int) {
        right.append(newElement)
    }
    // 出队列时 首先判断left是否为空
    mutating func dequeue() -> Element? {
        if left.isEmpty {
            // reversed: 倒序遍历数组
            left = right.reversed()
            // 删除right数组
            right.removeAll()
        }
        // 删除left数组的最后一个元素
        return left.popLast()
    }
}

