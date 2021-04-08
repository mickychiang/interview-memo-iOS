//: [Previous](@previous)

// MARK: - hash算法：在一个字符串中找到第一个只出现一次的字符
// 比如：输入->gabaccdeff，则输出->g
// 思路：
// - 字符char是一个长度为8的数据类型，2的8次方=256，因此总共有256种可能。
// - 每个字母根据其ASCII码值作为数组的下标对应数组的一个数字。
// - 数组中存储的是每个字符出现的次数。
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

// MARK: - hash算法：在一个字符串中找到**按字母顺序**第一个只出现一次的字符
// 比如：输入->gabaccdeff，则输出->b
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

let str = "gabaccdeff"
findFirstChar(str: str)
findFirstCharByLetterOrder(str: str)

//: [Next](@next)
