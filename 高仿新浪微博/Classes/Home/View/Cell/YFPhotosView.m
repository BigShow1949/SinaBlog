//
//  YFPhotosView.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-8.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFPhotosView.h"
#import "UIImageView+WebCache.h"
#import "YFPicUrl.h"
#import "YFPhotoView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define YFPhotoMargin  10// 间隙
#define YFPhotoWidth 70// 配图的宽度
#define YFPhotoHeight  YFPhotoWidth // 配图的高度


@interface YFPhotosView ()
// 蒙版
@property (nonatomic, weak)  UIView *conver;

// 被点击图片原始的frame
@property (nonatomic, assign) CGRect oldFrame;

#warning 注意 , 变量名不能以new开头
@property (nonatomic, weak) UIImageView *currentIv;

@end

@implementation YFPhotosView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        // 初始化9张配图
        for (int i = 0; i < 9; i++) {
            // 1.创建配图
            YFPhotoView *imageView = [[YFPhotoView alloc] init];
            imageView.hidden = YES;
            [self addSubview:imageView];
            
            // 2.监听配图点击事件
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
            [imageView addGestureRecognizer:tap];
        }
    }
    return self;
}

- (void)imageTap:(UITapGestureRecognizer *)tap
{
    
    // 集成框架
    // 1.创建浏览器
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    // 2.设置浏览器需要显示的数据
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i < self.pic_urls.count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        YFPicUrl *picUrl = self.pic_urls[i];
        // 设置需要显示的图片的url
        photo.url = [NSURL URLWithString:picUrl.bmiddle_pic];
        // 设置需要显示的图片对应的原始图片
        photo.srcImageView = self.subviews[i];
        [photos addObject:photo];
    }
    
    browser.photos = photos;
    // 3.告诉浏览器当前点击的是哪张图片
    browser.currentPhotoIndex = tap.view.tag;
    // 4.显示浏览器
    [browser show];
    
    
//        NSLog(@"%s", __func__);
//    
//    // 1.创建蒙版
//    UIView *conver = [[UIView alloc] init];
//    conver.backgroundColor = [UIColor blackColor];
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    conver.frame = window.bounds;
//    [window addSubview:conver];
//    self.conver = conver;
//    // 给蒙版添加监听事件
//    UITapGestureRecognizer *converTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(converTap:)];
//    [conver addGestureRecognizer:converTap];
//    
//    
//    // 2.新的UIImageView
//    // 2.1获取手指点击的ImageView
//    YFPhotoView *oldIv = (YFPhotoView *)tap.view;
//    // 2.2获取点击图片对应的数据模型
//    YFPicUrl *picUrl = oldIv.picUrl;
//    NSURL *url = [NSURL URLWithString:picUrl.bmiddle_pic];
//    //http://ww3.sinaimg.cn/square/8e6cb447gw1ens6zhrd43j20c80c8jsj.jpg
//    // http://ww3.sinaimg.cn/bmiddle/8e6cb447gw1ens6zhrd43j20c80c8jsj.jpg
//    NSLog(@"%@", url);
//    // 3.设置新的UIImageView的数据为点击的imageview的数据
//    UIImageView *newIv = [[UIImageView alloc] init];
//    newIv.contentMode = UIViewContentModeScaleAspectFill;
//    [newIv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
//    
//    // 4.设置新的UIImageView的frame为点击的imageview的frame
//    //    newIv.frame = oldIv.frame; // 有问题的
//    // 将oldIv的frame从以前的参照坐标系转换到conver的坐标系
//    newIv.frame = [conver convertRect:oldIv.frame fromView:oldIv.superview];
//    // 记录原始的frame
//    self.oldFrame = newIv.frame;
//    
//    // 5.添加新的UIImageView到蒙版上
//    [conver addSubview:newIv];
//    self.currentIv = newIv;
//    
//    // 6.做动画放大
//    [UIView animateWithDuration:5 animations:^{
//        
//        CGRect tempFrame = newIv.frame;
//        tempFrame.size.width = conver.width;
//        tempFrame.size.height = tempFrame.size.width * (newIv.height / newIv.width);
//        tempFrame.origin.x = 0;
//        tempFrame.origin.y = (conver.height - tempFrame.size.height) * 0.5;
//        newIv.frame = tempFrame;
//        
//        
//        /*
//         // 通过以下方式修改frame后做动画效果不对, 因为每次设置都修改了frame
//         newIv.width = conver.width;
//         newIv.height =  newIv.width * (newIv.height / newIv.width);
//         newIv.x = 0;
//         newIv.y = (conver.height - newIv.height) * 0.5;
//         */
//        
//    }];
}

// 没用了这个方法
- (void)converTap:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:5 animations:^{
        // 缩小图片 , 还原图片以前的frame
        self.currentIv.frame = self.oldFrame;
        
    } completion:^(BOOL finished) {
        // 移除蒙版
        [self.conver removeFromSuperview];
    }];
}

- (void)setPic_urls:(NSArray *)pic_urls //7 0~6
{
    _pic_urls = pic_urls;
    //    NSLog(@"%s", __func__);
    
    // 防止重用, 判断配图容器是否真的需要显示
    if (_pic_urls.count > 0) {
        self.hidden = NO;
    }else
    {
        self.hidden = YES;
    }
    
    /*
     // 0.清空上一次添加的UIImageView
     //    for (UIImageView *iv in self.subviews) {
     //        [iv removeFromSuperview];
     //    }
     [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     
     // 1.遍历传入的数组, 创建下载需要显示的图片
     for (int i = 0; i < pic_urls.count; i++) {
     // 1.1创建UIImageView
     UIImageView *imageView = [[UIImageView alloc] init];
     [self addSubview:imageView];
     
     // 1.2取出对应位置的模型
     YFPicUrl *picUrl = _pic_urls[i];
     NSURL *url = [NSURL URLWithString:picUrl.thumbnail_pic];
     
     // 1.3下载图片
     [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
     
     }
     */
    
#warning 注意, 由于cell会被重用, 所以可能前一次的cell有9张配图, 但是重用之后的cell没有9张配图, 可能只有1~8张, 但是由于上一次有9张, 所以9张配图的hidden状态都是NO, 所以被重用时需要把不需要显示的配图hidden设置为YES, 但是我们这个地方遍历的时候, 是以传入的配图数量作为最大值, 所以不能完全遍历9张图片, 所以每次都必须遍历9张图片, 将所有图片的状态重新设置一次
    //     for (int i = 0; i < pic_urls.count; i++) { // 3
    for (int i = 0; i < 9; i++) {
        // 1.取出以前添加的UIImageView
        //         UIImageView *iv = self.subviews[i];
        YFPhotoView *iv = self.subviews[i];
        
        // 2.判断需要显示几张?
        if(i < _pic_urls.count)
        {
            // 显示
            iv.hidden = NO;
            
            /*
             // 下载图片
             // 1.2取出对应位置的模型
             YFPicUrl *picUrl = _pic_urls[i];
             NSURL *url = [NSURL URLWithString:picUrl.thumbnail_pic];
             
             // 1.3下载图片
             [iv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder"]];
             */
            iv.picUrl = _pic_urls[i];
        }else
        {
            // 隐藏
            iv.hidden = YES;
        }
        
    }
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSUInteger count =  self.subviews.count;
    for (NSUInteger i = 0; i < count; i++) {
        // 行号
        NSUInteger row = i / 3;
        // 列号
        NSUInteger col = i % 3;
        
        // X = 列号 * (宽度 + 间隙)
        CGFloat imageX = col * (YFPhotoWidth + YFPhotoMargin);
        // Y = 行号 * (高度+ 间隙)
        CGFloat imageY = row * (YFPhotoHeight + YFPhotoMargin);
        
        UIImageView *iv = self.subviews[i];
        iv.frame = CGRectMake(imageX, imageY, YFPhotoWidth, YFPhotoHeight);
    }
}

+ (CGSize)sizeWithPhotoCount:(NSUInteger)photoCount
{
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
    
    return CGSizeMake(width, heigth);
}
@end
