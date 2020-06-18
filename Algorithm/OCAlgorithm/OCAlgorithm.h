//
//  OCAlgorithm.h
//  Algorithm
//
//  Created by JXT on 2020/5/21.
//  Copyright © 2020 JXT. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCAlgorithm : NSObject

+ (void)test;

+ (void)swap1A:(int)a andB:(int)b;
+ (void)swap2A:(int)a andB:(int)b;


// 不用中间变量，交换A和B的值
void swap1(int a, int b);
void swap2(int a, int b);
void swap3(int a, int b);

// 最大公约数
int maxCommonDivisor1(int a, int b);
int maxCommonDivisor2(int a, int b);

// 最小公倍数
int minimumCommonMultiple1(int a, int b);
int minimumCommonMultiple2(int a, int b);

// 反转字符串，要求将其按照字符顺序进行反转。
void reverseChars(char* cha);




void selectSort(int *arr, int length);
void bublleSort(int *arr, int length);

void mergeList(int a[], int aLen, int b[], int bLen, int result[]);

@end

NS_ASSUME_NONNULL_END
