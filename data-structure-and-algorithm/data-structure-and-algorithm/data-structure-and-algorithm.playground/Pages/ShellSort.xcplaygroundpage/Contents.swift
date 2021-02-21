//: [Previous](@previous)

/*:
 ## 希尔排序（Shell Sort）
 也称递减增量排序算法，是插入排序的一种更高效的改进版本。但希尔排序是非稳定排序算法。

 希尔排序的基本思想是：先将整个待排序的记录序列分割成为若干子序列分别进行直接插入排序，待整个序列中的记录“基本有序”时，再对全体记录进行依次直接插入排序。

 思路：
 - 选择一个增量序列t1，t2，…，tk，其中ti>tj，tk=1；
 - 按增量序列个数k，对序列进行k 趟排序；
 - 每趟排序，根据对应的增量ti，将待排序列分割成若干长度为m 的子序列，分别对各子表进行直接插入排序。仅增量因子为1 时，整个序列作为一个表来处理，表长度即为整个序列的长度。

 时间复杂度-平均：O(n^1.3)
 
 时间复杂度-最优：O(n)
 
 时间复杂度-最差：O(n^2)
 
 空间复杂度： O(1)
 
 稳定性：不稳定
 */
func shellSort(_ original: [Int]) -> [Int] {
    guard original.count > 1 else {
        return original
    }
    var array = original
    // 起始间隔值gap设置为总数的一半，直到 gap==1 结束
    var gap = array.count / 2
    while gap >= 1 {
        for i in gap..<array.count {
            let temp = array[i]
            var j = i
            while j >= gap && temp < array[j - gap] {
                array[j] = array[j - gap]
                j -= gap
            }
            array[j] = temp
        }
        gap = gap / 2
    }
    return array
}

let unsortedArray = [33, 51, 49, 24, 70, 4, 8, 0, 90]
print(shellSort(unsortedArray))

//: [Next](@next)
