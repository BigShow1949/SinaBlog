//
//  YFStatusRequest.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-11.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFStatusRequest : NSObject

// 授权token
@property (nonatomic, copy) NSString *access_token;
// since_id
@property (nonatomic, strong) NSNumber *since_id;

@property (nonatomic, strong) NSNumber *max_id;

// 需要获取多少条微博数据
@property (nonatomic, strong) NSNumber *count;

@end
