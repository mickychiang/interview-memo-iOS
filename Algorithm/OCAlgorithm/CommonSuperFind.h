//
//  CommonSuperFind.h
//  OCAlgorithm
//
//  Created by MickyChiang on 2020/6/17.
//  Copyright © 2020 JXT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonSuperFind : NSObject

// 查找两个视图的共同父视图
- (NSArray<UIView *> *)findCommonSuperView:(UIView *)viewOne other:(UIView *)viewOther;

@end

NS_ASSUME_NONNULL_END
