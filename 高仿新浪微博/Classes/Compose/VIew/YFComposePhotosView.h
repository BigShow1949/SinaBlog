//
//  YFComposePhotosView.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-2.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFComposePhotosView : UIView
/**
 * 增加图片
 */
- (void)addImage:(UIImage *)image;
/**
 * 取出显示的所有图片
 */
- (NSArray *)images;
@end
