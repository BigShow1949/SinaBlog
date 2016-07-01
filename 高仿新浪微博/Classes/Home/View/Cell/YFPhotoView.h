//
//  YFPhotoView.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-8.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YFPicUrl;
@interface YFPhotoView : UIImageView
/**
 *  图片模型
 */
@property (nonatomic, strong) YFPicUrl *picUrl;
@end
