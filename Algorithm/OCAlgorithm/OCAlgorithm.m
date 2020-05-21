//
//  OCAlgorithm.m
//  Algorithm
//
//  Created by JXT on 2020/5/21.
//  Copyright © 2020 JXT. All rights reserved.
//
//
#import "OCAlgorithm.h"

@implementation OCAlgorithm

+ (void)test {
    NSLog(@"test");
}

// ********** 排序算法 **********
// 1. 选择排序
/*
 1.从待排序的元素中选出最小(或最大)的一个元素，存放在序列的起始位置。
 2.然后，再从剩余未排序元素中继续寻找最小(大)元素，然后放到已排序序列的末尾。
 3.以此类推，直到全部待排序的数据元素排完。
 第1趟：在n个数中找到最小(大)数与第一个数交换位置。
 第2趟：在剩下n-1个数中找到最小(大)数与第二个数交换位置。
 重复这样的操作...依次与第三个、第四个...数交换位置。
 第n-1趟：最终可实现数据的升序(降序)排列。
 */
// 实现一个升序排序
void selectSort(int *arr, int length) {
    for (int i = 0; i < length - 1; i++) {
        for (int j = i + 1; j < length; j++) {
            if (arr[i] > arr[j]) {
                int temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
            }
        }
    }
}

// 2. 冒泡排序
/*
 相邻元素两两比较，比较完一趟，最值出现在末尾。
 第1趟：依次比较相邻的两个数，不断交换(小数放前，大数放后)逐个推进，最值最后出现在第n个元素位置。
 第2趟：依次比较相邻的两个数，不断交换(小数放前，大数放后(逐个推进，最值最后出现在第n-1个元素位置。
 …… ……
 第n-1趟：依次比较相邻的两个数，不断交换(小数放前，大数放后)逐个推进，最值最后出现在第2个元素位置。
 */
void bublleSort(int *arr, int length) {
    for (int i = 0; i < length - 1; i++) {
        for (int j = 0; j < length - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}

// 3. 二分查找(折半查找)：是一种在有序数组中查找某一特定元素的搜索算法。
/*
 搜索过程从数组的中间元素开始，如果中间元素正好是要查找的元素，则搜索过程结束；
 如果某一特定元素大于或者小于中间元素，则在数组大于或小于中间元素的那一半中查找，而且跟开始一样从中间元素开始比较。
 如果在某一步骤数组为空，则代表找不到。
 这种搜索算法每一次比较都使搜索范围缩小一半。
 
 优化查找时间（不用遍历全部数据）
 1.数组必须是有序的
 2.必须已知min和max（知道范围）
 3.动态计算mid的值，取出mid对应的值进行比较
 4.如果mid对应的值大于要查找的值，那么max要变小为mid-1
 5.如果mid对应的值小于要查找的值，那么min要变大为mid+1
 */
int findKey(int *arr, int length, int key) {
    int min = 0, max = length-1, mid;
    while (min <= max) {
        mid = (min + max) / 2;
        if (key > arr[mid]) {
            min = mid + 1;
        } else if (key < arr[mid]) {
            max = mid - 1;
        } else {
            return mid;
        }
    }
    return -1;
}

// 4. 快速排序(分治法)
/*
 思想：通过一趟排序将要排序的数据分割成独立的两部分，其中一部分的所有数据都比另外一部分的所有数据都要小，
 然后再按此方法对这两部分数据分别进行快速排序，整个排序过程可以递归进行，以此达到整个数据变成有序序列。
 1.先从数列中取出一个数作为基准数。
 2.分区过程，将比这个数大的数全放到它的右边，小于或等于它的数全放到它的左边。
 3.再对左右区间重复第二步，直到各区间只有一个数。
 */
void quickSort(int s[], int l, int r) {
    if (l < r) {
        //Swap(s[l], s[(l + r) / 2]); //将中间的这个数和第一个数交换 参见注1
         int i = l, j = r, x = s[l];
        while (i < j) {
            while(i < j && s[j] >= x) // 从右向左找第一个小于x的数
                j--;
            if(i < j)
                s[i++] = s[j];
            
            while(i < j && s[i] < x) // 从左向右找第一个大于等于x的数
                i++;
            if(i < j)
                s[j--] = s[i];
        }
         s[i] = x;
         quickSort(s, l, i - 1); // 递归调用
         quickSort(s, i + 1, r);
    }
}

@end
