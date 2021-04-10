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

@end
