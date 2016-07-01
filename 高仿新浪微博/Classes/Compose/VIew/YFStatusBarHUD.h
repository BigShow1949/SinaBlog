//
//  YFStatusBarHUD.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-30.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFStatusBarHUD : NSObject
/**
 *  显示普通的信息
 */
+ (void)showMessage:(NSString *)msg image:(NSString *)image;
/**
 *  显示成功的信息
 */
+ (void)showSuccess:(NSString *)msg;
/**
 *  显示错误的信息
 */
+ (void)showError:(NSString *)msg;

/**
 *  显示正在加载的信息
 */
+ (void)showLoading:(NSString *)msg;
/**
 *  隐藏正在加载的信息
 */
+ (void)hideLoading;
@end
