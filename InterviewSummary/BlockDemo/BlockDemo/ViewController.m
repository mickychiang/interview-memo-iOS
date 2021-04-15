//
//  ViewController.m
//  BlockDemo
//
//  Created by JXT on 2020/6/20.
//  Copyright © 2020 JXT. All rights reserved.
//

#import "ViewController.h"
#import "MCBlock.h"
#import "MMBlock.h"

typedef int(^Friend)(int);
typedef int(^DemoBlock)(int num);
typedef NSString*(^StrBlock)(NSString *str);

@interface ViewController ()

@property (nonatomic, copy) DemoBlock blk;

@property (nonatomic, copy) NSMutableArray *array;
@property (nonatomic, copy) StrBlock strBlk;

@property (nonatomic, assign) int var;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 基础部分
    [self base];

    [self methodA:^int(int friend) {
        return 10;
    }];

    [self methodA2:^int(int friend) {
        return 10;
    }];

    // Friend f = [self methodB];
    NSLog(@"Block类型的变量作为返回值：%@", [self methodB]);
    NSLog(@"Block类型的变量作为返回值：%@", [self methodB2]);

    // ***** *****
    [[[MMBlock alloc] init] methodA];
    [[[MMBlock alloc] init] methodB];
    [[[MMBlock alloc] init] methodC];

    [[[MMBlock alloc] init] method1];
    [[[MMBlock alloc] init] method2];

    [[[MMBlock alloc] init] method];
    [[[MMBlock alloc] init] methodd];

    // ***** *****
    [[[MCBlock alloc] init] method];
    
    
    
    
    // ************************* Block的循环引用 *************************
    [self demo1];
    [self demo1Change];
    _var = 2;
    [self demo2];
    [self demo2Change];
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

// ********************
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


// ************************* Block的循环引用 *************************
- (void)demo1 {
    _array = [NSMutableArray arrayWithObject:@"block"];
    _strBlk = ^NSString*(NSString *str) {
        // Capturing 'self' strongly in this block is likely to lead to a retain cycle
        return [NSString stringWithFormat:@"%@_%@", str, _array[0]];
    };
    _strBlk(@"hello");
}

- (void)demo1Change {
    _array = [NSMutableArray arrayWithObject:@"block"];
    __weak NSMutableArray *weakArray = _array;
    _strBlk = ^NSString*(NSString *str) {
        return [NSString stringWithFormat:@"%@_%@", str, weakArray[0]];
    };
    _strBlk(@"hello"); // hello_block
}

- (void)demo2 {
    __block ViewController *blockSelf = self;
    _blk = ^int(int num) {
        // var = 2
        return num * blockSelf.var;
    };
    _blk(3);
}

- (void)demo2Change {
    __block ViewController *blockSelf = self;
    _blk = ^int(int num) {
        // var = 2
        int result = num * blockSelf.var;
        blockSelf = nil;
        return result;
    };
    _blk(3);
}

@end
