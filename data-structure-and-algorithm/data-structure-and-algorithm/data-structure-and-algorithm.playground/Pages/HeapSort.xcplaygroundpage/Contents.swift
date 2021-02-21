//: [Previous](@previous)

/*:
 
 */
func heapSort(_ original: [Int]) -> [Int] {
    guard original.count > 1 else {
        return original
    }
    var array = original
    // 构建大顶堆 从最后一个非叶子结点倒序遍历
    for i in (0...(array.count/2-1)).reversed() {
        // 从第一个非叶子结点从下至上，从右至左调整结构
        array = adjustHeap(array, i: i, length: array.count)
        print("array = \(array)")
    }
    // 上面已将输入数组调整成堆结构
    for j in (1...(array.count - 1)).reversed() {
        // 堆顶元素与末尾元素进行交换
        array.swapAt(0, j)
        array = adjustHeap(array, i:0, length:j)
        print("array2 = \(array)")
    }
    return array
}

func adjustHeap(_ original: [Int], i: Int, length: Int) -> [Int] {
    var array = original
    var j = i
    // 取出当前元素i
    let tmp = array[j]
    var k = 2*i+1
    while k < length {
        // 左子节点小于右子节点
        if(k+1 < length && array[k] < array[k+1]) {
            //取到右子节点下标
            k+=1
        }
        if(array[k] > tmp){
            // 如果子节点大于父节点，将子节点值赋给父节点（不用进行交换）
            array[j] = array[k]
            j = k
        } else {
            break
        }
        k = k*2 + 1
    }
    // 将tmp值放到最终的位置
    array[j] = tmp
    return array
}

let unsortedArray = [50, 10, 90, 30, 70, 40, 80, 60, 20]
print(heapSort(unsortedArray))

//: [Next](@next)
