//
//  YFOriginalView.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-6.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFOriginalView.h"
#import "YFStatusFrame.h"
#import "YFStatus.h"
#import "YFUser.h"
#import "UIImageView+WebCache.h"
#import "YFPhotosView.h"
#import "YFStatusTextView.h"

@interface YFOriginalView ()
/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/** 正文\内容 */
//@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) YFStatusTextView *contentLabel;


/**
 *  配图容器
 */
@property (nonatomic, weak) YFPhotosView *photosView;


@end
@implementation YFOriginalView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化子控件
        
        /** 2.头像 */
        UIImageView *iconView = [[UIImageView alloc] init];
        [self addSubview:iconView];
        self.iconView = iconView;
        
        /** 3.昵称 */
        UILabel *nameLabel = [[UILabel alloc] init];
        [self addSubview:nameLabel];
        self.nameLabel = nameLabel;
        self.nameLabel.font = YFCellNameFont;
        
        /** 4.会员图标 */
        UIImageView *vipView = [[UIImageView alloc] init];
        [self addSubview:vipView];
        self.vipView = vipView;
        
        /** 5.时间 */
        UILabel *timeLabel = [[UILabel alloc] init];
        [self addSubview:timeLabel];
        self.timeLabel = timeLabel;
        self.timeLabel.font = YFCellTimeFont;
        self.timeLabel.textColor = [UIColor orangeColor];
        
        /** 6.来源 */
        UILabel *sourceLabel = [[UILabel alloc] init];
        [self addSubview:sourceLabel];
        self.sourceLabel = sourceLabel;
        self.sourceLabel.font = YFCellSourceFont;
        
        /** 7.正文\内容 */
        YFStatusTextView *contentLabel = [[YFStatusTextView alloc] init];
        [self addSubview:contentLabel];
        self.contentLabel = contentLabel;
//        self.contentLabel.numberOfLines = 0;
        self.contentLabel.font = YFCellContentFont;
        
        // 8.配图容器
        YFPhotosView *photosView = [[YFPhotosView alloc] init];
        [self addSubview:photosView];
        self.photosView = photosView;
        
    }
    return self;
}

- (void)setStatusFrame:(YFStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    // 设置自己的frame
    self.frame = _statusFrame.orginalViewF;
    
    // 设置数据
    [self setupData];
    // 设置frame
    [self setupFrame];
    
}

- (void)setupData
{
    
    YFStatus *status = _statusFrame.status;
    YFUser *user = status.user;
    
    /** 1.头像 */
    NSURL *iconURL = [NSURL URLWithString:user.profile_image_url];
    [self.iconView sd_setImageWithURL:iconURL placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    
    /** 2.昵称 */
    self.nameLabel.text = user.name;
    
    /** 3.会员图标 */
    if (user.isVip) {
        // 是会员
        // 3.1根据会员等级获取对应的会员图片
        NSString *vipImageName = [NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank];
        // 3.2设置会员图标
        self.vipView.image = [UIImage imageNamed:vipImageName];
        self.vipView.hidden = NO;
        
        // 3.3设置昵称的颜色
        self.nameLabel.textColor = [UIColor orangeColor];
    }else
    {
        // 不是会员
        self.vipView.hidden = YES;
        self.nameLabel.textColor = [UIColor blackColor];
    }
    
    /** 4.时间 */
    self.timeLabel.text = status.created_at;
    
    /** 5.来源 */
    self.sourceLabel.text = status.source;
    
    /** 6.正文\内容 */
//    self.contentLabel.text = status.text;
    self.contentLabel.attributedText = status.attributedText;
    
    // 7.配图容器
    self.photosView.pic_urls = status.pic_urls;
}

- (void)setupFrame
{
    /** 1.头像 */
    self.iconView.frame = self.statusFrame.iconViewF;
    
    /** 2.昵称 */
    self.nameLabel.frame = self.statusFrame.nameLabelF;
    
    /** 3.会员图标 */
    self.vipView.frame = self.statusFrame.vipViewF;
    /*
     // 4.时间
     self.timeLabel.frame = self.statusFrame.timeLabelF;
     
     // 5.来源
     self.sourceLabel.frame = self.statusFrame.sourceLabelF;
     */
    
    YFStatus *status = self.statusFrame.status;
    /** 时间 */
    CGFloat timeX = self.statusFrame.nameLabelF.origin.x;
    CGFloat timeY = CGRectGetMaxY(self.statusFrame.nameLabelF) + YFCellMargin * 0.5;
    CGSize timeSize = [status.created_at sizeWithFont:YFCellTimeFont];
    self.timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabel.frame) + YFCellMargin;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:YFCellSourceFont];
    self.sourceLabel.frame = (CGRect){{sourceX, sourceY}, sourceSize};
    
    /** 6.正文\内容 */
    self.contentLabel.frame = self.statusFrame.contentLabelF;

    // 7.配图
    self.photosView.frame = self.statusFrame.photosViewF;
}

@end
