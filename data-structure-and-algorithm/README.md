# data-structure-and-algorithm

此篇文章是对**数据结构**和**算法**的整理，会根据日常知识的积累不断的进行更新与完善。  
有理解不对的地方还请指正，互相学习。   
**语言**：Swift、Objective-C、C 等    
**梯度**：基础、进阶、高阶  
①基础：必须精通逻辑并可以完全默写出来。  
②进阶：必须精通逻辑并可以写出正确的思路。  
③高阶：熟悉逻辑并能给出解题思路或伪代码即可。（面试前可稍微看一下，不会没关系，不能影响面试心态。）  
注意：  
1. 基本上，面试过程中的算法题都是笔试题。  
2. 所有算法以Swift优先。（如果面试官不指定语言环境的话）  
3. 所有算法只要记住其中1种解题思路即可。
  
**重点理解排序算法和进阶算法题，面试会经常提问。**


<!-- # 数据结构 -->


# 算法

## 一. 基础知识

### 时间复杂度
>时间复杂度：在计算机科学中，算法的时间复杂度是一个函数，它定性描述了该算法的运行时间，通常用大O符号表示。

算法的时间复杂度是指算法需要消耗的时间资源。  
一般来说，计算机算法是问题规模!n的函数f(n)，算法的时间复杂度也因此记做：  
![TimeComplexity.png](https://i.loli.net/2020/05/24/fkCHL8JhZnlQdRF.png)

常见的时间复杂度有：
- 常数阶O(1)
- 对数阶O(log n）
- 线性阶 O(n)
- 线性对数阶O(nlog n)
- 平方阶O(n^{2})
- 立方阶O(n^{3})
- !k次方阶O(n^{k})
- 指数阶 O(2^{n})}

随着问题规模n的不断增大，上述时间复杂度不断增大，算法的执行效率越低。

### 空间复杂度

算法的空间复杂度是指算法需要消耗的空间资源。其计算和表示方法与时间复杂度类似，一般都用复杂度的渐近性来表示。同时间复杂度相比，空间复杂度的分析要简单得多。而且控件复杂度不属于本文讨论的重点，因此在这里不展开介绍了。


## 二. 排序

排序包括**内部排序**和**外部排序**
- 内部排序：数据在内存中进行排序。
- 外部排序：因排序的数据很大，一次不能容纳全部的排序记录，在排序过程中需要访问外存。

![sorted_algorithm.png](https://i.loli.net/2021/02/21/H5wkDoPnXeQYBsW.png)

![sorted_algorithm_2.png](https://i.loli.net/2021/02/21/2pEWFHOBzAy7fV4.png)

以下内容为内部排序。  
算法基于Swift语言的实现。(Objective-C等其他语言请参考工程)

### 1. 冒泡排序

>冒泡排序（Bubble Sort）是一种简单直观的排序算法。  
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

代码
```
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
```
调用
```
let unsortedArray = [33, 51, 49, 24, 70, 4, 8, 0, 90]
print(bubbleSort(unsortedArray))
```
输出
```
[0, 4, 8, 24, 33, 49, 51, 70, 90]
```

### 2. 选择排序

>选择排序（Selection Sort）是一种简单直观的排序算法。

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

代码
```
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
```
调用
```
let unsortedArray = [33, 51, 49, 24, 70, 4, 8, 0, 90]
print(selectionSort(unsortedArray))
```
输出
```
[0, 4, 8, 24, 33, 49, 51, 70, 90]
```

### 3. 归并排序

>归并排序（Merge Sort）是建立在归并操作上的一种有效的排序算法。该算法是采用分治法（Divide and Conquer）的一个非常典型的应用。

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

代码
```
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
```
调用
```
let unsortedArray = [33, 51, 49, 24, 70, 4, 8, 0, 90]
print(mergeSort(unsortedArray))
```
输出
```
[0, 4, 8, 24, 33, 49, 51, 70, 90]
```

### 4. 快速排序

>快速排序（Quick Sort）是由东尼·霍尔所发展的一种排序算法。在平均状况下，排序 n 个项目要Ο(n log n)次比较。在最坏状况下则需要Ο(n2)次比较，但这种状况并不常见。事实上，快速排序通常明显比其他Ο(n log n) 算法更快，因为它的内部循环（inner loop）可以在大部分的架构上很有效率地被实现出来。
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

代码
```
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
```
调用
```
let unsortedArray = [33, 51, 49, 24, 70, 4, 8, 0, 90]
print(quickSort(unsortedArray))
```
输出
```
[0, 4, 8, 24, 33, 49, 51, 70, 90]
```

### 5. 插入排序

>插入排序（Insertion Sort）是一种最简单直观的排序算法，它的工作原理是通过构建有序序列，对于未排序数据，在已排序序列中从后向前扫描，找到相应位置并插入。

![insertion_sort.gif](https://i.loli.net/2021/02/21/NBwmqZ3ejOsIQ6x.gif)

思路：
- 从数组中拿出一个元素A（通常就是第一个元素）以后，再从数组中**按顺序**拿出元素B。  
- 如果元素B比元素A小，就放在元素A左侧；反之，则放在右侧。 

时间复杂度-平均：O(n^2)  
时间复杂度-最优：O(n)  
时间复杂度-最差：O(n^2)   
空间复杂度： O(1)  
稳定性：稳定 

代码
```
func insertionSort(_ original: [Int]) -> [Int] {
    guard original.count > 1 else {
        return original
    }
    var array = original
    for i in 1..<array.count - 1 {
        var j = i
        while j > 0 && array[j] < array[j - 1] {
            let temp = array[j - 1]
            array[j - 1] = array[j]
            array[j] = temp
            // 元祖替换
            // (array[j - 1], array[j]) = (array[j], array[j - 1])
            // swapAt替换
            // array.swapAt(j - 1, j)
            j -= 1
        }
    }
    return array
}
```
调用
```
let unsortedArray = [33, 51, 49, 24, 70, 4, 8, 0, 90]
print(insertionSort(unsortedArray))
```
输出
```
[0, 4, 8, 24, 33, 49, 51, 70, 90]
```

### 6. 希尔排序

>希尔排序（Shell Sort）也称递减增量排序算法，是插入排序的一种更高效的改进版本。但希尔排序是非稳定排序算法。

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

代码
```
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
```
调用
```
let unsortedArray = [33, 51, 49, 24, 70, 4, 8, 0, 90]
print(shellSort(unsortedArray))
```
输出
```
[0, 4, 8, 24, 33, 49, 51, 70, 90]
```

### 7. 堆排序

>堆排序（Heap Sort）是指利用堆这种数据结构所设计的一种排序算法。堆积是一个近似完全二叉树的结构，并同时满足堆积的性质：即子结点的键值或索引总是小于（或者大于）它的父节点。
堆排序的平均时间复杂度为Ο(nlogn) 。

![heap_sort.png](https://i.loli.net/2021/02/21/Z7ro3J82pNWKvyY.png)

利用堆这种数据结构而设计的一种排序算法，是选择排序的一种。  
通过调整堆结构，将堆的顶部元素（即数组第0位元素）与末尾的元素进行交换，调整后将末尾元素固定，  
然后继续调整新的堆结构，每次调整固定一个元素，遍历结束后从而达到排序的效果。  

时间复杂度-平均：O(nlogn)  
时间复杂度-最优：O(nlogn)  
时间复杂度-最差：O(nlogn)  
稳定性：不稳定

代码
```
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
```
调用
```
let unsortedArray = [50, 10, 90, 30, 70, 40, 80, 60, 20]
print(heapSort(unsortedArray))
```
输出
```
array = [50, 10, 90, 60, 70, 40, 80, 30, 20]
array = [50, 10, 90, 60, 70, 40, 80, 30, 20]
array = [50, 70, 90, 60, 10, 40, 80, 30, 20]
array = [90, 70, 80, 60, 10, 40, 50, 30, 20]
array2 = [80, 70, 50, 60, 10, 40, 20, 30, 90]
array2 = [70, 60, 50, 30, 10, 40, 20, 80, 90]
array2 = [60, 30, 50, 20, 10, 40, 70, 80, 90]
array2 = [50, 30, 40, 20, 10, 60, 70, 80, 90]
array2 = [40, 30, 10, 20, 50, 60, 70, 80, 90]
array2 = [30, 20, 10, 40, 50, 60, 70, 80, 90]
array2 = [20, 10, 30, 40, 50, 60, 70, 80, 90]
array2 = [10, 20, 30, 40, 50, 60, 70, 80, 90]
[10, 20, 30, 40, 50, 60, 70, 80, 90]
```

### 8. 基数排序(桶排序)

>基数排序（Radix Sort）是一种非比较型整数排序算法，其原理是将整数按位数切割成不同的数字，然后按每个位数分别比较。由于整数也可以表达字符串（比如名字或日期）和特定格式的浮点数，所以基数排序也不是只能使用于整数。

桶排序：  
将数组分到n个相同的大小的子区间，每个子区间就是一个桶，然后将输入数组中的元素一一对应，放入对应子区间内的桶中。  
最后遍历每个桶，依次输入每个桶中对应装的数据即可。  
因为桶的顺序是有序的，所以只要从第一个桶开始遍历，得到的结果也就是有序的数组。  

```
func bucketSort(_ original: [Int]) -> [Int] {
    guard original.count > 1 else {
        return original
    }
    var array = original
    // 求出桶的数量
    let max = array.max()
    let min = array.min()
    let bucketCount = max! - min!
    // 创建桶数组，桶个数=最大值-最小值+1，默认初值都为0。
    var bucket = Array(repeating: 0, count: bucketCount + 1)
    // 遍历入参数组元素，并给桶做上标记
    for num in array {
        // 数组元素减去最小值，指向桶数组下标
        let index = num - min!
        // 将元素出现次数打上标记，每次+1
        bucket[index] += 1
    }
    // 记录新数组下标
    var arrayIndex = 0
    // 对桶内元素进行遍历
    for i in 0..<bucket.count {
        // 取出每个桶的标记值
        var j = bucket[i]
        // 当桶内有值，根据标记的次数依次减1，添加到数组中
        while j > 0 {
            array[arrayIndex] = i + min!
            j-=1
            arrayIndex+=1
        }
    }
    return array
}
```
调用
```
let unsortedArray = [33, 51, 49, 24, 70, 4, 8, 0, 90]
print(bucketSort(unsortedArray))
```
输出
```
[0, 4, 8, 24, 33, 49, 51, 70, 90]
```

## 三. 基础题

### 1. 计算从1到100数字的总和

法1. 1到100循环遍历逐步相加  
时间复杂度：O(n)
```
func sum1(_ n: Int) -> Int {
    var sum = 0
    for i in 1...n {
        sum += i
    }
    return sum
}
```

法2. 递归求和  
时间复杂度：O(n)  
- 算法的时间复杂度是多少 ?  - O(n)  
- 递归会有什么缺点 ? - 递归次数过多的时候会造成栈溢出，操作系统给应用程序分配的栈空间是有限的，每次函数调用都会分配一段栈空间， 当栈空间不够的时候，程序也有崩了。  
- 不用递归能否实现，复杂度能否降到O(1) ? - 等差数列求和 (n + 1) * n / 2  
```
func sum2(_ n: Int) -> Int {
    guard n > 0 else {
        return 0
    }
    let sum = n
    return sum + sum2(sum - 1)
}
```

法3. 等差数列求和  
时间复杂度：O(1)
```  
func sum3(_ n: Int) -> Int {
    return (n + 1) * n / 2
    // 或者使用 >> 运算
    //return (n + 1) * n >> 1
}
```

### 2. 给出一个整型数组和一个目标值，判断数组中是否有两个数之和等于目标值

时间复杂度：O(n)
```
func twoSumEqualTarget(nums: [Int], _ target: Int) -> Bool {
    // 初始化集合
    var set = Set<Int>()
    // 遍历整型数组
    for num in nums {
        // 判断集合中是否包含 目标值-当前值 的结果
        if set.contains(target - num) {
            // 包含 返回true
            return true
        }
        // 不包含 将当前值存进集合 用作下次判断
        set.insert(num)
    }
    // 都不包含 返回false
    return false
}
```
调用
```
twoSumEqualTarget(nums: [2,7,11,15], 9)
```
输出
```
true
```

### 3. 给出一个整型数组和目标值，且数组中有且仅有两个数之和等于目标值，求这两个数在数组中的index

巧妙的用到了字典的特性，用key表示数组的值，通过判断字典中是否含有目标值的key来取出索引。  
时间复杂度：O(n)
```
func getIndexAboutTwoSumEqualTarget(nums: [Int], _ target: Int) -> [Int] {
    // 初始化字典
    var dict = [Int: Int]()
    // 通过索引i和对应的num进行判断
    for (i, num) in nums.enumerated() {
        // 从dict字典中取出之前保存的索引，判断是否存在索引
        if let lastIndex = dict[target - num] {
            // 返回之前存的索引和当前索引
            return [lastIndex, i]
        } else {
            // 保存当前索引，用于后续判断
            dict[num] = i
        }
    }
    // 致命错误来终止程序
    fatalError("No valid output!")
}
```
调用
```
getIndexAboutTwoSumEqualTarget(nums: [2,7,11,15], 9)
```
输出
```
[0, 1]
```

### 4. 实现阶乘n!的算法 3！= 3 * 2 * 1 = 6

使用递归
```
func factorial(_ n: Int) -> Int {
    return n < 2 ? 1: n * factorial(n-1)
}
```

### 5. 不用中间变量，交换A和B的值

#### Swift可以利用元组特性直接交换  
```
func swap(a: inout Int, b: inout Int) -> (Int, Int) {
    (a, b) = (b, a)
    return (a, b) 
}
```
```
var x = 1, y = 2
swap(a: &x, b: &y)
x　// 2
y　// 1
```

#### ~~方法1. 中间变量~~
```
func swap1(a: inout Int, b: inout Int) -> (Int, Int) {
    let temp = a
    a = b
    b = temp
    return (a, b)
}
```

#### 方法2. 加法
```
func swap2(a: inout Int, b: inout Int) -> (Int, Int) {
    a = a + b
    b = a - b
    a = a - b
    return (a, b)
}
```

#### 方法3. 异或（相同为0，不同为1。可以理解为不进位加法）
```
func swap3(a: inout Int, b: inout Int) -> (Int, Int) {
    a = a ^ b
    b = a ^ b
    a = a ^ b
    return (a, b)
}
```

### 6. 最大公约数

比如：20和4的最大公约数为4；18和27的最大公约数为9  

#### 方法1. 直接遍历法
```
func maxCommonDivisor1(a: Int, b: Int) -> Int {
    var max = 0
    for i in 1...b {
        if (a % i == 0 && b % i == 0) {
            max = i
        }
    }
    return max
}
```
调用
```
var xx = 18, yy = 27
print("origin: x = \(xx), y = \(yy)")
print(maxCommonDivisor1(a: xx, b: yy))
```
输出
```
origin: x = 18, y = 27
9
```

#### 方法2. 辗转相除法：其中规定a为大数，b为小数
```
func maxCommonDivisor2(a: inout Int, b: inout Int) -> Int {
    var r: Int
    while (a % b > 0) {
        r = a % b
        a = b
        b = r
    }
    return b
}
```


### 7. 最小公倍数

公式：最小公倍数 = (a * b)/最大公约数  

#### 方法1. 直接遍历法
```
func minimumCommonMultiple1(a: Int, b: Int) -> Int {
    var max = 0
    for i in 1...b {
        if (a % i == 0 && b % i == 0) {
            max = i
        }
    }
    return (a * b) / max
}
```
调用
```
var xxx = 18, yyy = 27
print("origin: x = \(xxx), y = \(yyy)")
print(minimumCommonMultiple1(a: xxx, b: yyy))
```
输出
```
origin: x = 18, y = 27
54
```

#### 方法2. 辗转相除法：其中a为大数，b为小数
```
func minimumCommonMultiple2(a: inout Int, b: inout Int) -> Int {
    var r: Int
    let aa = a, bb = b
    while (a % b > 0) {
        r = a % b
        a = b
        b = r
    }
    return (aa * bb) / b
}
```

### 8. 判断质数

比如：2、3、5、7、11、13、19等只能被1和自身整除的数叫质数  
直接判断：一个个除，看余数是否为零，如果不为零，则是质数。
```
func isPrime(_ n: Int) -> Bool {
    for i in 2...n - 1 {
        if n % i == 0 {
            return false
        }
    }
    return true
}
```
调用
```
print("15 isPrime : \(isPrime(15))")
print("17 isPrime : \(isPrime(17))")
```
输出
```
15 isPrime : false
17 isPrime : true
```

### 9. 是否是丑数

丑数：一个数的因子只包含2，3，5的数  
数字1也看作是丑数，所以从1开始的10个丑数分别为1，2，3，4，5，6，8，9，10，12。

```
func isUgly(_ n: inout Int) -> Bool {
    if n == 0 {
        return false
    }
    if n == 1 {
        return true
    }
    // 能否被2整除
    while n % 2 == 0 {
        n /= 2
    }
    // 能否被3整除
    while n % 3 == 0 {
        n /= 3
    }
    // 能否被5整除
    while n % 5 == 0 {
        n /= 5
    }
    if n == 1 {
        return true
    }
    return false
}
```

### 10. 是否是2的幂

```
func isPowerOfTwo(_ n: inout Int) -> Bool {
    if n > 1 {
        while n%2 == 0 {
            n = n/2
        }
    }
    return n == 1
}
```

### 11. 是否是3的幂

```
func isPowerOfThree(_ n: inout Int) -> Bool {
    if n > 1 {
        while n%3 == 0 {
            n = n/3
        }
    }
    return n == 1
}
```

### 12. 质数的个数

```
func countPrimes(_ n: Int) -> Int {
    var count = 0
    if n > 2 {
        count += 1
    }
    for i in 3..<n {
        if isPrime(i) {
            count += 1
        }
    }
    return count
}
```

### 13. 数组中是否包含重复的元素

```
func containsDuplicate(nums: [Int]) -> Bool {
    var set = Set<Int>()
    for num in nums {
        if set.contains(num) {
            return true
        }
        set.insert(num)
    }
    return false
}
```

### 14. 数组中出现次数超过数组长度一半的元素

```
func majorityElement(nums: [Int]) -> [Int] {
    var dict = [Int: Int]()
    for num in nums {
        if let count = dict[num] {
            var temp = count
            temp += 1
            dict[num] = temp
        } else {
            dict[num] = 1
        }
    }
    
    var targetNums: [Int] = []
    for (num, count) in dict {
        if count > nums.count / 2 {
            targetNums.append(num)
        }
    }
    
    return targetNums
}
```

### 15. 数组中只出现过一次的元素

```
func singleNumber(nums: [Int]) -> [Int] {
    var dict = [Int: Int]()
    for num in nums {
        if let count = dict[num] {
            var temp = count
            temp += 1
            dict[num] = temp
        } else {
            dict[num] = 1
        }
    }
    
    var singleNum: [Int] = []
    for (num, count) in dict {
        if count == 1 {
            singleNum.append(num)
        }
    }
    
    return singleNum
}
```

### 16. 寻找数组中缺失的数字

```
// Given an array containing n distinct numbers taken from 0, 1, 2, ..., n, find the one that is missing from the array.
func missingNumber(nums: [Int]) -> Int {
    var result = (nums.count + 1) * nums.count / 2
    for num in nums {
        result -= num
    }
    //        var missingNum: [Int] = []
    return result
}
```

### 17. 移除数组中等于某个值的元素

```
func removeElement(nums: inout [Int], targetNum: Int) {
    for num in nums {
        if num == targetNum {
            nums.remove(at: num)
        }
    }
}
```

## 四. 进阶题

### 1. 反转字符串

#### 1.1 反转字符：要求将其按照字符顺序进行反转。

举例："Hello World!" -> "!dlroW olleH"

代码 
```
func reverseChars(_ str: String) -> String {

    var chars = Array(str)

    var start = 0
    var end = chars.count - 1

    while start < end {
        (chars[start], chars[end]) = (chars[end], chars[start])
        start += 1
        end -= 1
    } 
    
    return String(chars)
}
```

调用
```
var str = "Hello World!"
print(reverseChars(str))
```

输出  
```
!dlroW olleH
```
  
#### 1.2 反转单词：要求将其按照单词顺序进行反转。

举例："Hello World!" -> "World! Hello" 

- 思路1. 
  1. 根据 空格 分割成数组
  2. 交换 i 和 count - i - 1 位置的元素
  3. 最后拼接

代码
```
func reverseWords2(_ str: String) -> String {
    var arr = str.components(separatedBy: " ")
    let count = arr.count
    for i in 0..<count / 2 {
        arr.swapAt(i, count - i - 1)
    }
    var newStr = arr.reduce("") { (result, elem) -> String in
        result + " " + elem
    }
    newStr.removeFirst() // 删除空格
    return newStr
}
```

- 思路2.
  1. 以输入字符串为"Hello World!"为例，首先将该字符串分割成一个个的小字符数组，然后反转成"!dlroW olleH"。
  2. 接着我们通过判断字符数组中的空格位和最后一位字符，对单一的单词进行分段反转，更新start位置。
  3. 最后输出我们需要的结果"World! Hello"。

代码
```
func reverseWords(_ str: String) -> String {
    
    var chars = Array(str)

    var start = 0
    let end = chars.count - 1

    _reverse(&chars, start, end)
    
    for i in 0..<chars.count {
        // 当i等于 数组最后一位 或者遇到空格时 反转字符串
        if i == chars.count - 1 || chars[i + 1] == " " {
            // 将每个单独的单词进行反转
            _reverse(&chars, start, i)
            // 更新start位置
            start = i + 2
        }
    }
    
    return String(chars)
}

// 反转字符串
func _reverse<T>(_ chars: inout[T], _ start: Int, _ end: Int) {

    var start = start, end = end

    while start < end {

        swap(&chars, start, end)

        start += 1
        end -= 1
    }
}

// 将p、q字符的位置进行互换，这种写法也是swift里的一大亮点
func swap<T>(_ chars: inout[T], _ p: Int, _ q: Int) {
    (chars[p], chars[q]) = (chars[q], chars[p])
}
```

调用
```
var str = "Hello World!"
print(reverseWords(str))
print(reverseWords2(str))
```

输出  
```
World! Hello
World! Hello
```

### 3. 反转单链表[※※※※※]

![reverseList.png](https://i.loli.net/2020/06/17/YoqdtV8iDOXTHmB.png)  
![reverseList-HeadInsertion.png](https://i.loli.net/2020/06/17/YZAX9LeVd3aNxbR.png)  

代码
```
// MARK: - 节点 Node
// 每个节点包括两个部分：数据域和下个节点的指针域。
class Node {
    // 数据域
    var data: Int
    // 指针域
    var next: Node?
    
    init(_ data: Int) {
        self.data = data
        self.next = nil
    }
}

// MARK: - 单链表
class LinkedList {
    var headNode: Node?

    init(_ n: Int = 5) {
        var curNode: Node?
        for i in 0..<n {
            let node: Node = Node(i)
            if headNode == nil {
                headNode = node
            } else {
                curNode?.next = node
            }
            curNode = node
        }
    }
    
    // 删除头节点
    func remove(node: inout Node?) {
        if let n = node {
            if let next = n.next {
                n.data = next.data
                n.next = next.next
            } else {
                node = nil
            }
        }
    }
}

// MARK: - 反转链表
extension LinkedList {
    func reversed() {
        /// nodeA.next 指向上一级 nodeB
        func reverse(curNode: Node?, preNode: Node?) -> Node? {
            if let node = curNode {
                let nextNode = node.next
                if nextNode == nil {
                    headNode = node
                }
                node.next = preNode
                return reverse(curNode: nextNode, preNode: node)
            } else {
                return preNode
            }
        }
        _ = reverse(curNode: headNode, preNode: nil)
    }
}

// MARK: - 输出链表
extension LinkedList: CustomStringConvertible {
    var description: String {
        var text = "LinkedList: ["
        var pointer = headNode
        while let node = pointer {
            text += String(node.data) + (node.next == nil ? "" : " -> ")
            pointer = node.next
        }
        text += "]"
        return text
    }
}
```   

调用  
```
var list = LinkedList(6)
print(list.description)
list.reversed()
print(list.description)
```

输出  
```
LinkedList: [0 -> 1 -> 2 -> 3 -> 4 -> 5]
LinkedList: [5 -> 4 -> 3 -> 2 -> 1 -> 0]
```


### 3. 有序数组的合并

![mergeList_01.png](https://i.loli.net/2020/06/17/hmTdXKL7PJC3jzs.png)  
![mergeList_02.png](https://i.loli.net/2020/06/17/SZca4jH8PXv75nT.png)  

有序数组的合并：实际上是归并排序算法的一种实现

代码
```
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
```

调用
```
let array1 = [1,4,6,7,9]
let array2 = [2,3,5,6,8,10,11,12]
print(mergeOrderedList(array1, array2))
```

输出  
```
[1, 2, 3, 4, 5, 6, 6, 7, 8, 9, 10, 11, 12]
```


### 4. hash算法：在一个字符串中找到第一个只出现一次的字符
 
比如：输入 **"gabaccdeff"** 则输出 **"g"**  

思路：
- 字符char是一个长度为8的数据类型，2的8次方=256，因此总共有256种可能。
- 每个字母根据其ASCII码值作为数组的下标对应数组的一个数字。
- 数组中存储的是每个字符出现的次数。

例如：给定值是a，对应的ASCII码值是97，数组索引下标为97。  
<!-- ![hash](./images/hash.png)     -->
![hash.png](https://i.loli.net/2020/06/17/wiH2pdBQj6oqJ3c.png)  
f(key) = key
**存储和查找都通过该函数，有效提高查找效率。**  

代码
```
func findFirstChar(str: String) -> String {
    
    var array: [Int] = []
    for _ in 0..<256 {
        array.append(0)
    }
    
    var number: UInt32 = 0
    for code in str.unicodeScalars {
        number = code.value // char -> ASCII code
        array[Int(number)] += 1
    }
    
    var char = ""
    for code in str.unicodeScalars {
        number = code.value
        if array[Int(number)]  == 1 {
            char = String(UnicodeScalar(number)!)
            break
        }
    }
    return char
}
``` 

调用
``` 
let str = "gabaccdeff"
findFirstChar(str: str)
```

输出  
```
g
```

**扩展：**  
在一个字符串中找到**按字母顺序**第一个只出现一次的字符  
比如：输入->gabaccdeff，则输出->b  

代码
```
func findFirstCharByLetterOrder(str: String) -> String {
    
    var array: [Int] = []
    for _ in 0..<256 {
        array.append(0)
    }
    
    var number: UInt32 = 0
    for code in str.unicodeScalars {
        number = code.value
        //            print("ASCII is \(number)")
        array[Int(number)] += 1
    }
    //        print("array: \(array)")
    
    var char = ""
    for i in 0..<array.count {
        if array[i] == 1 {
            char = String(UnicodeScalar(i)!)
            break
        }
    }
    
    return char
}
```
 
调用
```
let str = "gabaccdeff"
findFirstCharByLetterOrder(str: str)
```

输出
```
b
```

### 5. 查找两个子视图的共同父视图[※※※※※]

思路：分别记录两个子视图的所有父视图并保存到数组中，然后倒序寻找，直至找到第一个不一样的父视图。
![theSameSuperViews.png](https://i.loli.net/2020/06/17/kR6jn9FOmlh1N8Q.png)  

代码：
```
func findCommonSuperViews(view1: UIView, view2: UIView) -> [UIView] {
    var superViews: [UIView] = []
    let array1: [UIView] = findAllSuperViews(view: view1)
    let array2: [UIView] = findAllSuperViews(view: view2)
    let min = array1.count < array2.count ? array1.count : array2.count
    for i in 0..<min {
        let super1 = array1[array1.count - i - 1]
        let super2 = array2[array2.count - i - 1]
        if super1 == super2 {
            superViews.append(super1)
        } else {
            break
        }
    }
    return superViews
}

func findAllSuperViews(view: UIView) -> [UIView] {
    var superViews: [UIView] = []
    var curSuperView = view.superview
    while curSuperView != nil {
        superViews.append(curSuperView!)
        curSuperView = curSuperView?.superview
    }
    return superViews
}
```  

### 6. 求无序数组当中的中位数

思路：
- 排序算法 + 中位数
- 分治思想(快排思想)

#### 排序算法 + 中位数

<!-- ![排序算法+中位数](./images/排序算法+中位数.png)   -->
![排序算法_中位数.png](https://i.loli.net/2020/06/17/IfaR4BqQg21bzxW.png)  

#### 分治思想(快排思想)
选取关键字，高低交替扫描

- 任意挑一个元素，以该元素为支点，划分集合为两部分。  
- 如果左侧集合长度恰为(n-1)/2，那么支点恰为中位数。  
- 如果左侧长度<(n-1)/2，那么中位数在右侧；反之，中位数在左侧。  
- 进入相应的一侧继续寻找中位点。 

<!-- ![分治思想](./images/分治思想.png) -->
![分治思想.png](https://i.loli.net/2020/06/17/8M3sFIqe7CyHB4j.png)  

```
// 无序数组的中位数查找
int findMedian(int a[], int aLen) {
    int low = 0;
    int high = aLen - 1;
    
    int mid = (aLen - 1) / 2;
    int div = PartSort(a, low, high);
    
    while (div != mid) {
        if (mid < div) {
            // 左区间查找
            div = PartSort(a, low, div - 1);
        } else {
            // 右区间查找
            div = PartSort(a, div + 1, high);
        }
    }
    
    return a[mid];
}

int PartSort(int a[], int start, int end) {
    
    int low = start;
    int high = end;
    
    // 选取关键字
    int key = a[end];
    
    while (low < high) {
        // 左边查找比key大的值
        while (low < high && a[low] <= key) {
            ++low;
        }
        // 右边查找比key小的值
        while (low < high && a[high] >= key) {
            --high;
        }
        
        if (low < high) {
            // 找到之后交换左右的值
            int temp = a[low];
            a[low] = a[high];
            a[high] = temp;
        }
    }
    
    int temp = a[high];
    a[high] = a[end];
    a[end] = temp;
    
    return low;
}
```

具体调用并实现  
```
int list[9] = {12, 3, 10, 8, 6, 7, 11, 13, 9};
int median = findMedian(list, 9);
printf("the median is %d \n", median);
```

输出  
```
the median is 9  
```

[回到目录](#jump-4)  


### 7. 模拟栈操作
```
// 注解：利用协议申明了栈的属性和方法，并在结构体中声明数组stack，对数组数据进行append和popLast操作，完成入栈出栈操作，比较简单。
protocol Stack {
    // associatedtype：关联类型，相当于范型，在调用的时候可以根据associatedtype指定的Element来设置类型
    associatedtype Element
    // 判断栈是否为空
    var isEmpty: Bool { get }
    // 栈的大小
    var size: Int { get }
    // 栈顶元素
    var peek: Element? { get }
    // mutating：当需要在协议(结构体,枚举)的实例方法中，修改协议(结构体,枚举)的实例属性，需要用到mutating对实例方法进行修饰，不然会报错。
    // 进栈
    mutating func push(_ newElement: Element)
    // 出栈
    mutating func pop() -> Element?
}

// 模拟栈操作
struct IntegerStack: Stack {
    // typealias：类型别名，指定协议关联类型的具体类型，和associatedtype成对出现的
    typealias Element = Int
    private var stack = [Element]()
    // 判断栈是否为空
    var isEmpty: Bool { return stack.isEmpty }
    // 栈的大小
    var size: Int { return stack.count }
    // 取出stack栈顶元素
    var peek: Element? { return stack.last }
    // push 加入stack数组中
    mutating func push(_ newElement: Element) {
        return stack.append(newElement)
    }
    // pop 删除stack中最后一个元素
    mutating func pop() -> Element? {
        return stack.popLast()
    }
}

```

### 8. 折半查找(二分查找)

搜索过程从数组的中间元素开始，如果中间元素正好是要查找的元素，则搜索过程结束；
如果某一特定元素大于或者小于中间元素，则在数组大于或小于中间元素的那一半中查找，而且跟开始一样从中间元素开始比较。 
如果在某一步骤数组为空，则代表找不到。
这种搜索算法每一次比较都使搜索范围缩小一半。
 
优化查找时间（不用遍历全部数据）  
1.数组必须是有序的  
2.必须已知min和max（知道范围）  
3.动态计算mid的值，取出mid对应的值进行比较  
4.如果mid对应的值大于要查找的值，那么max要变小为mid-1  
5.如果mid对应的值小于要查找的值，那么min要变大为mid+1  

```
int findKey(int *arr, int length, int key) {
    int min = 0, max = length-1, mid;
    while (min <= max) {
        mid = (min + max) / 2;
        if (key > arr[mid]) {
            min = mid + 1;
        } else if (key < arr[mid]) {
            max = mid - 1;
        } else {
            return mid;
        }
    }
    return -1;
}
```

# 参考文档
《新浪微博资深大牛全方位剖析 iOS 高级面试》  
[数据结构 & 算法 in Swift （一）：Swift基础和数据结构](https://juejin.im/post/5a7096fa6fb9a01cb64f163b)  
[数据结构 & 算法 in Swift （二）：算法概述和排序算法](https://juejin.im/post/5a7b4101f265da4e7071b097)  
[《iOS面试之道》算法基础学习(上)](https://juejin.im/post/5b9b811c5188255c971fc999)  
[《iOS面试之道》算法基础学习(下)](https://juejin.im/post/5b9b81676fb9a05cf22fe649)  
[iOS数据结构与算法面试题合集](https://juejin.im/post/5dd297616fb9a02023605c46)  
[iOS冒泡算法优化](https://juejin.im/post/5b9b819f6fb9a05d0c37be57)   
[iOS算法系列（二）- 八大排序算法](https://www.jianshu.com/p/b37e962a734e?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation)