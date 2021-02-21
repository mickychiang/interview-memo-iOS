import Foundation


// --------------- 反转字符串 --------------------
// ----- ①反转字符：要求将其按照字符顺序进行反转。-----
// 举例："Hello World!" -> "!dlroW olleH"
// ---------------------------------------------

func reverseChars(_ str: String) -> String {
    
    // 将待反转字符串分割成字符数组
    var chars = Array(str)
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
    } // 或者 _reverse(&chars, start, end)
    
    return String(chars)
}

func reverseChars2(_ str: String) -> String {
    var chars = Array(str)
    let start = 0
    let end = chars.count - 1
    _reverse(&chars, start, end)
    return String(chars)
}

func reverseCharsByOS(_ str: String) -> String {
    return String(str.reversed()) // 系统提供的方法
}

// ----- ②反转单词：要求将其按照单词顺序进行反转。-----
// 举例："Hello World!" -> "World! Hello"
// ---------------------------------------------

// 思路：
/*
 1. 以输入字符串为"Hello World!"为例，首先将该字符串分割成一个个的小字符数组，然后反转成"!dlroW olleH"。
 2. 接着我们通过判断字符数组中的空格位和最后一位字符，对单一的单词进行分段反转，更新start位置。
 3. 最后输出我们需要的结果"World! Hello"
 */
func reverseWords1(_ str: String) -> String {
    
    // 将字符串str分割成字符数组
    var chars = Array(str)
    var start = 0
    let end = chars.count - 1
    // 反转chars字符数组
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
    // 接收字符串反转的起始和结束位置
    var start = start, end = end
    // 判断反转字符串的位置
    while start < end {
        // start、end位置的字符互换
        (chars[start], chars[end]) = (chars[end], chars[start]) // swap(&chars, start, end)
        // 往中间位置靠拢
        start += 1
        end -= 1
    }
}

// 将p、q字符的位置进行互换，这种写法也是swift里的一大亮点
func swap<T>(_ chars: inout[T], _ p: Int, _ q: Int) {
    (chars[p], chars[q]) = (chars[q], chars[p])
}

// 思路：根据" "分割成数组 -> 交换 i 和 count - i - 1 位置的元素 -> 最后拼接
func reverseWords2(_ str: String) -> String {
    var arr = str.components(separatedBy: " ")
    let count = arr.count
    for i in 0..<count / 2 {
        arr.swapAt(i, count - i - 1)
    }
    //        print("arr = \(arr)")
    var newStr = arr.reduce("") { (result, elem) -> String in
        result + " " + elem
    }
    //        print("newStr = \(newStr)")
    newStr.removeFirst() // 删除空格
    return newStr
}

func reverseWordsByOS(_ str: String) -> String {
    // 用空格划分字符串
    let chars = str.components(separatedBy: " ")
    // 将字符串数组进行反转，并通过空格重新组合
    // 系统提供的方法 不过时间复杂度过大
    let reserString = chars.reversed().joined(separator: " ")
    return reserString
}


// 反转字符
var str = "Hello World!"

//// ①反转字符串
//print(reverseChars(str))
//print(reverseChars2(str))
//print(reverseCharsByOS(str))
//
//// ②反转单词
//print(reverseWords1(str))
//print(reverseWords2(str))
//print(reverseWordsByOS(str))
