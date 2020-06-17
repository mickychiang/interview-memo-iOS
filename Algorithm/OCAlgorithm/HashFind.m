//
//  HashFind.m
//  OCAlgorithm
//
//  Created by MickyChiang on 2020/6/16.
//  Copyright © 2020 JXT. All rights reserved.
//

#import "HashFind.h"

@implementation HashFind

char findFirstChar(char* cha) {
    char result = '\0';
    
    // 定义一个数组，用来存储各个字母出现的次数
    // 字符char是一个长度为8的数据类型，2的8次方=256，因此总共有256种可能。
    int array[256];
    // 对数组进行初始化操作
    for (int i = 0; i < 256; i++) {
        array[i] = 0;
    }
    // 定义一个指针，指向当前字符串头部
    char* p = cha;
    // 遍历每个字符
    while (*p != '\0') {
        // 在字母对应的存储位置 进行出现次数+1操作
        array[*(p++)]++;
    }
    
    // 将p指针重新指向字符串头部
    p = cha;
    // 遍历每个字母的出现次数
    while (*p != '\0') {
        // 遇到第一个出现次数为1的字符，打印结果
        if (array[*p] == 1) {
            result = *p;
            break;
        }
        // 反之继续向后遍历
        p++;
    }
    
    return result;
}

//bug
//+ (NSString *)findFirstChar2:(NSArray *)chars {
//    NSString *result = @"";
//
//    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:256];
//    for (int i = 0; i < 256; i++) {
//        array[i] = @(0);
//    }
//
//    int p = 0;
//    while (p != '\0') {
//        id temp = [array objectAtIndex:p];
//        [array replaceObjectAtIndex:p withObject:@([temp intValue] + 1)];
//        p = p + 1;
//    }
//
//    p = 0;
//    while (p != '\0') {
//        if ([array[p] isEqual:@(1)]) {
//            result = [NSString stringWithFormat:@"%d", p];
//            break;
//        }
//        p++;
//    }
//
//    return result;
//}

@end
