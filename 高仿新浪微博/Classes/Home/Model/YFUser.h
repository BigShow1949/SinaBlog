//
//  YFUser.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-29.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFUser : NSObject
/** 友好显示名称 */
@property (nonatomic, copy) NSString *name;
/** 用户头像地址（中图），50×50像素 */
@property (nonatomic, copy) NSString *profile_image_url;

@property (nonatomic, copy) NSString *gender;

/**
 *  会员等级
 */
@property (nonatomic, assign) int mbrank;
/**
 *  会员类型
 */
@property (nonatomic, assign) int mbtype;
/**
 *  判断是否是会员 , YES是会员
 */
@property (nonatomic, assign, getter=isVip) BOOL vip;
@end
