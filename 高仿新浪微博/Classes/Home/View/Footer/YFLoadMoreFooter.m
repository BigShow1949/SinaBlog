//
//  YFLoadMoreFooter.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-30.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFLoadMoreFooter.h"

@implementation YFLoadMoreFooter

+ (instancetype)footer
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YFLoadMoreFooter" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    // 去除所有autoresizing设置
    self.autoresizingMask = UIViewAutoresizingNone;
}

@end
