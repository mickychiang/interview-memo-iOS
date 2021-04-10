//
//  MCBlock.m
//  BlockDemo
//
//  Created by JXT on 2020/6/20.
//  Copyright © 2020 JXT. All rights reserved.
//

#import "MCBlock.h"

@implementation MCBlock

// 全局变量
int global_var = 4;

// 静态全局变量
static int static_global_var = 5;

- (void)method {
    
    // 局部变量(基本数据类型)
    int var = 1;
    
    // 局部变量(对象类型)
    __unsafe_unretained id unsafe_obj = nil;
    __strong id strong_obj = nil;
    
    // 静态局部变量
    static int static_var = 3;
    
    // ***** Block特性：截获变量 *****
    void(^Block)(void) = ^{
        // 1.1 局部变量<基本数据类型>的截获：截获其值。
        NSLog(@"局部变量<基本数据类型> var = %d", var);
        // 1.2 局部变量<对象类型>的截获：连同所有权修饰符一起截获。
        NSLog(@"局部变量<__unsafe_unretained 对象类型> var = %d", unsafe_obj);
        NSLog(@"局部变量<__strong 对象类型> var = %d", strong_obj);
        // 2. 静态局部变量的截获：以指针形式截获。
        NSLog(@"静态局部变量 var = %d", static_var);
        // 3. 全局变量的截获：不截获。
        NSLog(@"全局变量 var = %d", global_var);
        // 4. 静态全局变量的截获：不截获。
        NSLog(@"静态全局变量 var = %d", static_global_var);
    };
    
    var = 11;
    unsafe_obj = [[NSObject alloc] init];
    strong_obj = [[NSObject alloc] init];
    static_var = 33;
    global_var = 44;
    static_global_var = 55;
    
    Block();
}

@end
