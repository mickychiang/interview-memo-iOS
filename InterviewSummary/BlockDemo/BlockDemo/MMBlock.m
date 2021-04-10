//
//  MMBlock.m
//  BlockDemo
//
//  Created by MickyChiang on 2021/4/10.
//  Copyright © 2021 JXT. All rights reserved.
//

#import "MMBlock.h"

@implementation MMBlock

- (void)methodA {
    int multiplier = 6;
    int(^Block)(int) = ^int(int num) {
        return num * multiplier;
    };
    multiplier = 4;
    NSLog(@"result is %d", Block(2)); // 12
}

- (void)methodB {
    static int multiplier = 6;
    int(^Block)(int) = ^int(int num) {
        return num * multiplier;
    };
    multiplier = 4;
    NSLog(@"result is %d", Block(2)); // 8
}

- (void)methodC {
    __block int multiplier = 6;
    int(^Block)(int) = ^int(int num) {
        return num * multiplier;
    };
    multiplier = 4;
    NSLog(@"result is %d", Block(2)); // 8
}

- (void)method1 {
    NSMutableArray *array = [NSMutableArray array];
    void (^Block)(void) = ^{
        [array addObject:@123];
    };
    Block();
    NSLog(@"array is %@", array); // (123)
}

- (void)method2 {
    __block NSMutableArray *array = nil;
    void (^Block)(void) = ^{
        array = [NSMutableArray array]; // 不加 __block 发生：Variable is not assignable (missing __block type specifier)
    };
    Block();
    NSLog(@"array is %@", array); // ()
}

void (^Block)(void) = ^{
    NSLog(@"Global Block");
};

- (void)method {
    Block();
    NSLog(@"%@",[Block class]); // 打印：__NSGlobalBlock__
    
    // 像上面代码块中的全局Block自然是存储在全局数据区
    // 但注意：以下 在函数栈上创建的blk，如果没有截获自动变量，Block的结构实例还是会被设置在程序的全局数据区，而非栈上
    
    void (^blk)(void) = ^{ // 没有截获自动变量的Block
        NSLog(@"Stack Block");
    };
    blk();
    NSLog(@"%@",[blk class]); // 打印：__NSGlobalBlock__
    
    int i = 1;
    void (^captureBlk)(void) = ^{ // 截获自动变量i的Block
        NSLog(@"Capture:%d", i);
    };
    captureBlk();
    NSLog(@"%@",[captureBlk class]); // 打印：__NSMallocBlock__
    
    // 可以看到：
    // 没有截获自动变量的Block 打印的类是NSGlobalBlock，表示存储在全局数据区。
    // 捕获自动变量的Block 打印的类却是设置在堆上的NSMallocBlock，而非栈上的NSStackBlock。
}

- (void)methodd {
    int count = 0;
    void (^blk)(void) = ^(){
        NSLog(@"In Stack:%d", count);
    };
    
    NSLog(@"blk's Class:%@", [blk class]); // 打印：blk's Class:__NSMallocBlock__
    NSLog(@"Global Block: %@", [^{NSLog(@"Global Block");} class]); // 打印：Global Block: __NSGlobalBlock__
    NSLog(@"Copy Block: %@", [[^{NSLog(@"Copy Block:%d",count);} copy] class]); // 打印：Copy Block: __NSMallocBlock__
    NSLog(@"Stack Block: %@", [^{NSLog(@"Stack Block:%d",count);} class]); // 打印：Stack Block: __NSStackBlock__
}

@end
