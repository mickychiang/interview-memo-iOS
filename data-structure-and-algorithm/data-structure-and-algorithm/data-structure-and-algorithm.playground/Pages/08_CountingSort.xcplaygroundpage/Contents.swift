//: [Previous](@previous)

/*:
 ## 计数排序（Counting Sort）
 计数排序 的核心在于将输入的数据值转化为键存储在额外开辟的数组空间中。
 作为一种线性时间复杂度的排序，计数排序要求输入的数据必须是有确定范围的整数。

 计数排序(Counting sort) 是一种稳定的排序算法。
 计数排序使用一个额外的数组C，其中第i个元素是待排序数组A中值等于i的元素的个数。
 然后根据数组C来将A中的元素排到正确的位置。它只能对整数进行排序。
 
 算法描述
 步骤1：找出待排序的数组中最大和最小的元素；
 步骤2：统计数组中每个值为i的元素出现的次数，存入数组C的第i项；
 步骤3：对所有的计数累加（从C中的第一个元素开始，每一项和前一项相加）；
 步骤4：反向填充目标数组：将每个元素i放在新数组的第C(i)项，每放一个元素就将C(i)减去1。

 算法分析
 当输入的元素是n 个0到k之间的整数时，它的运行时间是 O(n + k)。
 计数排序不是比较排序，排序的速度快于任何比较排序算法。
 由于用来计数的数组C的长度取决于待排序数组中数据的范围（等于待排序数组的最大值与最小值的差加上1），这使得计数排序对于数据范围很大的数组，需要大量时间和内存。

 最佳情况：T(n) = O(n+k)
 最差情况：T(n) = O(n+k)
 平均情况：T(n) = O(n+k)
 空间复杂度：O(n)
 
 稳定性：稳定
 */
//: [Next](@next)

/**
 * 计数排序
 *
 * @param array
 * @return
 */
// ??????
//func countingSort(_ original: [Int]) -> [Int] {
//    guard original.count > 1 else {
//        return original
//    }
//    var array = original
//    var bias, min = array[0], max = array[0]
//    for i in 1..<array.length {
//        if array[i] > max {
//            max = array[i]
//        }
//        if array[i] < min {
//            min = array[i]
//        }
//    }
//    bias = 0 - min
//    int[] bucket = new int[max - min + 1]
//    Arrays.fill(bucket, 0)
//    for (int i = 0; i < array.length; i++) {
//        bucket[array[i] + bias]++
//    }
//    int index = 0, i = 0
//    while (index < array.length) {
//        if (bucket[i] != 0) {
//            array[index] = i - bias
//            bucket[i]--
//            index++
//        } else
//            i++
//    }
//    return array
//}
//
//let unsortedArray = [33, 51, 49, 24, 70, 4, 8, 0, 90]
//print(countingSort(unsortedArray))
