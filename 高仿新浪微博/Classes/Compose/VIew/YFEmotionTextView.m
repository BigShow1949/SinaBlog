//
//  YFEmotionTextView.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-1.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFEmotionTextView.h"
#import "YFEmotion.h"
#import "YFEmotionAttachment.h"

@implementation YFEmotionTextView

/**
 * 将表情插入到当前光标的位置
 */
- (void)insertEmotion:(YFEmotion *)emotion
{
    // 生成一个带图片的属性文字
    YFEmotionAttachment *attachment = [[YFEmotionAttachment alloc] init];
    attachment.emotion = emotion;
    CGFloat imgWH = self.font.lineHeight;
    attachment.bounds = CGRectMake(0, -4, imgWH, imgWH);
    NSAttributedString *imageString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    // 生成属性文字
    NSUInteger oldLoc = self.selectedRange.location;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    [string appendAttributedString:self.attributedText];
    [string replaceCharactersInRange:self.selectedRange withAttributedString:imageString];
    
    // textView的font属性\textColor属性只对普通文字(text属性)有效
    // 如果想设置属性文字(attributedText)的字体\文字颜色等状态, 得通过addAttribute等方法添加状态
    [string addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, string.length)];
    
    // 一旦重新设置了文字,光标会自动定位到文字最后面
    self.attributedText = string;
    
    // 设置光标
    self.selectedRange = NSMakeRange(oldLoc + 1, 0);
}

/**
 * 返回带有表情描述的文字, 比如"[发红包]999[马到成功]"
 */
- (NSString *)emotionText
{
    NSMutableString *text = [NSMutableString string];
    // 遍历属性文字内部的所有属性
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        YFEmotionAttachment *attachment = attrs[@"NSAttachment"];
        if (attachment) {
            [text appendString:attachment.emotion.chs];
        } else {
            NSAttributedString *attributedString = [self.attributedText attributedSubstringFromRange:range];
            [text appendString:attributedString.string];
        }
    }];
    return text;
}


@end
