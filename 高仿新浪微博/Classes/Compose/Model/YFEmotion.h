//
//  YFEmotion.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-30.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YFEmotion : NSObject<NSCoding>

/** png文件名 */
@property (nonatomic, copy) NSString *png;
/** 文字描述 */
@property (nonatomic, copy) NSString *chs;
/** 文件夹名  */
@property (nonatomic, copy) NSString *folder;

@end
