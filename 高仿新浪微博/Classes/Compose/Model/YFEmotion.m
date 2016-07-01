//
//  YFEmotion.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-30.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFEmotion.h"
#import "MJExtension.h"

@implementation YFEmotion

// 一行代码就等于下面注释部分
MJCodingImplementation

/**
 * 默认是比较内存地址  现在改为字符串的比较
 * 会在对比两个对象是否为同一个对象时调用
 * 返回YES: 代表self和other一样
 * 返回NO: 代表self和other不一样
 */
- (BOOL)isEqual:(YFEmotion *)other
{
    return [self.chs isEqualToString:other.chs];
}

///**
// *  从文件中解析对象的时候调用 : 在这个方法中说明对象的哪些属性需要取出来
// */
//- (id)initWithCoder:(NSCoder *)aDecoder{
//    
//    if (self = [super init]) {
//        self.chs = [aDecoder decodeObjectForKey:@"chs"];
//        self.png = [aDecoder decodeObjectForKey:@"png"];
//        self.folder = [aDecoder decodeObjectForKey:@"folder"];
//        
//    }
//    return self;
//}
//
///**
// *  将对象写入文件的时候调用 : 在这个方法中说明对象的哪些属性需要存储
// *
// *  @param aCoder <#aCoder description#>
// */
//- (void)encodeWithCoder:(NSCoder *)aCoder{
//    
//    [aCoder encodeObject:self.chs forKey:@"chs"];
//    [aCoder encodeObject:self.png forKey:@"png"];
//    [aCoder encodeObject:self.folder forKey:@"folder"];
//    
//}




@end
