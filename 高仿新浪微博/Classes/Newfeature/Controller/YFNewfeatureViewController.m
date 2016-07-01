//
//  YFNewfeatureViewController.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-6.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFNewfeatureViewController.h"
#import "YFTabBarController.h"

@interface YFNewfeatureViewController ()
- (IBAction)start:(id)sender;

@end

@implementation YFNewfeatureViewController


- (IBAction)start:(id)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[YFTabBarController alloc] init];
}
@end
