//
//  YFEmotionAttachment.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-1.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFEmotionAttachment.h"
#import "YFEmotion.h"
@implementation YFEmotionAttachment

- (void)setEmotion:(YFEmotion *)emotion
{
    _emotion = emotion;
    
    NSString *name = [NSString stringWithFormat:@"%@/%@", emotion.folder, emotion.png];
    self.image = [UIImage imageNamed:name];
}
@end
