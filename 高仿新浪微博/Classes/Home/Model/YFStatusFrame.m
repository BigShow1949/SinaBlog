//
//  YFStatusFrame.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-6.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFStatusFrame.h"
#import "YFStatus.h"
#import "YFUser.h"
#import "YFPhotosView.h"

@implementation YFStatusFrame
- (void)setStatus:(YFStatus *)status
{
    _status = status;
    
    // 1.计算原创微博frame
    [self setupOriginalFrame];
    
    // 2.计算转发微博frame
    [self setupRetweetedFrame];
    
    // 3.计算顶部容器frame
    [self setupTopFrame];
    
    // 4.计算底部容器frame
    [self setupBottomFrame];
    
    // 5.cell的高度 给底部留点空隙
    _cellHeight = CGRectGetMaxY(_bottomViewF) + 8;
    
}

/**
 *  计算原创微博frame
 */
- (void)setupOriginalFrame
{
    /** 头像 */
    CGFloat iconX = YFCellMargin;
    CGFloat iconY = YFCellMargin;
    CGFloat iconWidth = 35;
    CGFloat iconHeight = 35;
    _iconViewF = (CGRect){{iconX, iconY}, {iconWidth, iconHeight}};
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(_iconViewF) + YFCellMargin;
    CGFloat nameY = iconY;
    CGSize nameSize = [_status.user.name sizeWithFont:YFCellNameFont];
    _nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    /** 会员图标 */
    CGFloat vipX = CGRectGetMaxX(_nameLabelF) + YFCellMargin;
    CGFloat vipY = iconY;
    CGFloat vipW = 14;
    CGFloat vipH = 14;
    _vipViewF = (CGRect){{vipX, vipY}, {vipW, vipH}};
    
    
    /** 正文\内容 */
    CGFloat contentX = iconX;
    CGFloat contentY = CGRectGetMaxY(_iconViewF) + YFCellMargin;
    CGSize contentMaxSize = CGSizeMake(YFScreenWith - YFCellMargin - YFCellMargin, CGFLOAT_MAX);
//    CGSize contentSize = [_status.text sizeWithFont:YFCellContentFont constrainedToSize:contentMaxSize];
    CGSize contentSize = [_status.attributedText boundingRectWithSize:contentMaxSize options:NSStringDrawingUsesLineFragmentOrigin context:NULL].size;

    _contentLabelF = (CGRect){{contentX, contentY}, contentSize};
    
    // 计算配图容器的frame
    CGFloat orginalH = 0.0;
    if (_status.pic_urls.count > 0) {
        // 有配图
        NSUInteger photoCount = _status.pic_urls.count;
        /*
         // 列数
         NSUInteger col = photoCount > 3 ? 3 : photoCount;
         // 行数
         NSUInteger row = 0;
         // 6 3 9
         if (photoCount % 3 == 0) {
         
         row = photoCount / 3; // 2 1 3
         }else
         {
         // 2 5
         row = photoCount / 3 + 1; // 1 2
         }
         
         CGFloat photoMargin = 10;// 间隙
         CGFloat photoWidth = 70; // 配图的宽度
         CGFloat photoHeight = photoWidth; // 配图的高度
         
         // 宽度 = 列数 * 配图的宽度 + (列数 - 1) * 间隙
         CGFloat width = col * photoWidth + (col - 1) * photoMargin;
         // 高度 = 行数 * 配图的高度 + (行数 - 1) * 间隙
         CGFloat heigth = row * photoHeight + (row - 1) * photoMargin;
         */
        CGSize photoSize = [YFPhotosView sizeWithPhotoCount:photoCount];
        CGFloat photoX = iconX;
        CGFloat photoY = CGRectGetMaxY(_contentLabelF) + YFCellMargin;
        _photosViewF = (CGRect){{photoX, photoY}, photoSize};
        
        orginalH = CGRectGetMaxY(_photosViewF);
    }else
    {
        // 没有配图
        orginalH = CGRectGetMaxY(_contentLabelF);
    }
    
    /** 原创微博 */
    CGFloat orginalX = 0;
    CGFloat orginalY = 0;
    CGFloat orginalW = YFScreenWith;
//    CGFloat orginalH = CGRectGetMaxY(_contentLabelF);
    _orginalViewF = (CGRect){{orginalX, orginalY}, {orginalW, orginalH}};
    
}
/**
 *  计算转发微博frame
 */
- (void)setupRetweetedFrame
{
    // 取出转发微博
    YFStatus *retweetedStatus = _status.retweeted_status;
    if (retweetedStatus != nil) {
        // 有转发
        
        // 转发的正文
        CGFloat retweetContentX = YFCellMargin;
        CGFloat retweetContentY = YFCellMargin;
        CGSize retweetContentMaxSize = CGSizeMake(YFScreenWith - YFCellMargin - YFCellMargin, CGFLOAT_MAX);
//        CGSize retweetContentSize = [retweetedStatus.text sizeWithFont:YFCellContentFont constrainedToSize:retweetContentMaxSize];
        CGSize retweetContentSize = [retweetedStatus.attributedText boundingRectWithSize:retweetContentMaxSize options:NSStringDrawingUsesLineFragmentOrigin context:NULL].size;

        _retweetContentLabelF = (CGRect){{retweetContentX, retweetContentY}, retweetContentSize};
        
        
        // 计算配图容器的frame
        CGFloat retweetH = 0.0;
        YFStatus *retweeteStatus = _status.retweeted_status;
        if (retweeteStatus.pic_urls.count > 0) {
            // 有配图
            NSUInteger photoCount = retweeteStatus.pic_urls.count;
            /*
             // 列数
             NSUInteger col = photoCount > 3 ? 3 : photoCount;
             // 行数
             NSUInteger row = 0;
             // 6 3 9
             if (photoCount % 3 == 0) {
             
             row = photoCount / 3; // 2 1 3
             }else
             {
             // 2 5
             row = photoCount / 3 + 1; // 1 2
             }
             
             CGFloat photoMargin = 10;// 间隙
             CGFloat photoWidth = 70; // 配图的宽度
             CGFloat photoHeight = photoWidth; // 配图的高度
             
             // 宽度 = 列数 * 配图的宽度 + (列数 - 1) * 间隙
             CGFloat width = col * photoWidth + (col - 1) * photoMargin;
             // 高度 = 行数 * 配图的高度 + (行数 - 1) * 间隙
             CGFloat heigth = row * photoHeight + (row - 1) * photoMargin;
             */
            CGSize photoSize = [YFPhotosView sizeWithPhotoCount:photoCount];
            CGFloat photoX = retweetContentX;
            CGFloat photoY = CGRectGetMaxY(_retweetContentLabelF) + YFCellMargin;
            _retweetPhotosViewF = (CGRect){{photoX, photoY}, photoSize};
            
            retweetH = CGRectGetMaxY(_retweetPhotosViewF);
        }else
        {
            // 没有配图
            retweetH = CGRectGetMaxY(_retweetContentLabelF);
        }
        
        
        // 转发微博
        CGFloat retweetX = 0;
        CGFloat retweetY = CGRectGetMaxY(_orginalViewF) + YFCellMargin;
        CGFloat retweetW = YFScreenWith;
//        CGFloat retweetH = CGRectGetMaxY(_retweetContentLabelF) + YFCellMargin;
        _retweetViewF = (CGRect){{retweetX, retweetY}, {retweetW, retweetH}};
        
    }
}
/**
 *  计算顶部容器frame
 */
- (void)setupTopFrame
{
    CGFloat topX = 0;
    CGFloat topY = 0;
    CGFloat topW = YFScreenWith;
    // 取出转发微博
    YFStatus *retweetedStatus = _status.retweeted_status;
    CGFloat topH = 0.0;
    if (retweetedStatus != nil)
    {
        
        topH = CGRectGetMaxY(_retweetViewF);
    }else
    {
        // 没有转发微博
        // 顶部视图高度 = 原创微博最大的Y + 间隙
        topH = CGRectGetMaxY(_orginalViewF);
    }
    _topViewF = (CGRect){{topX, topY}, {topW, topH}};
    
}
/**
 *  计算底部容器frame
 */
- (void)setupBottomFrame
{
    CGFloat bottomX = 0;
    CGFloat bottomY = CGRectGetMaxY(_topViewF);
    CGFloat bottomW = YFScreenWith;
    CGFloat bottomH = 35;
    _bottomViewF = (CGRect){{bottomX, bottomY}, {bottomW, bottomH}};
}
@end
