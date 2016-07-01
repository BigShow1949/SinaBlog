//
//  YFStatusTool.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-11.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFStatusTool.h"
#import "MJExtension.h"
#import "YFHttpTool.h"
#import "FMDB.h"
#import "YFStatus.h"
#import "YFAccount.h"
#import "YFAccountTool.h"

@implementation YFStatusTool

static FMDatabase *_db;
+ (void)initialize
{
    // 获取数据的文件路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqliteFilePath = [path stringByAppendingPathComponent:@"status.sqlite"];
    
    // 打开数据库
    _db = [FMDatabase databaseWithPath:sqliteFilePath];
    
    // 创建表
    if ([_db open]) {
        NSLog(@"打开数据库成功");
        // 在企业级开发中, 写sql语句最好先用图形工具编写测试之后拷贝到项目中
        NSString *sql = @"CREATE TABLE IF NOT EXISTS t_status  (id INTEGER PRIMARY KEY AUTOINCREMENT, idstr TEXT NOT NULL, dict BLOB NOT NULL, access_token TEXT NOT NULL);";
        ;
        if([_db executeUpdate:sql])
        {
            NSLog(@"创建表成功");
        }
    }
}

/**
 *  保存传入的微博对象
 *
 *  @param status 需要保存的微博对象
 *
 *  @return 是否保存成功
 */
+ (BOOL)saveCacheStatus:(NSDictionary  *)dict
{
    
    // 将字典转换为二进制
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted  error:NULL];
    // 获取access_token
    NSString *access_token = [YFAccountTool account].access_token;
    // 获取idstr
    NSString *idstr = dict[@"idstr"];
    
    // 存储微博数据
    BOOL success  = [_db executeUpdate:@"INSERT INTO t_status (idstr, dict, access_token) VALUES (?, ?, ?);", idstr, data , access_token];
    if (success) {
        NSLog(@"保存数据成功");
    }
    return YES;
}
/**
 *  根据请求模型查询缓存数据
 *
 *  @param request 请求模型
 *
 *  @return 缓存的微博数据
 */
+ (NSArray *)cacheStatusWithRequest:(YFStatusRequest *)request
{
    NSMutableArray *statuses = [NSMutableArray array];
    
    // 1.判断请求模型中有没有指定since_id和max_id, 根据指定情况从数据库中查询对应的数据返回
    FMResultSet *set = nil;
    if (request.since_id)
    {
        // 下拉刷新, 返回比since_id大的微博
        set = [_db executeQuery:@"SELECT * FROM t_status WHERE idstr > ? AND access_token = ? ORDER BY idstr DESC LIMIT ?", request.since_id , request.access_token, request.count];
    }else if (request.max_id)
    {
        // 上啦加载更多,返回小于或等于max_id的微博
        set = [_db executeQuery:@"SELECT * FROM t_status WHERE idstr <= ? AND access_token = ? ORDER BY idstr DESC LIMIT ?", request.max_id , request.access_token, request.count];
    }else
    {
        // 第一次启动, 返回前20条
        set = [_db executeQuery:@"SELECT * FROM t_status WHERE  access_token = ? ORDER BY idstr DESC LIMIT ?", request.access_token, request.count];
    }
    
    // 2.取出查询到的所有结果, 转换为对象存储到数组中返回
    while ([set next]) {
        // idstr, dict, access_token
        // 取出微博的idstr
        //        NSString *idstr = [set stringForColumn:@"idstr"];
        // 取出access_token
        //        NSString *access_token = [set stringForColumn:@"access_token"];
        // 取出微博二进制
        NSData *data = [set dataForColumn:@"dict"];
        // 先将二进制转换为字典
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        // 将字典转换为模型
        YFStatus *status = [YFStatus objectWithKeyValues:dict];
        
        // 将模型存储到数组中
        [statuses addObject:status];
    }
    
    return statuses;
}

+ (void)statusWithParams:(YFStatusRequest *)request success:(successBlock)success failure:(failureBlock)failure
{
    // 1.判断本地有没有数据
    // 从本地取出微博数据
    NSArray *statuses = [self cacheStatusWithRequest:request];
    if (statuses.count > 0) {
        // 从本地加载
        if (success) {
            YFHomeStatusResult *result = [[YFHomeStatusResult alloc] init];
            result.statuses = statuses;
            success(result);
        }
    }else
    {
        // 从网络加载
        // 2.发送一个GET请求
        [YFHttpTool get:@"https://api.weibo.com/2/statuses/home_timeline.json" params:request.keyValues
                success:^(id responseObject) {
                    
                    
                    // 存储微博数据到本地
                    for (NSDictionary *dict in responseObject[@"statuses"]) {
                        [self saveCacheStatus:dict];
                    }
                    
                    // 字典转模型
                    YFHomeStatusResult *result = [YFHomeStatusResult objectWithKeyValues:responseObject];
                    
                    
                    if (success) {
                        success(result);
                    }
                    
                } failure:^(NSError *error) {
                    if (failure) {
                        failure(error);
                    }
                }];
    }
}

@end
