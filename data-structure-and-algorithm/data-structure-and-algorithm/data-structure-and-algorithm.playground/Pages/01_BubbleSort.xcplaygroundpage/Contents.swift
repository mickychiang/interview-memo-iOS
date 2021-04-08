//: [Previous](@previous)

/*:
 （数据结构）十分钟搞定时间复杂度（算法的时间复杂度）
 https://www.jianshu.com/p/f4cca5ce055a
 
 https://blog.csdn.net/weixin_41190227/article/details/86600821
 
 不用中间变量交换两个变量的值：

 1、加减法：该方法可以交换整型和浮点型数值的变量，但在处理浮点型的时候有可能出现精度的损失。

 a = a + b;
 b = a - b;
 a = a - b;

 2、异或法：可以完成对整型变量的交换，对于浮点型变量它无法完成交换。

 a = a^b;

 b = a^b;

 a = a^b;

 3、乘除法：可以处理整型和浮点型变量，但在处理浮点型变量时也存在精度损失问题。而且乘除法比加减法要多一条约束：b必不为0。

 a = a * b
 b = a / b
 a = a / b

 其中加减，乘除容易越界，用位运算异或效率最高，且不会越界。

 使用位运算交换两个数，是利用了异或的自反性： a^b^b=a^0=a;
 */

/*:
 ## 冒泡排序（Bubble Sort）
 冒泡排序 是一种简单的排序算法。
 它重复地走访过要排序的数列，一次比较两个元素，如果它们的顺序错误就把它们交换过来。
 走访数列的工作是重复地进行直到没有再需要交换，也就是说该数列已经排序完成。
 这个算法的名字由来是因为越小的元素会经由交换慢慢“浮”到数列的顶端。

 算法描述
 步骤1: 比较相邻的元素。如果第一个比第二个大，就交换它们两个；
 步骤2: 对每一对相邻元素作同样的工作，从开始第一对到结尾的最后一对，这样在最后的元素应该会是最大的数；
 步骤3: 针对所有的元素重复以上的步骤，除了最后一个；
 步骤4: 重复步骤1~3，直到排序完成。

 算法分析
 最佳情况：T(n) = O(n)
 最差情况：T(n) = O(n^2)
 平均情况：T(n) = O(n^2)
 空间复杂度：O(1)
 
 稳定性：稳定
 */
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
            }
        }
    }
    return array
}

let unsortedArray = [33, 51, 49, 24, 70, 4, 8, 0, 90]
print(bubbleSort(unsortedArray))







// 冒泡排序的优化
// 1. 设置一个布尔值的变量来标记“该数组是否有序”
func bubbleSortAdvanced(_ original: [Int]) -> [Int] {
    guard original.count > 1 else {
        return original
    }
    var array = original
    for i in 0..<array.count - 1 {
        var swapped = false
        for j in 0..<array.count - 1 - i {
            if array[j] > array[j+1] {
                // 元祖替换
                // (array[j], array[j + 1]) = (array[j + 1], array[j])
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

print(bubbleSortAdvanced(unsortedArray))


// 2. 对已经排好序的元素进行边界限定，来减少判断
func bubbleSortAdvancedSuper(_ original: [Int]) -> [Int] {
    guard original.count > 1 else {
        return original
    }
    var array = original
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
print(bubbleSortAdvancedSuper(unsortedArray))


// 3. 鸡尾酒排序(定向冒泡排序)：是冒泡排序的一种变形，以双向在序列中进行排序。
// 思想：
// 将之前完整的一轮循环拆分为从左->右和从右->左两个子循环，这就保证了排序的双向进行，效率较单向循环来说更高。
// 与此同时在这两个循环中加入了之前两个版本的特性isSorted和有序边界，使得排序更加高效。
func bubbleSortAdvancedFinal(_ original: [Int]) -> [Int] {
    guard original.count > 1 else {
        return original
    }
    var array = original
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

print(bubbleSortAdvancedFinal(unsortedArray))

//: [Next](@next)
