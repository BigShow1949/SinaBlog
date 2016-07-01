//
//  AppDelegate.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-29.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "AppDelegate.h"
#import "YFTabBarController.h"
#import "YFOAuthViewController.h"
#import "YFAccountTool.h"
#import "SDWebImageManager.h"
#import "UIWindow+Extension.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = YFScreenBounds;
    
    // 设置根控制器
    // 沙盒路径
    if ([YFAccountTool account]) {  // 授权过
        [self.window chooseRootviewController:YES];
    
    } else {  // 显示授权
        self.window.rootViewController = [[YFOAuthViewController alloc] init];
    }
    
    // 显示窗口
    [self.window makeKeyAndVisible];
    
    // 申请显示提醒数字的权限
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
    [application registerUserNotificationSettings:settings];
    
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 1.取消下载图片
    [[SDWebImageManager sharedManager] cancelAll];
    
    // 2.清除图片缓存(内存缓存)
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

// 开启后台任务, 并且为了不让它被关闭, 在plist中新增一个
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [application beginBackgroundTaskWithExpirationHandler:nil];
}



@end
