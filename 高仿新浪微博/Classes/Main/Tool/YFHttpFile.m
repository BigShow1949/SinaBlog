//
//  YFHttpFile.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-2.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFHttpFile.h"

@implementation YFHttpFile
+ (instancetype)fileWithName:(NSString *)name data:(NSData *)data mimeType:(NSString *)mimeType filename:(NSString *)filename
{
    YFHttpFile *file = [[self alloc] init];
    file.name = name;
    file.data = data;
    file.mimeType = mimeType;
    file.filename = filename;
    return file;
}
@end
