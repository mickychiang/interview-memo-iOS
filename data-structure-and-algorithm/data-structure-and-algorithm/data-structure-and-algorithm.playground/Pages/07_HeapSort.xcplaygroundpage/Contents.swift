//: [Previous](@previous)

/*:
 ## 堆排序（Heapsort）
 堆排序 是指利用堆这种数据结构所设计的一种排序算法。
 堆积是一个近似完全二叉树的结构，并同时满足堆积的性质：即子结点的键值或索引总是小于（或者大于）它的父节点。
 
 算法描述
 步骤1：将初始待排序关键字序列(R1,R2….Rn)构建成大顶堆，此堆为初始的无序区；
 步骤2：将堆顶元素R[1]与最后一个元素R[n]交换，此时得到新的无序区(R1,R2,……Rn-1)和新的有序区(Rn),且满足R[1,2…n-1]<=R[n]；
 步骤3：由于交换后新的堆顶R[1]可能违反堆的性质，因此需要对当前无序区(R1,R2,……Rn-1)调整为新堆，然后再次将R[1]与无序区最后一个元素交换，得到新的无序区(R1,R2….Rn-2)和新的有序区(Rn-1,Rn)。不断重复此过程直到有序区的元素个数为n-1，则整个排序过程完成。
 
 ![mergeSort.png](https://imgconvert.csdnimg.cn/aHR0cHM6Ly9pbWFnZXMyMDE3LmNuYmxvZ3MuY29tL2Jsb2cvODQ5NTg5LzIwMTcxMC84NDk1ODktMjAxNzEwMTUyMzEzMDg2OTktMzU2MTM0MjM3LmdpZg)
 
 算法分析
 最佳情况：T(n) = O(nlogn)
 最差情况：T(n) = O(nlogn)
 平均情况：T(n) = O(nlogn)
 空间复杂度：O(1)
 
 稳定性：不稳定
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
