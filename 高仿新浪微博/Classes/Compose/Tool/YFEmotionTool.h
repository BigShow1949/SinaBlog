//
//  YFEmotionTool.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-30.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YFEmotion;
@interface YFEmotionTool : NSObject
/**
 *  默认的表情数据(数组里面装的都是模型, HWEmotion)
 */
+ (NSArray *)defaultEmotions;
/**
 *  浪小花的表情数据(数组里面装的都是模型, HWEmotion)
 */
+ (NSArray *)lxhEmotions;
/**
 *  最近的表情数据(数组里面装的都是模型, HWEmotion)
 */
+ (NSArray *)recentEmotions;

/**
 *  保存最近使用的表情
 */
+ (void)addRecentEmotion:(YFEmotion *)emotion;
@end
