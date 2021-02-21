//: [Previous](@previous)

/*:
 ## 选择排序（Selection Sort）
 是一种简单直观的排序算法。

 思路：
 - 第1趟：在n个数中找到最小(大)数与第一个数交换位置。
 - 第2趟：在剩下n-1个数中找到最小(大)数与第二个数交换位置。
 ...
 - 第n-1趟：最终可实现数据的升序(降序)排列。

 时间复杂度-平均：O(n^2)
 
 时间复杂度-最优：O(n^2)
 
 时间复杂度-最差：O(n^2)
 
 空间复杂度：O(1)
 
 稳定性：不稳定 
 */
func selectionSort(_ original: [Int]) -> [Int] {
    guard original.count > 1 else {
        return original
    }
    var array = original
    var min = 0
    for i in 0..<array.count - 1 {
        min = i
        for j in i + 1..<array.count - 1 {
            if array[min] > array[j]  {
                min = j
            }
        }
        if min != i {
            let temp = array[i]
            array[i] = array[min]
            array[min] = temp
            // 元祖替换
            // (array[min], array[i]) = (array[i], array[min])
            // swapAt替换
            // array.swapAt(min, i)
        }
    }
    return array
}

let unsortedArray = [33, 51, 49, 24, 70, 4, 8, 0, 90]
print(selectionSort(unsortedArray))

//: [Next](@next)
