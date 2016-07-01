//
//  UIBarButtonItem+Extension.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-29.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)


/**
 *  通过一个按钮创建一个UIBarButtonItem
 *
 *  @param bg     背景图片
 *  @param highBg 高亮背景图片
 *  @param target 谁来监听按钮点击
 *  @param action 点击按钮会调用的方法
 */
+ (instancetype)itemWithBg:(NSString *)bg highBg:(NSString *)highBg target:(id)target action:(SEL)action;

@end
