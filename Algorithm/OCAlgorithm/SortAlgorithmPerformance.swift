//
//  SortAlgorithmPerformance.swift
//  OCAlgorithm
//
//  Created by JXT on 2020/5/22.
//  Copyright © 2020 JXT. All rights reserved.
//
// 用来测试 - 比较排序算法性能
import Foundation
import UIKit

// 举例1：计算程序运行时间的类
/// time interval
/// 第一个函数以block的形式传入需要测试运行时间的函数，返回了函数运行的时间
/// - Parameter
///     - block:
/// - Returns CFTimeInterval 函数运行的时间
public func executionTimeInterval(block: () -> ()) -> CFTimeInterval {
    let start = CACurrentMediaTime()
    block();
    let end = CACurrentMediaTime()
    return end - start
}

// formatted time
public extension CFTimeInterval {
    // 将秒数添加了单位：毫秒级的以毫秒显示，微秒级的以微秒显示，大于1秒的以秒单位显示。
    var formattedTime: String {
        return self >= 1000 ? String(Int(self)) + "s"
            : self >= 1 ? String(format: "%.3gs", self)
            : self >= 1e-3 ? String(format: "%.3gms", self * 1e3)
            : self >= 1e-6 ? String(format: "%.3gµs", self * 1e6)
            : self < 1e-9 ? "0s"
            : String(format: "%.3gns", self * 1e9)
    }
}

extension Array {
    // 举例2：生成各种类型随机数的Array的分类
    static public func randomArray(size: Int, maxValue: UInt) -> [Int] {
        var result = [Int](repeating: 0, count:size)
        
        for i in 0 ..< size {
            result[i] = Int(arc4random_uniform(UInt32(maxValue)))
        }
        
        return result
    }
    
    // 生成基本有序随机数组
    static public func nearlySortedArray(size: Int, gap:Int) -> [Int] {

        var result = [Int](repeating: 0, count:size)

        for i in 0 ..< size {
            result[i] = i
        }

        let count : Int = size / gap
        var arr = [Int]()

        for i in 0 ..< count {
            arr.append(i*gap)
        }

        for j in 0 ..< arr.count {
            let swapIndex = arr[j]
            result.swapAt(swapIndex,swapIndex+1)
        }

        return result
    }
}
