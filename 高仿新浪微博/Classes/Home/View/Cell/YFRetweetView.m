//
//  YFRetweetView.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-6.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFRetweetView.h"
#import "YFStatusFrame.h"
#import "YFStatus.h"
#import "YFUser.h"
#import "YFPhotosView.h"

@interface YFRetweetView ()
/** 转发正文\内容 */
@property (nonatomic, weak) UILabel *retweetContentLabel;
// 配图容器
@property (nonatomic, weak) YFPhotosView *retweetPhotosView;
@end

@implementation YFRetweetView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化子控件
        // 转发正文
        UILabel *retweetContentLabel = [[UILabel alloc] init];
        [self addSubview:retweetContentLabel];
        self.retweetContentLabel = retweetContentLabel;
        retweetContentLabel.font = YFCellContentFont;
        retweetContentLabel.numberOfLines = 0;
        
        self.backgroundColor = YFColor(250, 250, 250);
        
        
        YFPhotosView *retweetPhotosView = [[YFPhotosView alloc] init];
        [self addSubview:retweetPhotosView];
        self.retweetPhotosView = retweetPhotosView;
    }
    return self;
}

- (void)setStatusFrame:(YFStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    // 设置自己的frame
    self.frame = _statusFrame.retweetViewF;
    
    // 设置数据
    [self setupData];
    // 设置frame
    [self setupFrame];
}

- (void)setupData
{
    YFStatus *status = self.statusFrame.status;
    //    self.retweetContentLabel.text = [NSString stringWithFormat:@"@%@: %@", status.retweeted_status.user.name, status.retweeted_status.text];
#warning 如果直接设置带属性的字符串将来显示出来的内容会有问题, 因为计算label的frame的时候, 是用text计算的, 但是显示的时候确实用attributedText显示的
    self.retweetContentLabel.attributedText = self.statusFrame.status.retweetedAttributedText;
    if (status.retweeted_status.pic_urls.count > 0) {
        
        self.retweetPhotosView.pic_urls = status.retweeted_status.pic_urls;
    }
}

//- (void)setupFrame
//{
//    // 8.转发正文
//    self.retweetContentLabel.frame = self.statusFrame.retweetContentLabelF;
//    
//    self.retweetPhotosView.frame = self.statusFrame.retweetPhotosViewF;
//
//}

- (void)setupFrame
{
    // 8.转发正文
    self.retweetContentLabel.frame = self.statusFrame.retweetContentLabelF;
    
    if (self.statusFrame.status.retweeted_status.pic_urls.count > 0) {
        self.retweetPhotosView.hidden = NO;
        self.retweetPhotosView.frame = self.statusFrame.retweetPhotosViewF;
    }else
    {
        self.retweetPhotosView.hidden = YES;
    }
}

@end
