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

/// 查找两个子视图的共同父视图
- (NSArray<UIView *> *)findCommonSuperViewsForView1:(UIView *)view1 AndView2:(UIView *)view2;

@end

NS_ASSUME_NONNULL_END
