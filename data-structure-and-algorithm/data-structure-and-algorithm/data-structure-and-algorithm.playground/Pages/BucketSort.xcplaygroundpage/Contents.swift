//: [Previous](@previous)

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
