//
//  ViewController.m
//  RuntimeDemo
//
//  Created by jiangxintong on 2018/11/11.
//  Copyright © 2018年 jiangxintong. All rights reserved.
//

#import "ViewController.h"
#import "UIControl+Limit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 测试代码：3秒内不可连续点击button
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100,100,100,40)];
    [btn setTitle:@"btnTest" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor]];
    btn.acceptEventInterval = 3;
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    // 测试代码：数组越界
    NSArray *array = @[@0, @1, @2, @3];
    [array objectAtIndex:3];
    // 本来要奔溃的
    [array objectAtIndex:4];
}

- (void)btnAction {
    NSLog(@"btnAction is executed");
}

@end
