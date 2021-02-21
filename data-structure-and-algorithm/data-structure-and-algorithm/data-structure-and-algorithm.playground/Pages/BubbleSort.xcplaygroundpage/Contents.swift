//: [Previous](@previous)

/*:
 ## 冒泡排序（Bubble Sort）
 是一种简单直观的排序算法。
 它重复地走访要排序的数列，一次比较两个元素，如果他们的顺序错误就把他们交换过来。
 走访数列的工作是重复地进行直到没有再需要交换，也就是说该数列已经排序完成。
 这个算法的名字由来是因为越小的元素会经由交换慢慢“浮”到数列的顶端。

 思路：相邻元素两两比较，比较完一趟，最值出现在末尾。
 - 第1趟：依次比较相邻的两个数，不断交换(举例：小数放前，大数放后)逐个推进，最大值最后出现在第n个元素位置。
 - 第2趟：依次比较相邻的两个数，不断交换(举例：小数放前，大数放后)逐个推进，最大值最后出现在第n-1个元素位置。
 ...
 - 第n-1趟：依次比较相邻的两个数，不断交换(举例：小数放前，大数放后)逐个推进，最大值最后出现在第2个元素位置。

 时间复杂度-平均：O(n^2)
 
 时间复杂度-最优：O(n)
 
 时间复杂度-最差：O(n^2)
 
 空间复杂度：O(1)
 
 稳定性：稳定
 */
func bubbleSort(_ original: [Int]) -> [Int] {
    guard original.count > 1 else {
        return original
    }
    var array = original
    for i in 0..<array.count - 1 {
        for j in 0..<array.count - 1 - i {
            if array[j] > array[j + 1] {
                let temp = array[j]
                array[j] = array[j + 1]
                array[j + 1] = temp
                // 元祖替换
                // (array[j], array[j + 1]) = (array[j + 1], array[j])
                // swapAt替换
                // array.swapAt(j, j + 1)
            }
        }
    }
    return array
}

let unsortedArray = [33, 51, 49, 24, 70, 4, 8, 0, 90]
print(bubbleSort(unsortedArray))


// 冒泡排序的优化
// 1. 设置一个布尔值的变量来标记“该数组是否有序”
func bubbleSortAdvanced(_ original: [Int]) -> [Int] {
    guard original.count > 1 else {
        return original
    }
    var array = original
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

print(bubbleSortAdvanced(unsortedArray))


// 2. 对已经排好序的元素进行边界限定，来减少判断
func bubbleSortAdvancedSuper(_ original: [Int]) -> [Int] {
    guard original.count > 1 else {
        return original
    }
    var array = original
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
print(bubbleSortAdvancedSuper(unsortedArray))


// 3. 鸡尾酒排序(定向冒泡排序)：是冒泡排序的一种变形，以双向在序列中进行排序。
// 思想：
// 将之前完整的一轮循环拆分为从左->右和从右->左两个子循环，这就保证了排序的双向进行，效率较单向循环来说更高。
// 与此同时在这两个循环中加入了之前两个版本的特性isSorted和有序边界，使得排序更加高效。
func bubbleSortAdvancedFinal(_ original: [Int]) -> [Int] {
    guard original.count > 1 else {
        return original
    }
    var array = original
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

print(bubbleSortAdvancedFinal(unsortedArray))

//: [Next](@next)
