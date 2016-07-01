//
//  YFHomeStatusResult.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-30.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFHomeStatusResult : NSObject

/** 这次请求返回的微博数据(里面存放的都是HWStatus模型) */
@property (nonatomic, strong) NSArray *statuses;

/** 微博总数 */
@property (nonatomic, assign) int total_number;

@end
