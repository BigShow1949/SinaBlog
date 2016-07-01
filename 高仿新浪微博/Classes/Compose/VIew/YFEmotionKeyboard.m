//
//  YFEmotionKeyboard.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-30.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFEmotionKeyboard.h"
#import "YFEmotionContentView.h"
#import "YFEmotionTool.h"

static NSString * const YFDefaultText = @"默认";
static NSString * const YFLxhText = @"浪小花";
static NSString * const YFRecentText = @"最近";

@interface YFEmotionToolbarButton : UIButton
@end
@implementation YFEmotionToolbarButton
- (void)setHighlighted:(BOOL)highlighted {}
@end

@interface YFEmotionKeyboard ()
/** 底部的工具条 */
@property (nonatomic, weak) UIView *toolbar;
/** 当前被选中的按钮 */
@property (nonatomic, weak) YFEmotionToolbarButton *selectedButton;

/** 最近 */
@property (nonatomic, strong) YFEmotionContentView *recentContentView;
/** 默认 */
@property (nonatomic, strong) YFEmotionContentView *defaultContentView;
/** 浪小花 */
@property (nonatomic, strong) YFEmotionContentView *lxhContentView;

/** 当前被选中的内容(正在显示) */
@property (nonatomic, weak) YFEmotionContentView *selectedContentView;

@end


@implementation YFEmotionKeyboard

- (YFEmotionContentView *)recentContentView
{
    if (!_recentContentView) {
        self.recentContentView = [[YFEmotionContentView alloc] init];
        self.recentContentView.emotions = [YFEmotionTool recentEmotions];
    }
    return _recentContentView;
}

- (YFEmotionContentView *)defaultContentView
{
    if (!_defaultContentView) {
        self.defaultContentView = [[YFEmotionContentView alloc] init];
        self.defaultContentView.emotions = [YFEmotionTool defaultEmotions];
    }
    return _defaultContentView;
}

- (YFEmotionContentView *)lxhContentView
{
    if (!_lxhContentView) {
        self.lxhContentView = [[YFEmotionContentView alloc] init];
        self.lxhContentView.emotions = [YFEmotionTool lxhEmotions];
    }
    return _lxhContentView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        
        // 1.创建底部工具条
        UIView *toolbar = [[UIView alloc] init];
        [self addSubview:toolbar];
        self.toolbar = toolbar;
        
        // 2.创建底部工具条的按钮
        [self setupButton:YFRecentText];
        [self buttonClick:[self setupButton:YFDefaultText]];
        [self setupButton:YFLxhText];
    }
    return self;
}

/**
 *  创建一个按钮
 *
 *  @param title 按钮文字
 */
- (YFEmotionToolbarButton *)setupButton:(NSString *)title
{
    YFEmotionToolbarButton *button = [[YFEmotionToolbarButton alloc] init];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"compose_emotion_table_mid_normal"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    [button setBackgroundImage:[UIImage imageNamed:@"compose_emotion_table_mid_selected"] forState:UIControlStateDisabled];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    [self.toolbar addSubview:button];
    
    return button;
}

- (void)buttonClick:(YFEmotionToolbarButton *)button
{
    // 设置按钮的状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    
    // 移除当前正在显示的内容
    [self.selectedContentView removeFromSuperview];
    
    // 切换顶部的内容
    if ([button.currentTitle isEqualToString:YFDefaultText]) {
        [self addSubview:self.defaultContentView];
        self.selectedContentView = self.defaultContentView;
    } else if ([button.currentTitle isEqualToString:YFLxhText]) {
        [self addSubview:self.lxhContentView];
        self.selectedContentView = self.lxhContentView;
    } else if ([button.currentTitle isEqualToString:YFRecentText]) {
        [self addSubview:self.recentContentView];
        self.selectedContentView = self.recentContentView;
        
        // 刷新最近的数据
        self.recentContentView.emotions = [YFEmotionTool recentEmotions];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.底部的工具条
    self.toolbar.x = 0;
    self.toolbar.height = 35;
    self.toolbar.width = self.width;
    self.toolbar.y = self.height - self.toolbar.height;
    
    // 2.底部工具条的按钮
    NSUInteger count = self.toolbar.subviews.count;
    CGFloat buttonW = self.toolbar.width / count;
    for (NSUInteger i = 0; i < count; i++) {
        YFEmotionToolbarButton *button = self.toolbar.subviews[i];
        button.y = 0;
        button.height = self.toolbar.height;
        button.width = buttonW;
        button.x = i * buttonW;
    }
    
    // 3.设置尺寸
    self.selectedContentView.width = self.width;
    self.selectedContentView.height = self.toolbar.y;
    
}



@end
