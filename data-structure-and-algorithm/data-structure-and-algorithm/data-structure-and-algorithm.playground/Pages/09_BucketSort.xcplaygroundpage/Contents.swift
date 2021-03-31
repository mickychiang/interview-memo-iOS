//: [Previous](@previous)

/*:
 ## 桶排序（Bucket Sort）
 桶排序 是计数排序的升级版。它利用了函数的映射关系，高效与否的关键就在于这个映射函数的确定。

 桶排序 (Bucket sort)的工作的原理：
 假设输入数据服从均匀分布，将数据分到有限数量的桶里，每个桶再分别排序（有可能再使用别的排序算法或是以递归方式继续使用桶排序进行排
 
 算法描述
 步骤1：人为设置一个BucketSize，作为每个桶所能放置多少个不同数值（例如当BucketSize==5时，该桶可以存放｛1,2,3,4,5｝这几种数字，但是容量不限，即可以存放100个3）；
 步骤2：遍历输入数据，并且把数据一个一个放到对应的桶里去；
 步骤3：对每个不是空的桶进行排序，可以使用其它排序方法，也可以递归使用桶排序；
 步骤4：从不是空的桶里把排好序的数据拼接起来。

 注意，如果递归使用桶排序为各个桶排序，则当桶数量为1时要手动减小BucketSize增加下一循环桶的数量，否则会陷入死循环，导致内存溢出。

 算法分析
 桶排序最好情况下使用线性时间O(n)，
 桶排序的时间复杂度，取决与对各个桶之间数据进行排序的时间复杂度，因为其它部分的时间复杂度都为O(n)。
 很显然，桶划分的越小，各个桶之间的数据越少，排序所用的时间也会越少。但相应的空间消耗就会增大。

 最佳情况：T(n) = O(n+k)
 最差情况：T(n) = O(n+k)
 平均情况：T(n) = O(n^2)
 空间复杂度：O(n+k)
 
 稳定性：稳定
 */
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

let unsortedArray = [33, 51, 49, 24, 70, 4, 8, 0, 90]
print(bucketSort(unsortedArray))

//: [Next](@next)
