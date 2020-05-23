//
//  SwiftAlgorithm.swift
//  OCAlgorithm
//
//  Created by MickyChiang on 2020/5/21.
//  Copyright © 2020 JXT. All rights reserved.
//

import Foundation

class SwiftAlgorithm: NSObject {
    @objc static func baseAlgorithm() {
   
    }
}

// MARK: - 计算从1到100数字的总和
extension SwiftAlgorithm {
    /// 法1. 1到100循环遍历逐步相加
    // 时间复杂度：O(n)
    static func sum1(_ n: Int) -> Int {
        var sum = 0
        for i in 1...n {
            sum += i
        }
        return sum
    }
    
    /// 法2. 等差数列求和
    // 时间复杂度：O(1)
    static func sum2(_ n: Int) -> Int {
        return (n + 1) * n / 2
    }
}

// MARK: - 给出一个整型数组和一个目标值，判断数组中是否有两个数之和等于目标值
extension SwiftAlgorithm {
    // 时间复杂度：O(n)
    static func twoSumEqualTarget(nums: [Int], _ target: Int) -> Bool {
        // 初始化集合
        var set = Set<Int>()
        // 遍历整型数组
        for num in nums {
            // 判断集合中是否包含[目标值-当前值]的结果
            if set.contains(target - num) {
                // 包含 返回true
                return true
            }
            // 不包含 将当前值存进集合 用作下次判断
            set.insert(num)
        }
        // 都不包含 返回false
        return false
    }
}

// MARK: - 给出一个整型数组和目标值，且数组中有且仅有两个数之和等于目标值，求这两个数在数组中的index
extension SwiftAlgorithm {
    // 巧妙的用到了字典的特性，用key表示数组的值，通过判断字典中是否含有目标值的key来取出索引。
    // 时间复杂度：O(n)
    static func twoSumEqualTarget(nums: [Int], _ target: Int) -> [Int] {
        // 初始化字典
        var dict = [Int: Int]()
        // 通过索引i和对应的num进行判断
        for (i, num) in nums.enumerated() {
            // 从dict字典中取出之前保存的索引，判断是否存在索引
            if let lastIndex = dict[target - num] {
                // 返回之前存的索引和当前索引
                return [lastIndex, i]
            } else {
                // 保存当前索引，用于后续判断
                dict[num] = i
            }
        }
        // 致命错误来终止程序
        fatalError("No valid output!")
    }
}

// MARK: - 实现阶乘n!的算法：3！= 3 * 2 * 1 ； 4！= 4 * 3 * 2 * 1
extension SwiftAlgorithm {
    // 递归
    static func factorial(_ n: Int) -> Int {
        return n < 2 ? 1: n * factorial(n-1)
    }
}


// MARK: - ********** 反转题 **********
extension SwiftAlgorithm {
    // 2. 字符串
    // 给出一个字符串，要求将其按照单词顺序进行反转。
    // eg：如果是"hello world"，那么反转后的结果就是"world hello"，这个题比较常规了，但是要注意空格的特殊处理。看代码:
    // 方法1. 系统提供的方法 不过时间复杂度过大
    static func reverseWords(s: String) -> String? {
        // 用空格划分字符串
        let chars = s.components(separatedBy: " ")
        // 将字符串数组进行反转，并通过空格重新组合
        let reserString = chars.reversed().joined(separator: " ")
        return reserString
    }
    
    // 方法2.
    /*
     1. 以输入字符串为"Hello World"为例，首先将该字符串分割成一个个的小字符数组，然后反转成"dlroW olleH"。
     2. 接着我们通过判断字符数组中的空格位和最后一位字符，对单一的单词进行分段反转，更新start位置。
     3. 最后输出我们需要的结果"World Hello"
     */
    static func reverseWords2(s: String) -> String? {
        // 将字符串s分割成字符数组
        var chars = Array(s)
        var start = 0
        // 反转chars字符数组
        _reverse(&chars, start, chars.count - 1)
        
        for i in 0..<chars.count {
            // 当i等于 数组最后一位 或者遇到空格时 反转字符串
            if i == chars.count - 1 || chars[i + 1] == " " {
                // 将每个单独的单词进行反转
                _reverse(&chars, start, i)
                // 更新start位置
                start = i + 2
            }
        }
        return String(chars)
    }
    // 反转字符串
    fileprivate static func _reverse<T>(_ chars: inout[T], _ start: Int, _ end: Int) {
        // 接收字符串反转的起始和结束位置
        var start = start, end = end
        // 判断反转字符串的位置
        while start < end {
            // start、end位置的字符互换
            swap(&chars, start, end)
            // 往中间位置靠拢
            start += 1
            end -= 1
        }
    }
    // 将p、q字符的位置进行互换，这种写法也是swift里的一大亮点
    fileprivate static func swap<T>(_ chars: inout[T], _ p: Int, _ q: Int) {
        (chars[p], chars[q]) = (chars[q], chars[p])
    }
    
    // 3. 整数反转
    // 例题：给定一个16位有符号整数，要求将其反转后输出（eg:输入：1234，输出：4321）
    // 注意边界条件的判断。
    @objc static func reverseInteger(x: Int) -> Int {
        var i = 0
        var t = x
        // 支持正数和负数
        while t != 0 {
            i = 10 * i + t % 10
            t = t / 10
        }
        // 注意边界条件的判断
        if i < INT16_MIN || i > INT64_MAX {
            // 超出16位符号整型 输出0
            return 0
        }
        return i
    }
    
}

/*
 待总结归类：
 1.反转题：字符串反转、单词反转、整数反转、...
 2.每个数据结构的概念以及模拟操作：链表、栈、队列...
 */

