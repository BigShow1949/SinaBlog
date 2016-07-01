//
//  YFHttpTool.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-2.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFHttpTool.h"
#import "AFNetworking.h"
#import "YFHttpFile.h"

@implementation YFHttpTool

+ (void)post:(NSString *)url params:(id)params buildFile:(void (^)(YFHttpFileManager *))buildFile success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    YFHttpFileManager *manager = nil;
    if (buildFile) {
        manager = [[YFHttpFileManager alloc] init];
        buildFile(manager);
    }
    
    // 1.创建一个请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送请求
    [mgr POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (YFHttpFile *file in manager.files) {
            [formData appendPartWithFileData:file.data name:file.name fileName:file.filename mimeType:file.mimeType];
        }
    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        [YFStatusBarHUD showSuccess:@"发布成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [YFStatusBarHUD showError:@"网络繁忙,请稍后再试"];
    }];
}

+ (void)post:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建一个请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送一个POST请求
    [mgr POST:url parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}

+ (void)get:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建一个请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送一个GET请求
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (success) {
             success(responseObject);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
}

@end
