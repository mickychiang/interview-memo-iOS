# iOS Algorithm

# 前言
此篇文章是对数据结构和算法的整理，根据日常知识的积累会不断的更新与完善。  
有理解不对的地方还请指正，互相学习。  
**重点理解排序算法和实战题，面试会经常提问**

# 目录

<span id="jump-1">[<h2>一. 算法基础</h2>](#1)</span>

<span id="jump-2">[<h2>二. 简单算法</h2>](#2)</span>
[1. 计算从1到100数字的总和](#2-1)  
[2. 给出一个整型数组和一个目标值，判断数组中是否有两个数之和等于目标值](#2-2)  
[3. 给出一个整型数组和目标值，且数组中有且仅有两个数之和等于目标值，求这两个数在数组中的index](#2-3)  
[4. 实现阶乘n!的算法 n！= n * (n-1) * ... * 1](#2-4)  
[5. 不用中间变量，交换A和B的值](#2-5)  
[6. 最大公约数](#2-6)  
[7. 最小公倍数](#2-7)  
[8. 判断质数](#2-8)  

<span id="jump-3">[<h2>三. 排序算法</h2>](#3)</span>
[1. 冒泡排序](#3-1)  
[2. 选择排序](#3-2)  
[3. 插入排序](#3-3)  
[4. 归并排序](#3-4)  
[5. 快速排序](#3-5)  
[6. 堆排序](#3-6)  
[7. 桶排序](#3-7)  
[8. 折半查找(二分查找)](#3-8)  


<span id="jump-4">[<h2>四. 实战</h2>](#4)</span>
[1. 反转字符串](#4-1)  
[2. 反转单链表[※※※※※]](#4-2)  
[3. 有序数组的合并](#4-3)  
[4. hash算法：在一个字符串中找到第一个只出现一次的字符](#4-4)  
[5. 查找两个子视图的共同父视图[※※※※※]](#4-5)   
[6. 求无序数组当中的中位数](#4-6)   
[7. 模拟栈操作](#4-7)   

# 正文
<h2 id="1">一. 算法基础</h2>

### 时间复杂度
算法的时间复杂度是指算法需要消耗的时间资源。  
一般来说，计算机算法是问题规模!n的函数f(n)，算法的时间复杂度也因此记做：  
<!-- ![时间复杂度公式](./images/TimeComplexity.png) -->
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

[回到目录](#jump-1)

<h2 id="2">二. 简单算法</h2>

<h3 id="2-1">1. 计算从1到100数字的总和</h3>

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
[回到目录](#jump-2)

<h3 id="2-2">2. 给出一个整型数组和一个目标值，判断数组中是否有两个数之和等于目标值</h3>

时间复杂度：O(n)
```
static func twoSumEqualTarget(nums: [Int], _ target: Int) -> Bool {
    // 初始化集合
    var set = Set<Int>()
    // 遍历整型数组
    for num in nums {
        // 判断集合中是否包含[目标值-当前值]的结果
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
[回到目录](#jump-2)

<h3 id="2-3">3. 给出一个整型数组和目标值，且数组中有且仅有两个数之和等于目标值，求这两个数在数组中的index</h3>

巧妙的用到了字典的特性，用key表示数组的值，通过判断字典中是否含有目标值的key来取出索引。  
时间复杂度：O(n)
```
static func twoSumEqualTarget(nums: [Int], _ target: Int) -> [Int] {
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
[回到目录](#jump-2)

<h3 id="2-4">4. 实现阶乘n!的算法 3！= 3 * 2 * 1 = 6</h3>

使用递归
```
static func factorial(_ n: Int) -> Int {
    return n < 2 ? 1: n * factorial(n-1)
}
```
[回到目录](#jump-2)

<h3 id="2-5">5. 不用中间变量，交换A和B的值</h3>

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

[回到目录](#jump-2)


<h3 id="2-6">6. 最大公约数</h3>

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

[回到目录](#jump-2)


<h3 id="2-7">7. 最小公倍数</h3>

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
[回到目录](#jump-2)

<h3 id="2-8">8. 判断质数</h3>

比如：2、3、5、7、11、13、19等只能被1和自身整除的数叫质数  
直接判断：一个个除，看余数是否为零，如果不为零，则是质数。
```
func isPrime(n: Int) -> Int {
    for i in 2...Int(sqrt(Double(n))) { // sqrt(n) 返回n的平方根 比如sqrt(100.0) = 10
        if (n % i == 0) {
            return 0
        }
    }
    return 1
}
```
[回到目录](#jump-2)


<h2 id="3">三. 排序算法</h2>

关于排序的介绍，常见的主要有7种：    
冒泡排序、选择排序、插入排序、归并排序、快速排序、堆排序、桶排序   
关于这7种排序算法的时间复杂度依次为：  
冒泡排序 = 选择排序 = 插入排序  >  归并排序 = 快速排序 = 堆排序 > 桶排序

>时间复杂度：在计算机科学中，算法的时间复杂度是一个函数，它定性描述了该算法的运行时间，通常用大O符号表示。

以下排序算法基于Swift语言的实现。

<h3 id="3-1">1. 冒泡排序</h3>

相邻元素两两比较，比较完一趟，最值出现在末尾。  
第1趟：依次比较相邻的两个数，不断交换(举例：小数放前，大数放后)逐个推进，最大值最后出现在第n个元素位置。  
第2趟：依次比较相邻的两个数，不断交换(举例：小数放前，大数放后)逐个推进，最大值最后出现在第n-1个元素位置。  
...  
第n-1趟：依次比较相邻的两个数，不断交换(举例：小数放前，大数放后)逐个推进，最大值最后出现在第2个元素位置。

时间复杂度-平均：O(n^2)  
时间复杂度-最优：O(n)  
时间复杂度-最差：O(n^2)  
稳定性：稳定  

#### 1.1 冒泡排序的基础写法
```
static func bubbleSort(_ array: inout [Int]) -> [Int] {
    guard array.count > 1 else {
        return array
    }
    for i in 0..<array.count - 1 {
        for j in 0..<array.count - 1 - i {
            if array[j] > array[j+1] {
                // let temp = array[j]
                // array[j] = array[j+1]
                // array[j+1] = temp
                // 或者
                array.swapAt(j, j+1)
            }
        }
    }
    return array
}
```
#### 1.2 冒泡排序的优化
设置一个布尔值的变量来标记“该数组是否有序”：
```
static func bubbleSortAdvanced(_ array: inout [Int]) -> [Int] {
    guard array.count > 1 else {
        return array
    }
    for i in 0..<array.count - 1 {
        var swapped = false
        for j in 0..<array.count - 1 - i {
            if array[j] > array[j+1] {
                array.swapAt(j, j+1)
                swapped = true
            }
        }
        // if there is no swapping in inner loop, it means the the part looped is already sorted,
        // so it's time to break
        if swapped == false {
            break
        }
    }
    return array
}
```
#### 1.3 冒泡排序的超级优化
对已经排好序的元素进行边界限定，来减少判断：
```
static func bubbleSortAdvancedSuper(_ array: inout [Int]) -> [Int] {
    guard array.count > 1 else {
        return array
    }
    var arrayBorder = array.count - 1
    for _ in 0..<array.count - 1 {
        var swapped = false
        for j in 0..<arrayBorder {
            if array[j] > array[j+1] {
                array.swapAt(j, j+1)
                swapped = true
                // 记录最后一次交换的位置
                arrayBorder = j
            }
        }
        if swapped == false {
            break
        }
    }
    return array
}
```
#### 1.4 冒泡排序的究极优化

鸡尾酒排序(定向冒泡排序)：是冒泡排序的一种变形，以双向在序列中进行排序。  
思想：  
将之前完整的一轮循环拆分为从左->右和从右->左两个子循环，这就保证了排序的双向进行，效率较单向循环来说更高。  
与此同时在这两个循环中加入了之前两个版本的特性isSorted和有序边界，使得排序更加高效。
```
static func bubbleSortAdvancedFinal(_ array: inout [Int]) -> [Int] {
    guard array.count > 1 else {
        return array
    }
    // 数组左边界
    var arrayLeftBorder = 0
    // 数组右边界
    var arrayRightBorder = array.count - 1
    for _ in 0..<array.count/2 {
        // 第一轮循环 左->右
        var swapped = false
        for j in arrayLeftBorder..<arrayRightBorder {
            if array[j] > array[j+1] {
                array.swapAt(j, j+1)
                swapped = true
                arrayRightBorder = j
            }
        }
        if swapped == false {
            break
        }
            
        // 第二轮循环 右->左
        swapped = false
        for j in (arrayLeftBorder+1...arrayRightBorder).reversed() {
            if array[j] < array[j-1] {
                array.swapAt(j, j-1)
                swapped = true
                arrayLeftBorder = j
            }
        }
        if swapped == false {
            break
        }
    }
    return array
}
```
[回到目录](#jump-3)

<h3 id="3-2">2. 选择排序</h3>

选择排序  
第1趟：在n个数中找到最小(大)数与第一个数交换位置。  
第2趟：在剩下n-1个数中找到最小(大)数与第二个数交换位置。  
...  
第n-1趟：最终可实现数据的升序(降序)排列。  

时间复杂度-平均：O(n^2)  
时间复杂度-最优：O(n^2)  
时间复杂度-最差：O(n^2)  
稳定性：不稳定  

```
static func selectSort(_ array: inout [Int]) -> [Int] {
    guard array.count > 1 else {
        return array
    }
    for i in 0..<array.count - 1 {
        var min = i
        for j in i + 1..<array.count {
            if array[j] < array[min] {
                min = j
            }
        }
        // if min has changed, it means there is value smaller than array[min]
        // if min has not changed, it means there is no value smallter than array[min]
        if i != min {
            array.swapAt(i, min)
        }
    }
    return array
}
```
[回到目录](#jump-3)

<h3 id="3-3">3. 插入排序</h3>

选择排序  
从数组中拿出一个元素（通常就是第一个元素）以后，再从数组中按顺序拿出其他元素。  
如果拿出来的这个元素比这个元素小，就放在这个元素左侧；反之，则放在右侧。  

时间复杂度-平均：O(n^2)  
时间复杂度-最优：O(n)  
时间复杂度-最差：O(n^2)  
稳定性：稳定  

```
static func insertSort(_ array: inout [Int]) -> [Int] {
    guard array.count > 1 else {
        return array
    }
    for i in 1..<array.count {
        var j = i
        while j > 0 && array[j] < array[j-1] {
            array.swapAt(j-1, j)
            j -= 1
        }
    }
    return array
}
```
[回到目录](#jump-3)

<h3 id="3-4">4. 归并排序</h3>

<!-- ![归并排序](./images/mergeSort.png) -->
![mergeSort.png](https://i.loli.net/2020/05/24/5bljd7ZYVyCDXvF.png)

归并操作(采用分治思想)是建立在归并操作的排序算法，是将需要排序的序列进行拆分，拆分成每一个单一元素。  
这时再按每个元素进行比较排序，两两合并，生成新的有序序列。再对新的有序序列进行两两合并操作，直到整个序列有序。  
     
归并操作的实现步骤是：  
新建空数组，初始化两个传入数组的index为0  
两两比较两个数组index上的值，较小的放在新建数组里面并且index+1。  
最后检查是否有剩余元素，如果有则添加到新建数组里面。  

时间复杂度-平均：O(nlogn)  
时间复杂度-最优：O(nlogn)  
时间复杂度-最差：O(nlogn)  
稳定性：稳定

```
static func mergeSort(_ array: [Int]) -> [Int] {
    guard array.count > 1 else {
        return array
    }
    let middleIndex = array.count/2
    // recursively split left part of original array
    let leftArray = mergeSort(Array(array[0..<middleIndex]))
    // recursively split right part of original array
    let rightArray = mergeSort(Array(array[middleIndex..<array.count]))
    // merge left part and right part
    return _merge(leftPile: leftArray, rightPile: rightArray)
}

static func _merge(leftPile: [Int], rightPile: [Int]) -> [Int] {
    // left pile index, start from 0
    var leftIndex = 0
    // right pile index, start from 0
    var rightIndex = 0
    // sorted pile, empty in the first place
    var sortedPile = [Int]()
        
    while leftIndex < leftPile.count && rightIndex < rightPile.count {
        // append the smaller value into sortedPile
        if leftPile[leftIndex] < rightPile[rightIndex] {
            sortedPile.append(leftPile[leftIndex])
            leftIndex += 1
        } else if leftPile[leftIndex] > rightPile[rightIndex] {
            sortedPile.append(rightPile[rightIndex])
            rightIndex += 1
        } else {
            // same value, append both of them and move the corresponding index
            sortedPile.append(leftPile[leftIndex])
            leftIndex += 1
            sortedPile.append(rightPile[rightIndex])
            rightIndex += 1
        }
    }
    // left pile is not empty
    while leftIndex < leftPile.count {
        sortedPile.append(leftPile[leftIndex])
        leftIndex += 1
    }
    // right pile is not empty
    while rightIndex < rightPile.count {
        sortedPile.append(rightPile[rightIndex])
        rightIndex += 1
    }
    return sortedPile
}
```
[回到目录](#jump-3)

<h3 id="3-5">5. 快速排序</h3>

快速排序是一种高效的排序方法，它利用了归并排序的思想，
将需要排列的数组拆分成每一小部分，然后让每一小部分进行排序、合并，最后得到完整的排序序列。

时间复杂度-平均：O(nlogn)  
时间复杂度-最优：O(nlogn)  
时间复杂度-最差：O(n^2)  
稳定性：不稳定

```
static func quickSort(_ array: [Int]) -> [Int] {
    guard array.count > 1 else {
        return array
    }
    // 取出数组中间下标元素
    let pivot = array[array.count/2]
    // 用到了函数式方法filter，过滤元素
    let left = array.filter{ $0 < pivot }
    let middle = array.filter{ $0 == pivot }
    let right = array.filter{ $0 > pivot }
    // 递归 对新数组进行合并
    return quickSort(left) + middle + quickSort(right)
}
```
[回到目录](#jump-3)

<h3 id="3-6">6. 堆排序</h3>

堆排序：  
利用堆这种数据结构而设计的一种排序算法，是选择排序的一种。  
通过调整堆结构，将堆的顶部元素（即数组第0位元素）与末尾的元素进行交换，调整后将末尾元素固定，  
然后继续调整新的堆结构，每次调整固定一个元素，遍历结束后从而达到排序的效果。  

时间复杂度-平均：O(nlogn)  
时间复杂度-最优：O(nlogn)  
时间复杂度-最差：O(nlogn)  
稳定性：不稳定

```
static func heapSort(_ array: inout [Int]) -> [Int] {
    // 构建大顶堆 从最后一个非叶子结点倒序遍历
    for i in (0...(array.count/2-1)).reversed() {
        // 从第一个非叶子结点从下至上，从右至左调整结构
        adjustHeap(&array, i: i, length: array.count)
    }
    // 上面已将输入数组调整成堆结构
    for j in (1...(array.count - 1)).reversed() {
        // 堆顶元素与末尾元素进行交换
        array.swapAt(0, j)
        adjustHeap(&array, i:0, length:j)
    }
    return array
}

static func adjustHeap(_ array: inout [Int], i: Int, length: Int) {
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
}
```
[回到目录](#jump-3)

<h3 id="3-7">7. 桶排序</h3>

桶排序：  
将数组分到n个相同的大小的子区间，每个子区间就是一个桶，然后将输入数组中的元素一一对应，放入对应子区间内的桶中。  
最后遍历每个桶，依次输入每个桶中对应装的数据即可。  
因为桶的顺序是有序的，所以只要从第一个桶开始遍历，得到的结果也就是有序的数组。  

```
static func bucketSort(_ array: inout [Int]) -> [Int] {
    guard array.count > 1 else {
        return array
    }
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
[回到目录](#jump-3)

<h3 id="3-8">8. 折半查找(二分查找)</h3>

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

[回到目录](#jump-3)

### 代码完整实例请参照：[Algorithm工程](https://github.com/mickychiang/iOSInterviewMemo/blob/master/Algorithm)



<h2 id="4">四. 实战</h2>

<h3 id="4-1">1. 反转字符串</h3>

反转字符串，要求将其按照字符顺序进行反转。举例："Hello World" -> "dlroW olleH"  
```
func reverseString(s: String) -> String {
        
    // 将待反转字符串分割成字符数组
    var chars = Array(s)
    // 初始化指向第一个字符的索引值
    var start = 0
    // 初始化指向最后一个字符的索引值
    var end = chars.count - 1
        
    // 判断反转字符串的位置
    while start < end {
        // start、end位置的字符互换
        (chars[start], chars[end]) = (chars[end], chars[start])
        // 前、后索引值 往中间位置靠拢
        start += 1
        end -= 1
    }
        
    return String(chars)
}
```

[回到目录](#jump-4)

<h3 id="4-2">2. 反转单链表[※※※※※]</h3>

<!-- ![reverseList.png](./images/reverseList.png)
![reverseList-HeadInsertion.png](./images/reverseList-HeadInsertion.png)   -->
![reverseList.png](https://i.loli.net/2020/06/17/YoqdtV8iDOXTHmB.png)  
![reverseList-HeadInsertion.png](https://i.loli.net/2020/06/17/YZAX9LeVd3aNxbR.png)  

ReverseList.h
<!-- ![ReverseList.h.png](./images/ReverseList.h.png) -->
![ReverseList.h.png](https://i.loli.net/2020/06/18/N8OVaxMvKltn7Zh.png)

ReverseList.m
<!-- ![ReverseList.m_01.png](./images/ReverseList.m_01.png)
![ReverseList.m_02.png](./images/ReverseList.m_02.png) -->
<!-- ![ReverseList.m_03.png](./images/ReverseList.m_03.png) -->
![ReverseList.m_01.png](https://i.loli.net/2020/06/18/duT8wXCLcmQF71W.png)  
![ReverseList.m_02.png](https://i.loli.net/2020/06/18/Gd3aX1i6s2BwJWo.png)  
![ReverseList.m_03.png](https://i.loli.net/2020/06/18/RX6WwYyTPumrV8f.png)

具体调用并实现
```
printf("-----单链表反转-----\n");
struct Node *head = constructList();
printList(head);
printf("----------\n");
struct Node *newHead = reverseList(head);
printList(newHead);
```

输出
```
-----单链表反转-----
node is 0 
node is 1 
node is 2 
node is 3 
node is 4 
----------
node is 4 
node is 3 
node is 2 
node is 1 
node is 0 
```

[回到目录](#jump-4)


<h3 id="4-3">3. 有序数组的合并</h3>

<!-- ![mergeList_01.png](./images/mergeList_01.png)
![mergeList_02.png](./images/mergeList_02.png)   -->
![mergeList_01.png](https://i.loli.net/2020/06/17/hmTdXKL7PJC3jzs.png)  
![mergeList_02.png](https://i.loli.net/2020/06/17/SZca4jH8PXv75nT.png)  

```
// MARK: - 有序数组的合并
// 将有序数组a和b的值合并到一个数组result当中，且仍然保持有序。
func mergeOrderedList(arrayA: [Int], arrayB: [Int]) -> [Int] {
        
    var result: [Int] = []
    // 遍历数组a的指针、遍历数组b的指针、记录当前存储位置
    var p = 0, q = 0, i = 0
        
    // 任一数组没有到达边界 则进行遍历
    while p < arrayA.count && q < arrayB.count {
        // 如果数组a对应位置的值小于数组b对应位置的值
        if arrayA[p] <= arrayB[q] {
            // 存储数组a的值
            result.insert(arrayA[p], at: i)
            // 移动数组a的遍历指针
            p += 1
        } else {
            // 存储数组b的值
            result.insert(arrayB[q], at: i)
            // 移动数组b的遍历指针
            q += 1
        }
        // 指向合并结果的下一个存储位置
        i += 1
    }
        
    // 如果数组a有剩余
    while p < arrayA.count {
        // 将数组a剩余的部分拼接到合并结果的后面
        result.insert(arrayA[p], at: i)
        p += 1
        i += 1
    }        
    // 如果数组b有剩余
    while q < arrayB.count {
        // 将数组b剩余的部分拼接到合并结果的后面
        result.insert(arrayB[q], at: i)
        q += 1
        i += 1
    }
        
    return result
}
```

具体调用并实现

```
print("有序数组的合并")
print(mergeOrderedList(arrayA: [1,4,6,7,9], arrayB: [2,3,5,6,8,10,11,12]))
```

输出
```
有序数组的合并
[1, 2, 3, 4, 5, 6, 6, 7, 8, 9, 10, 11, 12]
```

[回到目录](#jump-4)


<h3 id="4-4">4. hash算法：在一个字符串中找到第一个只出现一次的字符</h3>
 
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

<!-- ![findFirstChar_01.png](./images/findFirstChar_01.png) -->
![findFirstChar_01.png](https://i.loli.net/2020/06/19/6NZOmSfeg7Wbu2B.png)  

具体调用并实现 
``` 
print("hash算法：在一个字符串中找到第一个只出现一次的字符")
print("this char is \(findFirstChar(str: "gabaccdeff"))")
print("---------------")
```

输出  
```
hash算法：在一个字符串中找到第一个只出现一次的字符
this char is g
---------------
```

**扩展：**  
在一个字符串中找到**按字母顺序**第一个只出现一次的字符  
比如：输入->gabaccdeff，则输出->b  
<!-- ![findFirstChar_02.png](./images/findFirstChar_02.png)   -->  
![findFirstChar_02.png](https://i.loli.net/2020/06/19/EU42yevZXH7zpD8.png)  

```
print("hash算法：在一个字符串中找到**按字母顺序**第一个只出现一次的字符")
print("this char is \(findFirstChar2(str: "gabaccdeff"))")
print("---------------")
```
```
hash算法：在一个字符串中找到**按字母顺序**第一个只出现一次的字符
this char is b
---------------
```

[回到目录](#jump-4)


<h3 id="4-5">5. 查找两个子视图的共同父视图[※※※※※]</h3>

思路：分别记录两个子视图的所有父视图并保存到数组中，然后倒序寻找，直至找到第一个不一样的父视图。
<!-- ![theSameSuperViews.png](./images/theSameSuperViews.png) -->
![theSameSuperViews.png](https://i.loli.net/2020/06/17/kR6jn9FOmlh1N8Q.png)  

代码示例：  
<!-- ![CommonSuperFind.png](./images/CommonSuperFind.png)   -->
![CommonSuperFind.png](https://i.loli.net/2020/06/18/Pr6M5bfFqXoyUJG.png)  

[回到目录](#jump-4)


<h3 id="4-6">6. 求无序数组当中的中位数</h3>

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


<h3 id="4-7">7. 模拟栈操作</h3>

![Stack.png](./images/Stack.png)

[回到目录](#jump-4)


# 参考文档

[数据结构 & 算法 in Swift （一）：Swift基础和数据结构](https://juejin.im/post/5a7096fa6fb9a01cb64f163b)  
[数据结构 & 算法 in Swift （二）：算法概述和排序算法](https://juejin.im/post/5a7b4101f265da4e7071b097)  
[《iOS面试之道》算法基础学习(上)](https://juejin.im/post/5b9b811c5188255c971fc999)  
[《iOS面试之道》算法基础学习(下)](https://juejin.im/post/5b9b81676fb9a05cf22fe649)  
[iOS数据结构与算法面试题合集](https://juejin.im/post/5dd297616fb9a02023605c46)  
[iOS冒泡算法优化](https://juejin.im/post/5b9b819f6fb9a05d0c37be57)


# 其他
《iOS面试题备忘录》系列文章的github原文地址：  

[iOS面试题备忘录(一) - 属性关键字](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/PropertyModifier.md)    
[iOS面试题备忘录(二) - 内存管理](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/memoryManagement.md)   
[iOS面试题备忘录(三) - 分类和扩展](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/CategoryAndExtension.md)  
[iOS面试题备忘录(四) - 代理和通知](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/DelegateAndNSNotification.md)  
[iOS面试题备忘录(五) - KVO和KVC](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/KVOAndKVC.md)  
[iOS面试题备忘录(六) - runtime](https://github.com/mickychiang/iOSInterviewMemo/blob/master/InterviewSummary/runtime.md)  
[算法](https://github.com/mickychiang/iOSInterviewMemo/blob/master/Algorithm/Algorithm.md)   