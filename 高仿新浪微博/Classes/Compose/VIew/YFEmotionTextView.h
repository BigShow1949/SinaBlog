//
//  YFEmotionTextView.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-1.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFTextView.h"
@class YFEmotion;
@interface YFEmotionTextView : YFTextView
/**
 * 将表情插入到当前光标的位置
 */
- (void)insertEmotion:(YFEmotion *)emotion;

/**
 * 返回带有表情描述的文字, 比如"[发红包]999[马到成功]"
 */
- (NSString *)emotionText;
@end
