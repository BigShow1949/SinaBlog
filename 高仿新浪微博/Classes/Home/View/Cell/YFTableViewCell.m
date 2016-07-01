//
//  YFTableViewCell.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-6.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFTableViewCell.h"
#import "YFStatus.h"
#import "YFStatusFrame.h"
#import "YFUser.h"
#import "UIImageView+WebCache.h"

#import "YFTopView.h"
#import "YFBottomView.h"

@interface YFTableViewCell ()

/** 顶部的view */
@property (nonatomic, weak) YFTopView *topView;

/** 底部的工具条 */
@property (nonatomic, weak) YFBottomView *bottomView;

@end

@implementation YFTableViewCell
+ (instancetype)cellWithTableview:(UITableView *)tableview
{
    static NSString *identifier = @"customCell";
    
    YFTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[YFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = YFColor(237, 237, 237);
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 初始化操作, 创建所有将来有可能用到的子控件, 进行一次性的设置
        // 初始化顶部视图
        [self setupTopView];
        // 初始化顶部视图
        [self setupBottomView];
    }
    return self;
}
/**
 *  初始化顶部视图
 */
- (void)setupTopView
{
    // 1.创建顶部容器
    YFTopView *topView = [[YFTopView alloc] init];
    [self.contentView addSubview:topView];
    self.topView = topView;
    
}


/**
 *  初始化底部视图
 */
- (void)setupBottomView
{
    // 1.创建底部视图容器
    /** 添加底部View */
    YFBottomView *bottomView = [[YFBottomView alloc] init];
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
}

- (void)setStatusFrame:(YFStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    // 传递数据给顶部和底部
    self.topView.statusFrame = _statusFrame;
    self.bottomView.statusFrame = _statusFrame;
}


@end
