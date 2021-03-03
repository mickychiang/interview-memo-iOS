//
//  ViewController.m
//  multi-thread
//
//  Created by jiangxintong on 2021/3/3.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self interview1];
}

- (void)interview1 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        NSLog(@"1---%@", [NSThread currentThread]);
        [self performSelector:@selector(printLog)
                   withObject:nil
                   afterDelay:0];
        [[NSRunLoop currentRunLoop] run];
        NSLog(@"3---%@", [NSThread currentThread]);
    });
}

- (void)printLog {
    NSLog(@"2---%@", [NSThread currentThread]);
}

@end
