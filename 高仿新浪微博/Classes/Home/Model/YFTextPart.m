//
//  YFTextPart.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-11.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFTextPart.h"

@implementation YFTextPart

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", self.text, NSStringFromRange(self.range)];
}

@end
