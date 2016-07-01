//
//  YFComposeToolbar.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-1.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    YFComposeToolbarButtonTypeCamera, // 拍照
    YFComposeToolbarButtonTypePicture, // 相册
    YFComposeToolbarButtonTypeMention, // @
    YFComposeToolbarButtonTypeTrend, // #
    YFComposeToolbarButtonTypeEmotion // 表情
} YFComposeToolbarButtonType;

@class YFComposeToolbar;

@protocol YFComposeToolbarDelegate <NSObject>


@optional
- (void)composeToolbar:(YFComposeToolbar *)composeToolbar didClickButton:(YFComposeToolbarButtonType)buttonType;
@end

@interface YFComposeToolbar : UIView
@property (nonatomic, weak) id<YFComposeToolbarDelegate> delegate;
- (void)switchEmotionButtonImage:(BOOL)isEmotionImage;

@end
