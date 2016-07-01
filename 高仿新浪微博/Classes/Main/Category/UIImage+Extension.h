//
//  UIImage+Extension.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-7.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  根据图片名称创建一张拉伸不变形的图片
 *
 *  @param imageName 图片名称
 *
 *  @return 拉伸不变形的图片
 */
+ (instancetype)resizableImageWithName:(NSString *)imageName;

/**
 *  根据图片名称创建一张拉伸不变形的图片
 *
 *  @param imageName  图片名称
 *  @param leftRatio  左边不拉伸比例
 *  @param rigthRatio 顶部不拉伸比例
 *
 *  @return 拉伸不变形的图片
 */
+ (instancetype)resizableImageWithName:(NSString *)imageName leftRatio:(CGFloat)leftRatio topRatio:(CGFloat)topRatio;

@end
