//
//  YFEmotionPopView.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-1.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFEmotionPopView.h"
#import "YFEmotionButton.h"

@interface YFEmotionPopView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation YFEmotionPopView

+ (instancetype)popView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YFEmotionPopView" owner:nil options:nil] firstObject];
}

/**
 * 从某个表情按钮上面弹出
 */
- (void)popFromEmotionButton:(YFEmotionButton *)emotionButton
{
    // 显示图片
    self.iconView.image = emotionButton.currentImage;
    
    // 在按钮上面显示一个放大镜
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    // 让放大镜在表情按钮的上面
//    CGRect buttonRect = [window convertRect:emotionButton.bounds fromView:emotionButton];
    CGRect buttonRect = [window convertRect:emotionButton.frame fromView:emotionButton.superview];
    
    self.centerX = CGRectGetMidX(buttonRect);
    self.y = CGRectGetMidY(buttonRect) - self.height;
}

@end
