//
//  MCBlock.m
//  BlockDemo
//
//  Created by JXT on 2020/6/20.
//  Copyright © 2020 JXT. All rights reserved.
//

#import "MCBlock.h"

typedef int(^DemoBlock)(int num);

@interface MCBlock ()

@property (nonatomic, copy) DemoBlock blk;

@end

@implementation MCBlock

// 全局变量
int global_var = 4;

// 静态全局变量
static int static_global_var = 5;

//- (void)method {
//    // 基本数据类型的局部变量
//    int var = 1;
//
//    // 对象类型的局部变量
//    __unsafe_unretained id unsafe_obj = nil;
//    __strong id strong_obj = nil;
//
//    // 静态局部变量
//    static int static_var = 3;
//
//    void(^Block)(void) = ^{
//        NSLog(@"局部变量<基本数据类型> var = %d", var);
//
//        NSLog(@"局部变量<__unsafe_unretained 对象类型> var = %d", unsafe_obj);
//        NSLog(@"局部变量<__strong 对象类型> var = %d", strong_obj);
//
//        NSLog(@"静态局部变量 var = %d", static_var);
//
//        NSLog(@"全局变量 var = %d", global_var);
//        NSLog(@"静态全局变量 var = %d", static_global_var);
//    };
//
//    Block();
//}


//- (void)method {
//    int multiplier = 6;
//    int(^Block)(int) = ^int(int num) {
//        return num * multiplier;
//    };
//    multiplier = 4;
//    NSLog(@"result is %d", Block(2));
//}

//- (void)method {
//    static int multiplier = 6;
//    int(^Block)(int) = ^int(int num) {
//        return num * multiplier;
//    };
//    multiplier = 4;
//    NSLog(@"result is %d", Block(2));
//}

//- (void)method {
//    __block int multiplier = 6;
//    int(^Block)(int) = ^int(int num) {
//        return num * multiplier;
//    };
//    multiplier = 4;
//    NSLog(@"result is %d", Block(2));
//}



- (void)method {
    // 栈上创建的局部变量被__block修饰之后就会变成了一个对象。
    __block int multiplier = 10;
    // _blk是对象的成员变量，对它进行赋值操作的时候，实际上是对_blk的copy操作。
    // 在堆上产生一个一样的_blk副本。
    _blk = ^int(int num) {
        return num * multiplier; // multiplier 是堆上的变量。
    };
    // 不是对变量进行赋值，而是通过multiplier对象的__forwarding指针对其成员变量进行赋值。
    // 如果没有之前的_blk的copy操作，那么 multiplier = 6; 修改的是栈上的变量的值；
    // 如果之前对_blk进行了copy操作，那么 multiplier = 6; 修改的是堆上的副本变量的值。(栈上的变量的__forwarding指针会指向堆上的副本变量)
    multiplier = 6;
    [self executeBlock];
}

- (void)executeBlock {
    int result = _blk(4); // 调用了堆上的block
    NSLog(@"result is %d", result);
}

@end
