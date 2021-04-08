//: [Previous](@previous)

import Foundation

// --------------- 反转整数 ----------------
// ----------------------------------------
// 举例：给定一个16位有符号整数，要求将其反转后输出
// 1234 -> 4321
// 注意边界条件的判断
// ----------------------------------------

func reverseInteger(_ x: Int) -> Int {
    var i = 0
    var t = x
    // 支持正数和负数
    while t != 0 {
        i = 10 * i + t % 10
        t = t / 10
    }
    // 注意边界条件的判断
    if i < INT16_MIN || i > INT64_MAX {
        // 超出16位符号整型 输出0
        return 0
    }
    return i
}

// 反转整数
var x = 1234
print(reverseInteger(x))

//: [Next](@next)
