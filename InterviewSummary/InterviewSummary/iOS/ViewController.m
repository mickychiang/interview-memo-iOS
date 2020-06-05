//
//  ViewController.m
//  iOS
//
//  Created by JXT on 2017/12/20.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "ViewController.h"
#import "RuntimeObject.h"

@interface ViewController ()

@end

@implementation ViewController

- (void )viewDidLoad {
    [super viewDidLoad];
    
    RuntimeObject *obj = [[RuntimeObject alloc] init];
    // 调用test方法，只有声明，没有实现
    [obj test];
    
//    [obj method1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
