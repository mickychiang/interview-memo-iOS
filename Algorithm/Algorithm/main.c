//
//  main.c
//  Algorithm
//
//  Created by JXT on 2020/5/21.
//  Copyright © 2020 JXT. All rights reserved.
//

#include <stdio.h>
#include <math.h>
// ********** 1. 交换A和B的值 **********
// 方法1. 中间变量
void swap1(int a, int b) {
    int temp = a;
    a = b;
    b = temp;
    printf("a = %d, b = %d \n", a, b);
}
// 方法2. 加法
void swap2(int a, int b) {
    a = a + b;
    b = a - b;
    a = a - b;
    printf("a = %d, b = %d \n", a, b);
}
// 方法3. 异或（相同为0，不同为1。可以理解为不进位加法）
void swap3(int a, int b) {
    a = a ^ b;
    b = a ^ b;
    a = a ^ b;
    printf("a = %d, b = %d \n", a, b);
}

// ********** 2. 最大公约数 **********
// 比如：20和4的最大公约数为4；18和27的最大公约数为9
// 方法1. 直接遍历法
int maxCommonDivisor1(int a, int b) {
    int max = 0;
    for (int i = 1; i <=b; i++) {
        if (a % i == 0 && b % i == 0) {
            max = i;
        }
    }
    return max;
}
// 方法2. 辗转相除法：其中a为大数，b为小数
int maxCommonDivisor2(int a, int b) {
    int r;
    while (a % b > 0) {
        r = a % b;
        a = b;
        b = r;
    }
    return b;
}

// ********** 3. 判断质数 **********
// 比如：2、3、5、7、11、13、19等只能被1和自身整除的数叫质数
// 直接判断：一个个除，看余数是否为零，如果不为零，则是质数。
int isPrime(int n) {
    for (int i = 2; i <= sqrt(n); i++) { // sqrt(n) 返回n的平方根 比如sqrt(100.0) = 10
        if (n % i == 0) {
            return 0;
        }
    }
    return 1;
}

// ********** 4. 字符串逆序输出 **********
char* reverse(char s[]) {
    // p指向字符串头部
    char *p = s;
    
    // q指向字符串尾部
    char *q = s;
    
    while('\0' != *q) {
        q++;
    }
    q--;
    
    // 交换并移动指针，直到p和q交叉
    while(q > p) {
        char t = *p;
        char m = *q;
        *p = m;
        *q = t;
        p++;
        q--;
    }
    
    return s;
}







int main(int argc, const char * argv[]) {
    // insert code here...
    printf("Hello, World!\n");
    // ********** 1. 交换A和B的值 **********
    swap1(2, 3);
    swap2(2, 3);
    swap3(2, 3);
    // ********** 2. 最大公约数 **********
    printf("98和63的最大公约数 = %d \n", maxCommonDivisor1(98, 63));
    printf("98和63的最大公约数 = %d \n", maxCommonDivisor2(98, 63));
    // ********** 3. 判断质数 **********
    printf("判断100是否为质数：%d \n", isPrime(100));
    printf("判断97是否为质数：%d \n", isPrime(97));
    // ********** 4. 字符串逆序输出 **********
//    printf("%c", reverse("Hello"));//?? crash!
    
    
    return 0;
}




