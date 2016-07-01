//
//  YFUser.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-29.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFUser.h"

@implementation YFUser

- (BOOL)isVip
{
    return self.mbtype > 2;
}

//+ (instancetype)userWithDict:(NSDictionary *)dict
//{
//    YFUser *user = [[self alloc] init];
//    // 名称
//    user.name = dict[@"name"];
//    // 头像
//    user.profile_image_url = dict[@"profile_image_url"];
//    return user;
//}
@end
