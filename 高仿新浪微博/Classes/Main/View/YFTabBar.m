//
//  YFTabBar.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-29.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFTabBar.h"
#import "YFComposeViewController.h"

@interface YFTabBar ()
/** 加号按钮 */
@property (nonatomic, weak) UIButton *plusButton;

@end

@implementation YFTabBar

/**
 * init方法内部会调用这个方法
 * 只有通过代码创建控件,才会执行这个方法
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

/**
 * 通过xib\storyboard创建控件时,才会执行这个方法
 */
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

/**
 * 初始化
 */
- (void)setup
{
    // 增加一个加号按钮
    UIButton *plusButton = [[UIButton alloc] init];
    [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button"] forState:UIControlStateNormal];
    [plusButton setBackgroundImage:[UIImage imageNamed:@"tabbar_compose_button_highlighted"] forState:UIControlStateHighlighted];
    [plusButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    [plusButton setImage:[UIImage imageNamed:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
    [plusButton addTarget:self action:@selector(plusClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:plusButton];
    self.plusButton = plusButton;
}

/**
 * 加号按钮点击
 */
- (void)plusClick
{
    // 弹出发微博控制器
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    YFComposeViewController *compose = [[YFComposeViewController alloc] init];
    [rootVc presentViewController:[[UINavigationController alloc] initWithRootViewController:compose] animated:YES completion:nil];}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /** 设置所有UITabBarButton的位置和尺寸 */
    // UITabBarButton的尺寸
    CGFloat buttonW = self.width / 5;
    CGFloat buttonH = self.height;
    
    // 按钮索引
    int buttonIndex = 0;
    
    // 设置所有UITabBarButton的frame
    for (UIView *child in self.subviews) {
        // 找到UITabBarButton
        if ([child isKindOfClass:[UIControl class]] && ![child isKindOfClass:[UIButton class]]) {
            CGFloat buttonX = buttonW * buttonIndex;
            child.frame = CGRectMake(buttonX, 0, buttonW, buttonH);
            
            // 增加索引
            buttonIndex++;
            if (buttonIndex == 2) {
                buttonIndex++;
            }
        }
    }
    
    /** 设置加号按钮的位置和尺寸 */
    self.plusButton.size = self.plusButton.currentBackgroundImage.size;
    self.plusButton.center = CGPointMake(self.width * 0.5, self.height * 0.5);
}


@end
