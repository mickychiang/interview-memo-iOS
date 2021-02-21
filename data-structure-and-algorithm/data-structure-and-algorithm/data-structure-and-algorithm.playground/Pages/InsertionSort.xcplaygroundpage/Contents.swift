//: [Previous](@previous)

/*:
 ## 插入排序（Insertion Sort）
 是一种最简单直观的排序算法，它的工作原理是通过构建有序序列，对于未排序数据，在已排序序列中从后向前扫描，找到相应位置并插入。
 - 从数组中拿出一个元素A（通常就是第一个元素）以后，再从数组中**按顺序**拿出元素B。
 - 如果元素B比元素A小，就放在元素A左侧；反之，则放在右侧。

 时间复杂度-平均：O(n^2)
 
 时间复杂度-最优：O(n)
 
 时间复杂度-最差：O(n^2)
 
 空间复杂度： O(1)
 
 稳定性：稳定
 */
func insertionSort(_ original: [Int]) -> [Int] {
    guard original.count > 1 else {
        return original
    }
    var array = original
    for i in 1..<array.count - 1 {
        var j = i
        while j > 0 && array[j] < array[j - 1] {
            let temp = array[j - 1]
            array[j - 1] = array[j]
            array[j] = temp
            // 元祖替换
            // (array[j - 1], array[j]) = (array[j], array[j - 1])
            // swapAt替换
            // array.swapAt(j - 1, j)
            j -= 1
        }
    }
    return array
}

let unsortedArray = [33, 51, 49, 24, 70, 4, 8, 0, 90]
print(insertionSort(unsortedArray))

//: [Next](@next)
