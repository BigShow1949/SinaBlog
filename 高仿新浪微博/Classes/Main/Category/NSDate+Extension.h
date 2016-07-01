//
//  NSDate+Extension.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-30.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/**
 *  计算toDate和self的时间差距
 */
- (NSDateComponents *)componentsToDate:(NSDate *)toDate;
/**
 *  是否为今年
 */
- (BOOL)isThisYear;
/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  是否为明天
 */
- (BOOL)isTomorrow;
/**
 *  将一个时间变为只有年月日的时间(时分秒都是0)
 */
- (NSDate *)ymd;

@end
