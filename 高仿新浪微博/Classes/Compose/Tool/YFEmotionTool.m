//
//  YFEmotionTool.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-30.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFEmotionTool.h"
#import "YFEmotion.h"
#import "MJExtension.h"

#define YFRecentFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recent_emotions.data"]

@implementation YFEmotionTool
static NSArray *_defaultEmotions;
static NSMutableArray *_recentEmotions;
static NSArray *_lxhEmotions;

/**
 *  默认的表情数据
 */
+ (NSArray *)defaultEmotions
{
    if (!_defaultEmotions) {
        // 方法1:
        /*
         NSString *file = [[NSBundle mainBundle] pathForResource:@"default/info.plist" ofType:nil];
         NSArray *dictArray = [NSArray arrayWithContentsOfFile:file];
         _defaultEmotions = [YFEmotion objectArrayWithKeyValuesArray:dictArray];
         */
        
        // 方法2:
        /*
         NSString *file = [[NSBundle mainBundle] pathForResource:@"default/info.plist" ofType:nil];
         _defaultEmotions = [YFEmotion objectArrayWithFile:file];
         */
        
        // 注意:仅仅限于mainBundle中的文件
        _defaultEmotions = [YFEmotion objectArrayWithFilename:@"default/info.plist"];
        
        // 让数组_defaultEmotions里的所有模型对象, 都调用setFolder:这个方法,并把"default"这个值传给他
        // 相当于emotion.folder = @"default";
        //        YFLog(@"%@----", _defaultEmotions);
        
        [_defaultEmotions makeObjectsPerformSelector:@selector(setFolder:) withObject:@"default"];
        
    }
    return _defaultEmotions;
}

/**
 *  最近的表情数据
 */
+ (NSArray *)recentEmotions
{
    if (!_recentEmotions) {
        _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:YFRecentFile];
        if (!_recentEmotions) {
            _recentEmotions = [NSMutableArray array];
        }
    }
    return _recentEmotions;
}

/**
 *  浪小花的表情数据
 */
+ (NSArray *)lxhEmotions
{
    if (!_lxhEmotions) {
        _lxhEmotions = [YFEmotion objectArrayWithFilename:@"lxh/info.plist"];
        [_lxhEmotions makeObjectsPerformSelector:@selector(setFolder:) withObject:@"lxh"];
    }
    return _lxhEmotions;
}

/**
 *  保存最近使用的表情
 */
+ (void)addRecentEmotion:(YFEmotion *)emotion
{
    // 加载之前的表情
    [self recentEmotions];
    
    // 删除之前的表情 比如:假如之前有个发怒的表情, 现在添加一个
    // 删除的不是同一个东西 在YFEmotion.m里修改方法
    [_recentEmotions removeObject:emotion];
//    for (YFEmotion *e in _recentEmotions) {
//        if ([e.chs isEqualToString:emotion.chs]) {
//            [_recentEmotions removeObject:e];
//            break;
//        }
//    }
    
    // 添加表情
    [_recentEmotions insertObject:emotion atIndex:0];
    
    // 删除超过一页的表情(只要一页,20个表情)
    if (_recentEmotions.count > YFEmotionPageSize) {
        [_recentEmotions removeObjectAtIndex:YFEmotionPageSize];
    }
    
    // 覆盖文件
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:YFRecentFile];
}

@end
