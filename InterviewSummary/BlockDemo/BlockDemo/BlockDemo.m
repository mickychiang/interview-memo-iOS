//
//  BlockDemo.m
//  BlockDemo
//
//  Created by MickyChiang on 2021/4/10.
//  Copyright © 2021 JXT. All rights reserved.
//

#import "BlockDemo.h"

@implementation BlockDemo

- (void)method {
    int count = 6;
    int (^blockName)(int) = ^int(int num) {
        return num * count;
    };
    blockName(2);
}

@end
