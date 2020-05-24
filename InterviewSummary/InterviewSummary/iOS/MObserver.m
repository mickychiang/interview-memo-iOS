//
//  MObserver.m
//  iOS
//
//  Created by MickyChiang on 2020/5/24.
//  Copyright © 2020 JXT. All rights reserved.
//

#import "MObserver.h"
#import "MObject.h"

@implementation MObserver

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass:[MObject class]] &&
        [keyPath isEqualToString:@"value"]) {
        // 获取value的新值
        NSNumber *valueNum = [change valueForKey:NSKeyValueChangeNewKey];
        NSLog(@"value is %@", valueNum);
    }
}

@end
