//
//  YFTextPart.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-11.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFTextPart : UIImageView

/**
 *  正文的一部分
 */
@property (nonatomic, copy) NSString *text;
/**
 *  当前文本所在的范围
 */
@property (nonatomic, assign)  NSRange range;
/**
 *  是否是特殊字符串
 */
@property (nonatomic, assign) BOOL specail;
/**
 *  是否是表情
 */
@property (nonatomic, assign) BOOL emotion;
@end
