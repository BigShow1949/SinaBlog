//
//  YFComposePhotosView.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-2.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFComposePhotosView.h"

@implementation YFComposePhotosView

/**
 * 增加图片
 */
- (void)addImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    [self addSubview:imageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    int maxCols = 3; // 每行最多3列
    CGFloat leftRightMargin = 10; // 左右间距
    CGFloat imageMargin = 15; // 图片之间的间距
    CGFloat imageW = (self.width - 2 * leftRightMargin - (maxCols - 1) * imageMargin) / maxCols;
    CGFloat imageH = imageW;
    for (NSUInteger i = 0; i < self.subviews.count; i++) {
        UIImageView *imageView = self.subviews[i];
        imageView.width = imageW;
        imageView.height = imageH;
        imageView.x = leftRightMargin + (i % maxCols) * (imageW + imageMargin);
        imageView.y = (i / maxCols) * (imageH + imageMargin);
    }
}

/**
 * 取出显示的所有图片
 */
- (NSArray *)images
{
    //    NSMutableArray *images = [NSMutableArray array];
    //    for (UIImageView *imageView in self.subviews) {
    //        [images addObject:imageView.image];
    //    }
    // 将self.subviews中所有元素(所有子控件)的image属性取出来,放进一个新的数组中,并返回
    return [self.subviews valueForKeyPath:@"image"];
}

@end
