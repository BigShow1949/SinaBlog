//
//  YFComposeToolbar.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-1.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFComposeToolbar.h"

@interface YFComposeToolbar ()
@property (nonatomic, weak) UIButton *emotionButton;

@end

@implementation YFComposeToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        // 初始化按钮
        [self setupBtn:@"compose_camerabutton_background" highImage:@"compose_camerabutton_background_highlighted" type:YFComposeToolbarButtonTypeCamera];
        [self setupBtn:@"compose_toolbar_picture" highImage:@"compose_toolbar_picture_highlighted" type:YFComposeToolbarButtonTypePicture];
        [self setupBtn:@"compose_mentionbutton_background" highImage:@"compose_mentionbutton_background_highlighted" type:YFComposeToolbarButtonTypeMention];
        [self setupBtn:@"compose_trendbutton_background" highImage:@"compose_trendbutton_background_highlighted" type:YFComposeToolbarButtonTypeTrend];
        self.emotionButton = [self setupBtn:@"compose_emoticonbutton_background" highImage:@"compose_emoticonbutton_background_highlighted" type:YFComposeToolbarButtonTypeEmotion];
    }
    return self;
}

/**
 * 创建一个按钮
 */
- (UIButton *)setupBtn:(NSString *)image highImage:(NSString *)highImage type:(YFComposeToolbarButtonType)type
{
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = type;
//    btn.tag = self.subviews.count;// 还是得按顺序, 不好
    [self addSubview:btn];
    
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置所有按钮的frame
    NSUInteger count = self.subviews.count;
    CGFloat btnW = self.width / count;
    CGFloat btnH = self.height;
    for (NSUInteger i = 0; i<count; i++) {
        UIButton *btn = self.subviews[i];
        btn.y = 0;
        btn.width = btnW;
        btn.x = i * btnW;
        btn.height = btnH;
    }
}

- (void)switchEmotionButtonImage:(BOOL)isEmotionImage
{
    NSString *name = @"compose_keyboardbutton_background";
    NSString *highName = @"compose_keyboardbutton_background_highlighted";
    if (isEmotionImage) { // 切换为表情图片
        name = @"compose_emoticonbutton_background";
        highName = @"compose_emoticonbutton_background_highlighted";
    }
    [self.emotionButton setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [self.emotionButton setImage:[UIImage imageNamed:highName] forState:UIControlStateHighlighted];
}

- (void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(composeToolbar:didClickButton:)]) {
        [self.delegate composeToolbar:self didClickButton:(YFComposeToolbarButtonType)btn.tag];
    }
}

@end
