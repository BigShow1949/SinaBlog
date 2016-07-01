//
//  YFPhotoView.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-8.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFPhotoView.h"
#import "UIImageView+WebCache.h"
#import "YFPicUrl.h"

@interface YFPhotoView ()
@property (nonatomic, weak)  UIImageView *gifIv;

@end

@implementation YFPhotoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 创建gif图片
        UIImageView *gifIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_image_gif"]];
        [self addSubview:gifIv];
        self.gifIv = gifIv;
        
        // 设置当前控件的图片的内容模式
        /*
         注意, 但凡是枚举值中包含Scale单词的都会对图片进行拉伸, 只是拉伸的模型不太一样
         typedef NS_ENUM(NSInteger, UIViewContentMode) {
         // 默认, 如果设置图片的内容模式为ScaleToFill, 系统将会按照UIImageView的宽高比, 对图片进行缩放. 直到图片填充整个UIImageView为止
         UIViewContentModeScaleToFill,
         
         注意: 但凡枚举中包含Aspect单词的都会按照图片的宽高比进行缩放
         // 如果设置图片的内容模式为ScaleAspectFit, 系统会按照图片的宽高比缩放图片, 直到图片的宽度或者高度和UIImageView一样为止, 并且居中显示
         UIViewContentModeScaleAspectFit,
         
         // 如果设置图片的内容模式为ScaleAspectFill,系统会按照图片的宽高比缩放图片, 直到图片的宽和高和UIImageView一样为止, 也就是说直到图片能够填充整个UIImageView为止,并且居中显示
         UIViewContentModeScaleAspectFill,
         
         
         UIViewContentModeRedraw,
         UIViewContentModeCenter,
         UIViewContentModeTop,
         UIViewContentModeBottom,
         UIViewContentModeLeft,
         UIViewContentModeRight,
         UIViewContentModeTopLeft,
         UIViewContentModeTopRight,
         UIViewContentModeBottomLeft,
         UIViewContentModeBottomRight,
         };
         */
        self.contentMode =  UIViewContentModeScaleAspectFill;
        
        self.clipsToBounds = YES;
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setPicUrl:(YFPicUrl *)picUrl
{
    _picUrl = picUrl;
    
    NSURL *url = [NSURL URLWithString:_picUrl.thumbnail_pic];
    //    NSLog(@"%@", _picUrl.thumbnail_pic.pathExtension);
    // 判断是否是gif图片
    // http://ww2.sinaimg.cn/bmiddle/70e0a133gw1ensv7eodupg208p05kkjl.gif
    // http://ww2.sinaimg.cn/bmiddle/70e0a133gw1ensv7eodupg208p05kkjl.GIF
    //    if ([_picUrl.thumbnail_pic.lowercaseString hasSuffix:@".gif"])
    if ([_picUrl.thumbnail_pic.pathExtension.lowercaseString isEqualToString:@"gif"]) {
        
        // 是gif图片
        self.gifIv.hidden = NO;
    }else
    {
        self.gifIv.hidden = YES;
    }
    
    // 下载图片
    [self sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.gifIv.y = self.height - self.gifIv.height;
    self.gifIv.x = self.width - self.gifIv.width;
}
@end
