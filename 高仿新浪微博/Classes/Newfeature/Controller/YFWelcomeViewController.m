//
//  YFWelcomeViewController.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-6.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFWelcomeViewController.h"
#import "YFAccount.h"
#import "YFAccountTool.h"
#import "YFTabBarController.h"
#import "UIImageView+WebCache.h"

@interface YFWelcomeViewController ()
/**
 *  头像Y的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconYConstraints;


/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/**
 *  欢迎文字
 */
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

@end

@implementation YFWelcomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 1.下载头像
    
    // 1.1获取帐号模型
    YFAccount *accout = [YFAccountTool account];
    NSURL *url = [NSURL URLWithString:accout.profile_image_url];
    // 1.2下载头像
    [self.iconImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatar_default_big"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //1.让头像执行动画
    [UIView animateWithDuration:0.5 animations:^{
        
        self.iconImageView.alpha = 1.0;
        self.iconYConstraints.constant += 200;
        
        [self.iconImageView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        //2.让文字执行动画
        [UIView animateWithDuration:0.5 animations:^{
            self.welcomeLabel.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            // 3.切换控制器到主页
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [[YFTabBarController alloc] init];
        }];
    }];
}

@end
