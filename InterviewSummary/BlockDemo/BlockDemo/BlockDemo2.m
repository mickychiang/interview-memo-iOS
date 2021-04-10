//
//  BlockDemo2.m
//  BlockDemo
//
//  Created by MickyChiang on 2021/4/10.
//  Copyright © 2021 JXT. All rights reserved.
//

#import "BlockDemo2.h"

@implementation BlockDemo2

- (void)method {
    __block int count = 10;
    void (^blk)(void) = ^(){
        count = 20;
        NSLog(@"In Block: %d", count); //打印：In Block: 20
    };
    count ++;
    NSLog(@"Out Block: %d", count); //打印：Out Block: 11
    blk();
}

@end
