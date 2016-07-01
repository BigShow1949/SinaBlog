//
//  YFEmotionPopView.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-1.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFEmotionButton;
@interface YFEmotionPopView : UIView
+ (instancetype)popView;

/**
 * 从某个表情按钮上面弹出
 */
- (void)popFromEmotionButton:(YFEmotionButton *)emotionButton;
@end
