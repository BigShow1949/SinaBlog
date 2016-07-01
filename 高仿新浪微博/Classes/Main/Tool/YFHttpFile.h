//
//  YFHttpFile.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-2.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFHttpFile : NSObject
/** 文件参数名 */
@property (nonatomic, copy) NSString *name;
/** 文件数据 */
@property (nonatomic, strong) NSData *data;
/** 文件类型 */
@property (nonatomic, copy) NSString *mimeType;
/** 文件名 */
@property (nonatomic, copy) NSString *filename;

+ (instancetype)fileWithName:(NSString *)name data:(NSData *)data mimeType:(NSString *)mimeType filename:(NSString *)filename;
@end
