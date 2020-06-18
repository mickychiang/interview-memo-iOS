//
//  Stack.swift
//  OCAlgorithm
//  数据结构：栈，先进后出
//  Created by MickyChiang on 2020/5/21.
//  Copyright © 2020 JXT. All rights reserved.
//
// 模拟栈操作
import Foundation

// 注解：利用协议申明了栈的属性和方法，并在结构体中声明数组stack，对数组数据进行append和popLast操作，完成入栈出栈操作，比较简单。
protocol Stack {
    // associatedtype：关联类型，相当于范型，在调用的时候可以根据associatedtype指定的Element来设置类型
    associatedtype Element
    // 判断栈是否为空
    var isEmpty: Bool { get }
    // 栈的大小
    var size: Int { get }
    // 栈顶元素
    var peek: Element? { get }
    // mutating：当需要在协议(结构体,枚举)的实例方法中，修改协议(结构体,枚举)的实例属性，需要用到mutating对实例方法进行修饰，不然会报错。
    // 进栈
    mutating func push(_ newElement: Element)
    // 出栈
    mutating func pop() -> Element?
}

// 模拟栈操作
struct IntegerStack: Stack {
    // typealias：类型别名，指定协议关联类型的具体类型，和associatedtype成对出现的
    typealias Element = Int
    private var stack = [Element]()
    // 判断栈是否为空
    var isEmpty: Bool { return stack.isEmpty }
    // 栈的大小
    var size: Int { return stack.count }
    // 取出stack栈顶元素
    var peek: Element? { return stack.last }
    // push 加入stack数组中
    mutating func push(_ newElement: Element) {
        return stack.append(newElement)
    }
    // pop 删除stack中最后一个元素
    mutating func pop() -> Element? {
        return stack.popLast()
    }
}
