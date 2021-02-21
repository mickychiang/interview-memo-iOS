//: [Previous](@previous)

// MARK: - 有序数组的合并
// 将有序数组a和b的值合并到一个数组result当中，且仍然保持有序。

func mergeOrderedList(_ array1: [Int], _ array2: [Int]) -> [Int] {
    var result: [Int] = []
    // 遍历数组a的指针、遍历数组b的指针、
    var p = 0
    var q = 0
    // 任一数组没有到达边界 则进行遍历
    while p < array1.count && q < array2.count {
        // 如果数组a对应位置的值小于数组b对应位置的值
        if array1[p] < array2[q] {
            // 存储数组a的值
            result.append(array1[p])
            // 移动数组a的遍历指针
            p += 1
        } else {
            // 存储数组b的值
            result.append(array2[q])
            // 移动数组b的遍历指针
            q += 1
        }
    }
    // 如果数组a有剩余
    while p < array1.count {
        // 将数组a剩余的部分拼接到合并结果的后面
        result.append(array1[p])
        p += 1
    }
    // 如果数组b有剩余
    while q < array2.count {
        // 将数组b剩余的部分拼接到合并结果的后面
        result.append(array2[q])
        q += 1
    }
    return result
}

let array1 = [1,4,6,7,9]
let array2 = [2,3,5,6,8,10,11,12]
print(mergeOrderedList(array1, array2))

//: [Next](@next)
