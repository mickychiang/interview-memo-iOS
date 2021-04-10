//
//  ViewController.m
//  BlockDemo
//
//  Created by JXT on 2020/6/20.
//  Copyright © 2020 JXT. All rights reserved.
//

#import "ViewController.h"
#import "MCBlock.h"

typedef int(^Friend)(int);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 基础部分
//    [self base];
//
//    [self methodA:^int(int friend) {
//        return 10;
//    }];
//
//    [self methodA2:^int(int friend) {
//        return 10;
//    }];
//
//    // Friend f = [self methodB];
//    NSLog(@"Block类型的变量作为返回值：%@", [self methodB]);
//    NSLog(@"Block类型的变量作为返回值：%@", [self methodB2]);
    
    // ***** *****
    [[[MCBlock alloc] init] method];
}

// Block 深入浅出 https://www.jianshu.com/p/157ee1dfedb2
- (void)base {
    // ***** Block表达式 *****
    // 语法格式：^返回值类型 (参数列表) {表达式}
    // 最简语法格式：^{表达式}
    ^int (int count) {
        return count + 1;
    };
    
    // 可省略的地方
    // 1. 返回类型
    ^(int count) {
        return count + 1;
    };
    
    // 2.参数列表为空，则可省略
    ^{
        NSLog(@"No Parameter");
    };
    
    // ***** Block类型的变量 *****
    // 语法格式：返回值类型 (^变量名)(参数列表) = Block表达式
    
    // 声明一个名为friend的Block类型的变量
    int (^friend)(int) = ^(int count) {
        return count + 1;
    };
    NSLog(@"声明一个名为friend的Block类型的变量：%d", friend(3)); // 4
    
    // Block类型的变量作为函数参数
    // Block类型的变量作为返回值
}

// Block类型的变量作为函数参数
- (void)methodA:(int(^)(int))friend {
    NSLog(@"Block类型的变量作为函数参数: %@", friend);
}

// 借助typedef可简写
- (void)methodA2:(Friend)friend {
    NSLog(@"Block类型的变量作为函数参数: %@", friend);
}

// Block类型的变量作为返回值
- (int (^)(int))methodB {
    return ^(int count) {
        return count ++;
    };
}

// 借助typedef可简写
- (Friend)methodB2 {
    return ^(int count) {
        return count ++;
    };
}

@end
