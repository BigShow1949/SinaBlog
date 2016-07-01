//
//  YFTopView.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-6.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFTopView.h"
#import "YFStatusFrame.h"
#import "YFOriginalView.h"
#import "YFRetweetView.h"

@interface YFTopView ()
/** 原创微博 */
@property (nonatomic, weak) YFOriginalView *originalView;
/** 转发微博 */
@property (nonatomic, weak) YFRetweetView *retweetView;

@end

@implementation YFTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 初始化子控件
        // 初始化原创
        // 创建原创微博容器
        YFOriginalView *originalView = [[YFOriginalView alloc] init];
        [self addSubview:originalView];
        self.originalView = originalView;
        
        // 初始化转发
        // 转发微博容器
        YFRetweetView *retweetView = [[YFRetweetView alloc] init];
        [self addSubview:retweetView];
        self.retweetView = retweetView;
        
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)setStatusFrame:(YFStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    // 设置自己的frame
    self.frame = _statusFrame.topViewF;
    
    // 传递数据给原创和转发
    self.originalView.statusFrame = _statusFrame;
    self.retweetView.statusFrame = _statusFrame;
}

@end
