//
//  YFAccount.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-29.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFAccount : NSObject<NSCoding>

/** 用于调用access_token，接口获取授权后的access token */
@property (nonatomic, copy) NSString *access_token;
/** 当前授权用户的UID */
@property (nonatomic, copy) NSString *uid;
/** 当前授权用户的名字 */
@property (nonatomic, copy) NSString *name;
/** access_token的生命周期，单位是秒数 */
@property (nonatomic, copy) NSString *expires_in;
/** access_token的过期时间 */
@property (nonatomic, strong) NSDate *expires_time;
/**
 *  用户头像
 */
@property (nonatomic, strong) NSString *profile_image_url;
+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
