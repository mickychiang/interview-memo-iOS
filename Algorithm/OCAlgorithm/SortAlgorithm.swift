//
//  SortAlgorithm.swift
//  OCAlgorithm
//
//  Created by JXT on 2020/5/22.
//  Copyright © 2020 JXT. All rights reserved.
//

import Foundation
import UIKit

// ********** 排序算法（Swift版） **********
class SortAlgorithm: NSObject {
    @objc static func sortAlgorithm() {
        var array = [4, 1, 2, 5, 0]
        print("源数组：\(array)")
        //****************************************
        print("冒泡排序：\(bubbleSort(&array))")
        print("冒泡排序优化：\(bubbleSortAdvanced(&array))")
        print("冒泡排序超级优化：\(bubbleSortAdvancedSuper(&array))")
        print("冒泡排序究极优化：\(bubbleSortAdvancedFinal(&array))")
        //****************************************
        print("选择排序：\(selectSort(&array))")
        //****************************************
        print("插入排序：\(insertSort(&array))")
        
//        // 比较排序算法性能
//        var originalArray = Array<Int>.randomArray(size: 10, maxValue:100)
//        var sortedArray1 = [Int]()
//        var sortedArray2 = [Int]()
//        var timeBubbleSort = executionTimeInterval {
//            sortedArray1 = bubbleSortAdvancedSuper(&originalArray)
//        }
//        var timeSelectSort = executionTimeInterval {
//            sortedArray2 = bubbleSortAdvanced(&originalArray)
//        }
//        print("bubble sort time duration : \(timeBubbleSort.formattedTime)")
//        print("select sort time duration : \(timeSelectSort.formattedTime)")
    }
}

// MARK: - 冒泡排序
extension SortAlgorithm {
    // 时间复杂度-平均：O(n^2)
    // 时间复杂度-最优：O(n)
    // 时间复杂度-最差：O(n^2)
    // 稳定性：稳定
    /*
     冒泡排序
     相邻元素两两比较，比较完一趟，最值出现在末尾。
     第1趟：依次比较相邻的两个数，不断交换(举例：小数放前，大数放后)逐个推进，最大值最后出现在第n个元素位置。
     第2趟：依次比较相邻的两个数，不断交换(举例：小数放前，大数放后)逐个推进，最大值最后出现在第n-1个元素位置。
     ...
     第n-1趟：依次比较相邻的两个数，不断交换(举例：小数放前，大数放后)逐个推进，最大值最后出现在第2个元素位置。
     */
    
    // 1.1 冒泡排序
    static func bubbleSort(_ array: inout [Int]) -> [Int] {
        guard array.count > 1 else {
            return array
        }
        for i in 0..<array.count - 1 {
            for j in 0..<array.count - 1 - i {
                if array[j] > array[j+1] {
                    //                    let temp = array[j]
                    //                    array[j] = array[j+1]
                    //                    array[j+1] = temp
                    // 或者
                    array.swapAt(j, j+1)
                }
            }
        }
        return array
    }
    
    // 1.2 冒泡排序的优化
    static func bubbleSortAdvanced(_ array: inout [Int]) -> [Int] {
        guard array.count > 1 else {
            return array
        }
        for i in 0..<array.count - 1 {
            var swapped = false
            for j in 0..<array.count - 1 - i {
                if array[j] > array[j+1] {
                    array.swapAt(j, j+1)
                    swapped = true
                }
            }
            // if there is no swapping in inner loop, it means the the part looped is already sorted,
            // so it's time to break
            if swapped == false {
                break
            }
        }
        return array
    }
    
    // 1.3 冒泡排序的超级优化
    static func bubbleSortAdvancedSuper(_ array: inout [Int]) -> [Int] {
        guard array.count > 1 else {
            return array
        }
        var arrayBorder = array.count - 1
        for _ in 0..<array.count - 1 {
            var swapped = false
            for j in 0..<arrayBorder {
                if array[j] > array[j+1] {
                    array.swapAt(j, j+1)
                    swapped = true
                    // 记录最后一次交换的位置
                    arrayBorder = j
                }
            }
            if swapped == false {
                break
            }
        }
        return array
    }
    
    // 1.4 冒泡排序的究极优化
    /*
     鸡尾酒排序(定向冒泡排序)：是冒泡排序的一种变形，以双向在序列中进行排序。
     思想：
     将之前完整的一轮循环拆分为从左->右和从右->左两个子循环，这就保证了排序的双向进行，效率较单向循环来说更高。
     与此同时在这两个循环中加入了之前两个版本的特性isSorted和有序边界，使得排序更加高效。
     */
    static func bubbleSortAdvancedFinal(_ array: inout [Int]) -> [Int] {
        guard array.count > 1 else {
            return array
        }
        // 数组左边界
        var arrayLeftBorder = 0
        // 数组右边界
        var arrayRightBorder = array.count - 1
        for _ in 0..<array.count/2 {
            // 第一轮循环 左->右
            var swapped = false
            for j in arrayLeftBorder..<arrayRightBorder {
                if array[j] > array[j+1] {
                    array.swapAt(j, j+1)
                    swapped = true
                    arrayRightBorder = j
                }
            }
            if swapped == false {
                break
            }
            
            // 第二轮循环 右->左
            swapped = false
            for j in (arrayLeftBorder+1...arrayRightBorder).reversed() {
                if array[j] < array[j-1] {
                    array.swapAt(j, j-1)
                    swapped = true
                    arrayLeftBorder = j
                }
            }
            if swapped == false {
                break
            }
        }
        return array
    }
}

// MARK: - 选择排序
extension SortAlgorithm {
    // 时间复杂度-平均：O(n^2)
    // 时间复杂度-最优：O(n^2)
    // 时间复杂度-最差：O(n^2)
    // 稳定性：不稳定
    // 交换次数少于冒泡排序
    /*
     选择排序
     第1趟：在n个数中找到最小(大)数与第一个数交换位置。
     第2趟：在剩下n-1个数中找到最小(大)数与第二个数交换位置。
     ...
     第n-1趟：最终可实现数据的升序(降序)排列。
     */
    
    static func selectSort(_ array: inout [Int]) -> [Int] {
        guard array.count > 1 else {
            return array
        }
        for i in 0..<array.count - 1 {
            var min = i
            for j in i + 1..<array.count {
                if array[j] < array[min] {
                    min = j
                }
            }
            // if min has changed, it means there is value smaller than array[min]
            // if min has not changed, it means there is no value smallter than array[min]
            if i != min {
                array.swapAt(i, min)
            }
        }
        return array
    }
    
}

// MARK: - 插入排序
extension SortAlgorithm {
    // 时间复杂度-平均：O(n^2)
    // 时间复杂度-最优：O(n)
    // 时间复杂度-最差：O(n^2)
    // 稳定性：稳定
    /*
     选择排序
     从数组中拿出一个元素（通常就是第一个元素）以后，再从数组中按顺序拿出其他元素。
     如果拿出来的这个元素比这个元素小，就放在这个元素左侧；反之，则放在右侧。
     */
    
    static func insertSort(_ array: inout [Int]) -> [Int] {
        guard array.count > 1 else {
            return array
        }
        for i in 1..<array.count {
            var j = i
            while j > 0 && array[j] < array[j-1] {
                array.swapAt(j-1, j)
                j -= 1
            }
        }
        return array
    }
    
}
