//
//  YFPhotosView.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-8.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFPhotosView : UIView

/**
 *  所有需要展示的配图
 */
@property (nonatomic, strong) NSArray *pic_urls;

/**
 *  根据配图的个数计算配图容器的宽高
 *
 *  @param count 配图的个数
 *
 *  @return 配图容器的宽高
 */
+ (CGSize)sizeWithPhotoCount:(NSUInteger)count;
@end
