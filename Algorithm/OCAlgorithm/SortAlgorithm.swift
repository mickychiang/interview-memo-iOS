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
        var array = [3, 5, 9, 2, 7, 4, 8, 0]//[4, 1, 2, 5, 0]
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
        //****************************************
        print("归并排序：\(mergeSort(array))")
        //****************************************
        print("快速排序：\(quickSort(array))")
        //****************************************
        print("堆排序：\(heapSort(&array))")
        //****************************************
        print("桶排序：\(bucketSort(&array))")
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

// MARK: - 归并排序
extension SortAlgorithm {
    // 时间复杂度-平均：O(nlogn)
    // 时间复杂度-最优：O(nlogn)
    // 时间复杂度-最差：O(nlogn)
    // 稳定性：稳定
    /*
     归并操作(采用分治思想)是建立在归并操作的排序算法，是将需要排序的序列进行拆分，拆分成每一个单一元素。
     这时再按每个元素进行比较排序，两两合并，生成新的有序序列。再对新的有序序列进行两两合并操作，直到整个序列有序。
     
     归并操作的实现步骤是：
     新建空数组，初始化两个传入数组的index为0
     两两比较两个数组index上的值，较小的放在新建数组里面并且index+1。
     最后检查是否有剩余元素，如果有则添加到新建数组里面。
     */
    static func mergeSort(_ array: [Int]) -> [Int] {
        guard array.count > 1 else {
            return array
        }
        let middleIndex = array.count/2
        // recursively split left part of original array
        let leftArray = mergeSort(Array(array[0..<middleIndex]))
        // recursively split right part of original array
        let rightArray = mergeSort(Array(array[middleIndex..<array.count]))
        // merge left part and right part
        return _merge(leftPile: leftArray, rightPile: rightArray)
    }
    
    static func _merge(leftPile: [Int], rightPile: [Int]) -> [Int] {
//        print("\nmerge left pile:\(leftPile)  |  right pile:\(rightPile)")
        // left pile index, start from 0
        var leftIndex = 0
        // right pile index, start from 0
        var rightIndex = 0
        // sorted pile, empty in the first place
        var sortedPile = [Int]()
        
        while leftIndex < leftPile.count && rightIndex < rightPile.count {
            // append the smaller value into sortedPile
            if leftPile[leftIndex] < rightPile[rightIndex] {
                sortedPile.append(leftPile[leftIndex])
                leftIndex += 1
            } else if leftPile[leftIndex] > rightPile[rightIndex] {
                sortedPile.append(rightPile[rightIndex])
                rightIndex += 1
            } else {
                // same value, append both of them and move the corresponding index
                sortedPile.append(leftPile[leftIndex])
                leftIndex += 1
                sortedPile.append(rightPile[rightIndex])
                rightIndex += 1
            }
        }
        // left pile is not empty
        while leftIndex < leftPile.count {
            sortedPile.append(leftPile[leftIndex])
            leftIndex += 1
        }
        // right pile is not empty
        while rightIndex < rightPile.count {
            sortedPile.append(rightPile[rightIndex])
            rightIndex += 1
        }
//        print("sorted pile：\(sortedPile)")
        return sortedPile
    }
}

// MARK: - 快速排序
extension SortAlgorithm {
    // 时间复杂度-平均：O(nlogn)
    // 时间复杂度-最优：O(nlogn)
    // 时间复杂度-最差：O(n^2)
    // 稳定性：不稳定
    /*
     快速排序是一种高效的排序方法，它利用了归并排序的思想，
     将需要排列的数组拆分成每一小部分，然后让每一小部分进行排序、合并，最后得到完整的排序序列。
     */
    static func quickSort(_ array: [Int]) -> [Int] {
        guard array.count > 1 else {
            return array
        }
        // 取出数组中间下标元素
        let pivot = array[array.count/2]
        // 用到了函数式方法filter，过滤元素
        let left = array.filter{ $0 < pivot }
        let middle = array.filter{ $0 == pivot }
        let right = array.filter{ $0 > pivot }
        // 递归 对新数组进行合并
        return quickSort(left) + middle + quickSort(right)
    }
}

// MARK: - 堆排序
extension SortAlgorithm {
    // 时间复杂度-平均：O(nlogn)
    // 时间复杂度-最优：O(nlogn)
    // 时间复杂度-最差：O(nlogn)
    // 稳定性：不稳定
    /*
     堆排序：
     利用堆这种数据结构而设计的一种排序算法，是选择排序的一种。
     通过调整堆结构，将堆的顶部元素（即数组第0位元素）与末尾的元素进行交换，调整后将末尾元素固定，
     然后继续调整新的堆结构，每次调整固定一个元素，遍历结束后从而达到排序的效果。
     */
    static func heapSort(_ array: inout [Int]) -> [Int] {
        // 构建大顶堆 从最后一个非叶子结点倒序遍历
        for i in (0...(array.count/2-1)).reversed() {
            // 从第一个非叶子结点从下至上，从右至左调整结构
            adjustHeap(&array, i: i, length: array.count)
        }
        // 上面已将输入数组调整成堆结构
        for j in (1...(array.count - 1)).reversed() {
            // 堆顶元素与末尾元素进行交换
            array.swapAt(0, j)
            adjustHeap(&array, i:0, length:j)
        }
        return array
    }
    static func adjustHeap(_ array: inout [Int], i: Int, length: Int) {
        var j = i
        // 取出当前元素i
        let tmp = array[j]
        var k = 2*i+1
        while k < length {
            // 左子节点小于右子节点
            if(k+1 < length && array[k] < array[k+1]) {
                //取到右子节点下标
                k+=1
            }
            if(array[k] > tmp){
                // 如果子节点大于父节点，将子节点值赋给父节点（不用进行交换）
                array[j] = array[k]
                j = k
            } else {
                break
            }
            k = k*2 + 1
        }
        // 将tmp值放到最终的位置
        array[j] = tmp
    }
}

// MARK: - 桶排序
extension SortAlgorithm {
    /*
     桶排序：
     将数组分到n个相同的大小的子区间，每个子区间就是一个桶，然后将输入数组中的元素一一对应，放入对应子区间内的桶中。
     最后遍历每个桶，依次输入每个桶中对应装的数据即可。
     因为桶的顺序是有序的，所以只要从第一个桶开始遍历，得到的结果也就是有序的数组。
     */
    static func bucketSort(_ array: inout [Int]) -> [Int] {
        guard array.count > 1 else {
            return array
        }
        // 求出桶的数量
        let max = array.max()
        let min = array.min()
        let bucketCount = max! - min!
        // 创建桶数组，桶个数=最大值-最小值+1，默认初值都为0。
        var bucket = Array(repeating: 0, count: bucketCount + 1)
        // 遍历入参数组元素，并给桶做上标记
        for num in array {
            // 数组元素减去最小值，指向桶数组下标
            let index = num - min!
            // 将元素出现次数打上标记，每次+1
            bucket[index] += 1
        }
        // 记录新数组下标
        var arrayIndex = 0
        // 对桶内元素进行遍历
        for i in 0..<bucket.count {
            // 取出每个桶的标记值
            var j = bucket[i]
            // 当桶内有值，根据标记的次数依次减1，添加到数组中
            while j > 0 {
                array[arrayIndex] = i + min!
                j-=1
                arrayIndex+=1
            }
        }
        return array
    }
}
