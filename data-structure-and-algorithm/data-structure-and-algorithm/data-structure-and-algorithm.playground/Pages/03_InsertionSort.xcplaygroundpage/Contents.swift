//: [Previous](@previous)

/*:
 ## 插入排序（Insertion Sort）
 插入排序的算法描述是一种简单直观的排序算法。
 它的工作原理是通过构建有序序列，对于未排序数据，在已排序序列中从后向前扫描，找到相应位置并插入。插入排序在实现上，通常采用in-place排序（即只需用到O(1)的额外空间的排序），因而在从后向前扫描过程中，需要反复把已排序元素逐步向后挪位，为最新元素提供插入空间。

 算法描述
 一般来说，插入排序都采用in-place在数组上实现。具体算法描述如下：
 步骤1: 从第一个元素开始，该元素可以认为已经被排序；
 步骤2: 取出下一个元素，在已经排序的元素序列中从后向前扫描；
 步骤3: 如果该元素（已排序）大于新元素，将该元素移到下一位置；
 步骤4: 重复步骤3，直到找到已排序的元素小于或者等于新元素的位置；
 步骤5: 将新元素插入到该位置后；
 步骤6: 重复步骤2~5。
 
 算法分析
 最佳情况：T(n) = O(n)
 最坏情况：T(n) = O(n^2)
 平均情况：T(n) = O(n^2)
 空间复杂度： O(1)
 
 稳定性：稳定
 */
func insertionSort(_ original: [Int]) -> [Int] {
    guard original.count > 1 else {
        return original
    }
    var array = original
    for i in 1..<array.count - 1 {
        var preIndex = i
        while preIndex > 0 && array[preIndex] < array[preIndex - 1] {
            let temp = array[preIndex - 1]
            array[preIndex - 1] = array[preIndex]
            array[preIndex] = temp
            preIndex -= 1
        }
    }
    return array
}

let unsortedArray = [33, 51, 49, 24, 70, 4, 8, 0, 90]
print(insertionSort(unsortedArray))

//: [Next](@next)
