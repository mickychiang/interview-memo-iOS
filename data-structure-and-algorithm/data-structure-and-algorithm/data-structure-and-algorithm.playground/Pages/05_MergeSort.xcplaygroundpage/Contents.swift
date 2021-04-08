//: [Previous](@previous)

/*:
 ## 归并排序（Merge Sort）
 ![mergeSort.png](https://i.loli.net/2020/05/24/5bljd7ZYVyCDXvF.png)

 和选择排序一样，归并排序的性能不受输入数据的影响，但表现比选择排序好的多，因为始终都是O(n log n）的时间复杂度。
 代价是需要额外的内存空间。

 归并排序 是建立在归并操作上的一种有效的排序算法。
 该算法是采用分治法（Divide and Conquer）的一个非常典型的应用。
 归并排序是一种稳定的排序方法。
 将已有序的子序列合并，得到完全有序的序列；即先使每个子序列有序，再使子序列段间有序。若将两个有序表合并成一个有序表，称为2-路归并。
      
 算法描述
 步骤1：把长度为n的输入序列分成两个长度为n/2的子序列；
 步骤2：对这两个子序列分别采用归并排序；
 步骤3：将两个排序好的子序列合并成一个最终的排序序列。

 算法分析
 最佳情况：T(n) = O(nlogn)
 最差情况：T(n) = O(nlogn)
 平均情况：T(n) = O(nlogn)
 空间复杂度： O(n)
 
 稳定性：稳定
 */
func mergeSort(_ original: [Int]) -> [Int] {
    guard original.count > 1 else {
        return original
    }
    let array = original
    let middleIndex = array.count / 2
    let leftArray = mergeSort(Array(array[0..<middleIndex]))
    let rightArray = mergeSort(Array(array[middleIndex..<array.count]))
    return merge(leftArray, rightArray)
}

func merge(_ leftArray: [Int], _ rightArray: [Int]) -> [Int] {
    var leftIndex = 0
    var rightIndex = 0
    var sortedArray = [Int]()
    
    while leftIndex < leftArray.count && rightIndex < rightArray.count {
        if leftArray[leftIndex] < rightArray[rightIndex] {
            sortedArray.append(leftArray[leftIndex])
            leftIndex += 1
        } else if leftArray[leftIndex] > rightArray[rightIndex] {
            sortedArray.append(rightArray[rightIndex])
            rightIndex += 1
        } else {
            sortedArray.append(leftArray[leftIndex])
            leftIndex += 1
            sortedArray.append(rightArray[rightIndex])
            rightIndex += 1
        }
    }
    
    while leftIndex < leftArray.count {
        sortedArray.append(leftArray[leftIndex])
        leftIndex += 1
    }
    
    while rightIndex < rightArray.count {
        sortedArray.append(rightArray[rightIndex])
        rightIndex += 1
    }
    
    return sortedArray
}

let unsortedArray = [33, 51, 49, 24, 70, 4, 8, 0, 90]
print(mergeSort(unsortedArray))

//: [Next](@next)
