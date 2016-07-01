//
//  YFStatusTool.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-11.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//  微博业务类, 专门用于处理与微博相关的业务
//  例如: 发送微博 / 获取微博

/*
 但凡发现很多业务都与某个东西有关, 就可以封装一个业务类, 专门用于处理和该东西相关的业务
 提供一个方法, 让外界传入处理业务必须的参数
 提供一个成功的回调和一个失败的回调
 创建一个请求模型和一个结果模型(面向对象)
 */

#import <Foundation/Foundation.h>
#import "YFStatusRequest.h"
#import "YFHomeStatusResult.h"

typedef void (^successBlock)(YFHomeStatusResult *result);
typedef void (^failureBlock)(NSError *error);

@interface YFStatusTool : NSObject

/**
 *  用于获取微博数据
 *
 *  @param request 请求参数模型
 *  @param success 成功的回调
 *  @param failure 失败的回调
 */
+ (void)statusWithParams:(YFStatusRequest *)request success:(successBlock)success failure:(failureBlock)failure;


@end
