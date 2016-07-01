//
//  YFEmotionButton.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-30.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFEmotionButton.h"
#import "YFEmotion.h"

@implementation YFEmotionButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 只对image有效, 对background没有效果, 如果要取消background的高亮,重写setHighlighted:
        self.adjustsImageWhenHighlighted = NO;
    }
    return self;
}

- (void)setEmotion:(YFEmotion *)emotion
{
    _emotion = emotion;
    
    NSString *name = [NSString stringWithFormat:@"%@/%@", emotion.folder, emotion.png];
    [self setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
}


@end
