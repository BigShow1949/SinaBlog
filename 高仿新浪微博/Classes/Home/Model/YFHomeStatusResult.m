//
//  YFHomeStatusResult.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-30.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFHomeStatusResult.h"
#import "YFStatus.h"
#import "MJExtension.h"

@implementation YFHomeStatusResult

- (NSDictionary *)objectClassInArray
{
    return @{@"statuses" : [YFStatus class]};
}
//+ (instancetype)resultWithDict:(NSDictionary *)dict
//{
//    YFHomeStatusResult *result = [[self alloc] init];
//    // 微博文字
//    result.text = dict[@"text"];
//    // 微博来源
//    status.source = dict[@"source"];
//    // 微博时间
//    status.created_at = dict[@"created_at"];
//    
//    // 微博用户
//    status.user = [YFUser userWithDict:dict[@"user"]];
//    
//    return status;
//}
@end
