//
//  UIWindow+Extension.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-3.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "YFWelcomeViewController.h"
#import "YFNewfeatureViewController.h"
#import "YFTabBarController.h"

@implementation UIWindow (Extension)
- (void)chooseRootviewController:(BOOL)isWelcome
{
    // 判断应用显示新特性还是欢迎界面
    // 1.获取沙盒中的版本号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *key = @"CFBundleShortVersionString";
    NSString *sandboxVersion = [defaults objectForKey:key];
    
    // 2.获取软件当前的版本号
    NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
    NSString *currentVersion = dict[key];
    
    YFLog(@"sandboxVersion:%@, currentVersion:%@", sandboxVersion, currentVersion);
    
    // 3.比较沙盒中的版本号和软件当前的版本号
    if([currentVersion compare:sandboxVersion] == NSOrderedDescending)
    {
        // 显示新特性
        self.rootViewController = [[YFNewfeatureViewController alloc] init];
        
        // 存储软件当前的版本号
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
        
    }else {
        
        // 显示欢迎界面
        if(isWelcome)
        {
            
            self.rootViewController = [[YFWelcomeViewController alloc] init];
        }else
        {
            self.rootViewController = [[YFTabBarController alloc] init];
        }
    }
}
@end
