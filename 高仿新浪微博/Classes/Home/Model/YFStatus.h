//
//  YFStatus.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-29.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YFUser;
@interface YFStatus : NSObject
/** 字符串型的微博ID */
@property(nonatomic, copy) NSString *idstr;
/** 微博信息内容 */
@property (nonatomic, copy) NSString *text;

/** 微博带属性的字符串正文(专门用于记录处理之后的正文字符串) */
@property (nonatomic, copy) NSMutableAttributedString *attributedText;

/** 微博来源 */
@property (nonatomic, copy) NSString *source;

/** 微博创建时间 */
@property (nonatomic, copy) NSString *created_at;

/** 微博作者的用户信息字段 */
@property (nonatomic, strong) YFUser *user;

/** 微博配图 */
@property (nonatomic, strong) NSArray *pic_urls;

/**
 *  转发微博
 */
@property (nonatomic, strong) YFStatus *retweeted_status;
/** (专门用于记录处理之后的转发微博的正文字符串) */
@property (nonatomic, copy) NSMutableAttributedString *retweetedAttributedText;

/**
 *  赞数
 */
@property (nonatomic, strong) NSNumber *attitudes_count;
/**
 *  评论数
 */
@property (nonatomic, strong) NSNumber *comments_count;
/**
 *  转发数
 */
@property (nonatomic, strong) NSNumber *reposts_count;

//+ (instancetype)statusWithDict:(NSDictionary *)dict;
@end
