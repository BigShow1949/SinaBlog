//
//  YFAccountTool.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-29.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFAccountTool.h"

#define YFAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

@implementation YFAccountTool

/**
 *  存储帐号信息
 */
+ (void)save:(YFAccount *)account
{
      // 存储时间
    [NSKeyedArchiver archiveRootObject:account toFile:YFAccountPath];
}

/**
 *  获得上次存储的帐号
 *
 *  @return 帐号过期, 返回nil
 */
+ (YFAccount *)account
{
    YFAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:YFAccountPath];
    
    YFLog(@"YFAccountPath --- %@", YFAccountPath);
    /**
     NSOrderedAscending = -1L, 升序, 右边 > 左边
     NSOrderedSame,   相同大小
     NSOrderedDescending 降序, 右边 < 左边
     */
    if ([[NSDate date] compare:account.expires_time] != NSOrderedAscending) {
        return nil;
    }
    return account;
}

@end
