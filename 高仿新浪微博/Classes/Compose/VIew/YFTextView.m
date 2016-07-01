//
//  YFTextView.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-30.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFTextView.h"

@interface YFTextView ()<UITextViewDelegate>

@end

@implementation YFTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

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
    // 不要设置代理为自己
    //    self.delegate = self;
    
    //    NSMutableString *string = [NSMutableString string];
    //    [string appendString:@"1"]; // 1
    //    [string appendString:@"2"]; // 12
    //    [string setString:@"4"]; // 4
    //    [string appendString:@"3"]; // 43
    
    // 规律
    // set方法 : 只能设置一个值, 只能保存一个值
    // add\append方法 : 能设置多个值, 能保存多个值
    
    // 文字发生改变,就调用[self setNeedsDisplay],刷新界面,重新调用drawRect:(CGRect)rect
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNeedsDisplay) name:UITextViewTextDidChangeNotification object:self];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setPlacehoder:(NSString *)placehoder
{
    _placehoder = [placehoder copy];
    
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    [self setNeedsDisplay];
}

// 通过代码改变文字, placeholder要变化, 但是那个代理方法只有手动触发
// 比如:输入一个表情, 占位文字没有消失
- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    if (self.hasText) return;
    
    // 文字属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    if (self.font) {
        attrs[NSFontAttributeName] = self.font;
    }

    // 画文字
    CGRect placehoderRect;
    placehoderRect.origin = CGPointMake(5, 7);
    CGFloat w = rect.size.width - 2 * placehoderRect.origin.x;
    CGFloat h = rect.size.height;
    placehoderRect.size = CGSizeMake(w, h);
    [self.placehoder drawInRect:placehoderRect withAttributes:attrs];
    //    [self.placehoder drawAtPoint:CGPointMake(5, 7) withAttributes:attrs];
}

@end
