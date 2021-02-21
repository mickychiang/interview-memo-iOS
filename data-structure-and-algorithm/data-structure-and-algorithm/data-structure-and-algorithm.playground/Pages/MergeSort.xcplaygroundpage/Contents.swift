//: [Previous](@previous)

/*:
 ## 归并排序（Merge Sort）
 是建立在归并操作上的一种有效的排序算法。该算法是采用分治法（Divide and Conquer）的一个非常典型的应用。

 ![mergeSort.png](https://i.loli.net/2020/05/24/5bljd7ZYVyCDXvF.png)

 归并操作(采用分治思想)是建立在归并操作的排序算法，是将需要排序的序列进行拆分，拆分成每一个单一元素。
 这时再按每个元素进行比较排序，两两合并，生成新的有序序列。再对新的有序序列进行两两合并操作，直到整个序列有序。
      
 归并操作的实现步骤是：
 - 新建空数组，初始化两个传入数组的index为0
 - 两两比较两个数组index上的值，较小的放在新建数组里面并且index+1。
 - 最后检查是否有剩余元素，如果有则添加到新建数组里面。

 时间复杂度-平均：O(nlogn)
 
 时间复杂度-最优：O(nlogn)
 
 时间复杂度-最差：O(nlogn)
 
 空间复杂度： O(1)
 
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
