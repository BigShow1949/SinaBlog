//
//  YFHttpFileManager.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-2.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFHttpFileManager : NSObject
- (void)appendFileData:(NSData *)data name:(NSString *)name filename:(NSString *)filename mimeType:(NSString *)mimeType;

- (NSArray *)files;
@end
