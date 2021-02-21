//: [Previous](@previous)

/*:
 ## 快速排序（Quick Sort）
 是由东尼·霍尔所发展的一种排序算法。在平均状况下，排序 n 个项目要Ο(n log n)次比较。在最坏状况下则需要Ο(n2)次比较，但这种状况并不常见。事实上，快速排序通常明显比其他Ο(n log n) 算法更快，因为它的内部循环（inner loop）可以在大部分的架构上很有效率地被实现出来。
 快速排序使用分治法（Divide and conquer）策略来把一个串行（list）分为两个子串行（sub-lists）。

 快速排序是一种高效的排序方法，它利用了归并排序的思想，
 将需要排列的数组拆分成每一小部分，然后让每一小部分进行排序、合并，最后得到完整的排序序列。

 思路：
 - 从数列中挑出一个元素，称为 “基准”（pivot），
 - 重新排序数列，所有元素比基准值小的摆放在基准前面，所有元素比基准值大的摆在基准的后面（相同的数可以到任一边）。在这个分区退出之后，该基准就处于数列的中间位置。这个称为分区（partition）操作。
 - 递归地（recursive）把小于基准值元素的子数列和大于基准值元素的子数列排序。

 时间复杂度-平均：O(nlogn)
 
 时间复杂度-最优：O(nlogn)
 
 时间复杂度-最差：O(n^2)
 
 空间复杂度：O(logn)~O(n)
 
 稳定性：不稳定
 */
func quickSort(_ orignial: [Int]) -> [Int] {
    guard orignial.count > 1 else {
        return orignial
    }
    // 取出数组中间下标元素
    let pivot = orignial[orignial.count / 2]
    // 用到了函数式方法filter，过滤元素
    let left = orignial.filter { $0 < pivot }
    let middle = orignial.filter { $0 == pivot }
    let right = orignial.filter { $0 > pivot }
    // 递归 对新数组进行合并
    return quickSort(left) + middle + quickSort(right)
}

let unsortedArray = [33, 51, 49, 24, 70, 4, 8, 0, 90]
print(quickSort(unsortedArray))

//: [Next](@next)
