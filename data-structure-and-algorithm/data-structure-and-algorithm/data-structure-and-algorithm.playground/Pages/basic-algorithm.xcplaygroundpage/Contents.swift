//: [Previous](@previous)
import Foundation
/*:
 ## 基础算法题
 ### 1. 计算从1到100数字的总和
 * 法1. 循环遍历逐步相加
 
 时间复杂度：O(n)
 */
func sum1(_ n: Int) -> Int {
    guard n > 0 else {
        return n
    }
    var sum = 0
    for i in 1...n {
        sum += i
    }
    return sum
}
sum1(100)
/*:
 * 法2. 递归求和
 
 时间复杂度：O(n)
 - 算法的时间复杂度是多少？ - O(n)
 - 递归会有什么缺点？ - 递归次数过多的时候会造成栈溢出，操作系统给应用程序分配的栈空间是有限的，每次函数调用都会分配一段栈空间， 当栈空间不够的时候，程序也有崩了。
 - 不用递归能否实现，复杂度能否降到O(1)？ - 等差数列求和 (n + 1) * n / 2
 */
func sum2(_ n: Int) -> Int {
    guard n > 0 else {
        return n
    }
    let sum = n
    return sum + sum2(sum - 1)
}
sum2(100)
/*:
 * 法3. 等差数列求和
 
 时间复杂度：O(1)
 */
func sum3(_ n: Int) -> Int {
    guard n > 0 else {
        return n
    }
    return (n + 1) * n / 2
    // 或者使用 >> 运算
    // return (n + 1) * n >> 1
}
sum3(100)
/*:
 ### 2. 给出一个整型数组和一个目标值，判断数组中是否有两个数之和等于目标值。
 时间复杂度：O(n)
 */
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
twoSumEqualTarget(nums: [2,7,11,15], 9)
/*:
 ### 3. 给出一个整型数组和目标值，且数组中有且仅有两个数之和等于目标值，求这两个数在数组中的index。
 巧妙的用到了字典的特性，用key表示数组的值，通过判断字典中是否含有目标值的key来取出索引。
 
 时间复杂度：O(n)
 */
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
getIndexAboutTwoSumEqualTarget(nums: [2,7,11,15], 9)
/*:
 ### 4. 实现阶乘n!的算法 3!= 3 * 2 * 1 = 6
 使用递归
 */
func factorial(_ n: Int) -> Int {
    return n < 2 ? 1: n * factorial(n-1)
}
factorial(3)
/*:
 ### 5. 不用中间变量，交换A和B的值
 * 方法0. Swift可以利用元组特性直接交换
 */
func swap(a: inout Int, b: inout Int) -> (Int, Int) {
    (a, b) = (b, a)
    return (a, b)
}
var x = 7, y = 17
swap(a: &x, b: &y)
/*:
 * 方法1. 中间变量
 */
func swap1(a: inout Int, b: inout Int) -> (Int, Int) {
    let temp = a
    a = b
    b = temp
    return (a, b)
}
swap1(a: &x, b: &y)
/*:
 * 方法2. 加法
 */
func swap2(a: inout Int, b: inout Int) -> (Int, Int) {
    a = a + b
    b = a - b
    a = a - b
    return (a, b)
}
swap2(a: &x, b: &y)
/*:
 * 方法3. 异或（相同为0，不同为1。可以理解为不进位加法）
 */
func swap3(a: inout Int, b: inout Int) -> (Int, Int) {
    a = a ^ b
    b = a ^ b
    a = a ^ b
    return (a, b)
}
swap3(a: &x, b: &y)
/*:
 ### 6. 最大公约数
 比如：20和4的最大公约数为4;18和27的最大公约数为9
 * 方法1. 直接遍历法
 */
func maxCommonDivisor1(a: Int, b: Int) -> Int {
    var max = 0
    for i in 1...b {
        if (a % i == 0 && b % i == 0) {
            max = i
        }
    }
    return max
}
/*:
 * 方法2. 辗转相除法：其中a为大数，b为小数
 */
func maxCommonDivisor2(a: inout Int, b: inout Int) -> Int {
    var r: Int
    while (a % b > 0) {
        r = a % b
        a = b
        b = r
    }
    return b
}
var xx = 18, yy = 27
print("origin: x = \(xx), y = \(yy)")
print(maxCommonDivisor1(a: xx, b: yy))
print(maxCommonDivisor2(a: &xx, b: &yy))
/*:
 ### 7. 最小公倍数
 公式：最小公倍数 = (a * b)/最大公约数
 * 方法1. 直接遍历法
 */
func minimumCommonMultiple1(a: Int, b: Int) -> Int {
    var max = 0
    for i in 1...b {
        if (a % i == 0 && b % i == 0) {
            max = i
        }
    }
    return (a * b) / max
}
/*:
 * 方法2. 辗转相除法：其中a为大数，b为小数
 */
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
var xxx = 18, yyy = 27
print("origin: x = \(xxx), y = \(yyy)")
print(minimumCommonMultiple1(a: xxx, b: yyy))
print(minimumCommonMultiple2(a: &xxx, b: &yyy))
/*:
 ### 8. 判断质数
 质数：只能被1和自身整除的数
 
 比如：2、3、5、7、11、13、19等
 
 思路：直接判断，一个个除，看余数是否为零，如果不为零，则是质数。
 */
// 法1.
func isPrime(_ n: Int) -> Bool {
    for i in 2...n - 1 {
        if n % i == 0 {
            return false
        }
    }
    return true
}
// 法2.
func isPrime2(_ n: Int) -> Bool {
    for i in 2...Int(sqrt(Double(n))) { // sqrt(n) 返回n的平方根 比如sqrt(100.0) = 10
        if (n % i == 0) {
            return false
        }
    }
    return true
}
print("15 isPrime : \(isPrime(15))")
print("17 isPrime : \(isPrime2(17))")

// MARK: - 9. 是否是丑数
// 丑数：一个数的因子只包含2，3，5的数
// 数字1也看作是丑数，所以从1开始的10个丑数分别为1，2，3，4，5，6，8，9，10，12。
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


// MARK: - 10. 是否是2的幂
func isPowerOfTwo(_ n: inout Int) -> Bool {
    if n > 1 {
        while n%2 == 0 {
            n = n/2
        }
    }
    return n == 1
}

// MARK: - 11. 是否是3的幂
func isPowerOfThree(_ n: inout Int) -> Bool {
    if n > 1 {
        while n%3 == 0 {
            n = n/3
        }
    }
    return n == 1
}

// MARK: - 12. 质数的个数
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

// MARK: - 13. 数组中是否包含重复的元素
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


// MARK: - 14. 数组中出现次数超过数组长度一半的元素
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


// MARK: - 15. 数组中只出现过一次的元素
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


// MARK: - 16. 寻找数组中缺失的数字

// Given an array containing n distinct numbers taken from 0, 1, 2, ..., n, find the one that is missing from the array.
func missingNumber(nums: [Int]) -> Int {
    var result = (nums.count + 1) * nums.count / 2
    for num in nums {
        result -= num
    }
    //        var missingNum: [Int] = []
    return result
}


// MARK: - 17. 移除数组中等于某个值的元素
func removeElement(nums: inout [Int], targetNum: Int) {
    for num in nums {
        if num == targetNum {
            nums.remove(at: num)
        }
    }
}


//// MARK: - 数组中第k大的元素
//func findKthLargest(nums: [Int], k: Int) -> Int {
//        var sortNums = nums
//        sortNums = SortAlgorithm.bubbleSortAdvancedSuper(&sortNums)
//        print(sortNums)
//        let count = sortNums.count
//        return sortNums[count - k]
//    }
//}
//
//// MARK: - 出现频率最高的第k个元素
//func topKFrequent() {
//        
//    
//}

//: [Next](@next)
