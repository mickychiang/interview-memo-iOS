//
//  AppDelegate.m
//  iOS
//
//  Created by JXT on 2017/12/20.
//  Copyright © 2017年 JXT. All rights reserved.
//

#import "AppDelegate.h"
#import "MObject.h"
#import "MObserver.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    MObject *obj = [[MObject alloc] init];
    MObserver *observer = [[MObserver alloc] init];
    // 调用KVO监听obj的value属性的变化
    [obj addObserver:observer forKeyPath:@"value" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    // 0.通过setter方法修改value
    obj.value = 1;
    
    // 1.通过KVC设置value，KVO能否生效？
    // 可以实现，可以触发KVO
    [obj setValue:@2 forKey:@"value"];
    // 为什么通过KVC设置value，KVO能生效？
    // KVC的实现机制和原理
    // 通过KVC调用，最终会调用到obj对象的setter方法，系统为我们重写了setter方法可以实现KVO。
    
    // 2.通过成员变量直接赋值value，KVO能否生效？
    // 不能生效，需要手动添加KVO的两个方法来实现KVO
    [obj increase];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
