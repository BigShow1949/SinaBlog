//
//  YFStatusFrame.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-6.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

// 间隙
#define YFCellMargin 10
#define YFCellNameFont [UIFont systemFontOfSize:16]
#define YFCellTimeFont  [UIFont systemFontOfSize:13]
#define YFCellSourceFont    YFCellTimeFont
#define YFCellContentFont   [UIFont systemFontOfSize:16]

#import <Foundation/Foundation.h>

@class YFStatus;
@interface YFStatusFrame : NSObject

/**
 *  数据模型
 */
@property (nonatomic, strong) YFStatus *status;

/** 顶部容器 */
@property (nonatomic, assign, readonly) CGRect topViewF;
/***********************华丽的分割线****************************/
/** 原创微博 */
@property (nonatomic, assign, readonly) CGRect orginalViewF;
/** 头像 */
@property (nonatomic, assign, readonly) CGRect iconViewF;
/** 昵称 */
@property (nonatomic, assign, readonly) CGRect nameLabelF;
/** 会员图标 */
@property (nonatomic, assign, readonly) CGRect vipViewF;
/** 时间 */
@property (nonatomic, assign, readonly) CGRect timeLabelF;
/** 来源 */
@property (nonatomic, assign, readonly) CGRect sourceLabelF;
/** 正文\内容 */
@property (nonatomic, assign, readonly) CGRect contentLabelF;

/** 配图容器 */
@property (nonatomic, assign, readonly) CGRect photosViewF;
/***********************华丽的分割线****************************/

/** 转发微博 */
@property (nonatomic, assign, readonly) CGRect retweetViewF;
/** 转发正文\内容 */
@property (nonatomic, assign, readonly) CGRect retweetContentLabelF;
/** 配图容器 */
@property (nonatomic, assign, readonly) CGRect retweetPhotosViewF;

/***********************华丽的分割线****************************/
/** 底部的工具条 */
@property (nonatomic, assign, readonly) CGRect bottomViewF;

/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
