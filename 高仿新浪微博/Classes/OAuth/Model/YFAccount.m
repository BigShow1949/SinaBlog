//
//  YFAccount.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-29.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFAccount.h"
#import "MJExtension.h"

@implementation YFAccount

+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    YFAccount *account = [[self alloc] init];
    account.access_token = dict[@"access_token"];
    account.expires_in = dict[@"expires_in"];
    account.uid = dict[@"uid"];
    account.profile_image_url = dict[@"profile_image_url"];
    
    // 计算过期时间
    NSDate *now = [NSDate date];
    account.expires_time = [now dateByAddingTimeInterval:[account.expires_in doubleValue]];
    return account;
}

// 一行代码等于下面注释部分
MJCodingImplementation

///**
// *  从文件中解析对象的时候调用 : 在这个方法中说明对象的哪些属性需要取出来
// */
//- (id)initWithCoder:(NSCoder *)decoder
//{
//    if (self = [super init]) {
//        self.access_token = [decoder decodeObjectForKey:@"access_token"];
//        self.uid = [decoder decodeObjectForKey:@"uid"];
//        self.expires_in = [decoder decodeObjectForKey:@"expires_in"];
//        self.expires_time = [decoder decodeObjectForKey:@"expires_time"];
//        self.name = [decoder decodeObjectForKey:@"name"];
//    }
//    return self;
//}
//
///**
// *  将对象写入文件的时候调用 : 在这个方法中说明对象的哪些属性需要存储
// */
//- (void)encodeWithCoder:(NSCoder *)encoder
//{
//    [encoder encodeObject:self.access_token forKey:@"access_token"];
//    [encoder encodeObject:self.uid forKey:@"uid"];
//    [encoder encodeObject:self.expires_in forKey:@"expires_in"];
//    [encoder encodeObject:self.expires_time forKey:@"expires_time"];
//    [encoder encodeObject:self.name forKey:@"name"];
//}

@end
