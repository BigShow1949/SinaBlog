//
//  YFAccountTool.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-29.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFAccount.h"

@interface YFAccountTool : NSObject

/**
 *  存储帐号信息
 */
+ (void)save:(YFAccount *)account;

/**
 *  获得上次存储的帐号
 *
 *  @return 帐号过期, 返回nil
 */
+ (YFAccount *)account;

@end
