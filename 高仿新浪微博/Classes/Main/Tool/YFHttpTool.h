//
//  YFHttpTool.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-2.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YFHttpFileManager.h"

@interface YFHttpTool : NSObject
/**
 *  文件上传
 *
 *  @param url     请求URL
 *  @param params  普通的请求参数
 *  @param files   文件参数(里面都是HWHttpFile模型)
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)post:(NSString *)url params:(id)params buildFile:(void (^)(YFHttpFileManager *manager))buildFile success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)post:(NSString *)url params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
+ (void)get:(NSString *)url params:(id)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
@end
