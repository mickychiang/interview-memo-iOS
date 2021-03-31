//: [Previous](@previous)

/*:
 ## 快速排序（Quick Sort）
 快速排序的基本思想：
 通过一趟排序将待排记录分隔成独立的两部分，其中一部分记录的关键字均比另一部分的关键字小，则可分别对这两部分记录继续进行排序，以达到整个序列有序。

 算法描述
 快速排序使用分治法来把一个串（list）分为两个子串（sub-lists）。具体算法描述如下：
 步骤1：从数列中挑出一个元素，称为 **“基准”（pivot ）**；
 步骤2：重新排序数列，所有元素比基准值小的摆放在基准前面，所有元素比基准值大的摆在基准的后面（相同的数可以到任一边）。在这个分区退出之后，该基准就处于数列的中间位置。这个称为分区（partition）操作；
 步骤3：递归地（recursive）把小于基准值元素的子数列和大于基准值元素的子数列排序。

 算法分析
 最佳情况：T(n) = O(nlogn)
 最差情况：T(n) = O(n^2)
 平均情况：T(n) = O(nlogn)s
 空间复杂度：O(logn)
 
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
