//
//  YFBottomView.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-6.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFBottomView.h"
#import "YFStatusFrame.h"
#import "YFStatus.h"
#import "UIImage+Extension.h"

@interface YFBottomView ()
/**
 *  存储所有的按钮
 */
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *dividers;
/**
 *  转发
 */
@property (nonatomic, strong) UIButton *retweetBtn;
/**
 *  评论
 */
@property (nonatomic, strong) UIButton *commentBtn;
/**
 *  赞
 */
@property (nonatomic, strong) UIButton *unlikeBtn;

@end

@implementation YFBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 初始化三个按钮
        self.retweetBtn =  [self addButtonWithTitle:@"转发" image:@"timeline_icon_retweet"];
        self.commentBtn = [self addButtonWithTitle:@"评论" image:@"timeline_icon_comment"];
        self.unlikeBtn = [self addButtonWithTitle:@"赞" image:@"timeline_icon_unlike"];
        
        // 初始化两条分割线
        [self addDivider];
        [self addDivider];
        
        // 初始化顶部分割线
//        [self addTopDiv];
        self.backgroundColor = YFColor(300, 300, 300);
        
    }
    return self;
}
/**
 *  添加一个按钮
 *
 *  @param title 按钮标题
 *  @param image 按钮图片
 */
- (UIButton *)addButtonWithTitle:(NSString *)title image:(NSString *)image
{
    // 创建按钮
    UIButton *btn = [[UIButton alloc] init];
    // 设置图片
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    
    // 设置高亮状态不调整图片
    btn.adjustsImageWhenHighlighted = NO;
    
    // 设置按钮标题和图片之间的间隙
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);

    // 设置背景
    [btn setBackgroundImage:[UIImage resizableImageWithName:@"common_card_bottom_background"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage resizableImageWithName:@"common_card_bottom_background_highlighted"] forState:UIControlStateHighlighted];
    
    // 设置标题
    [btn setTitle:title forState:UIControlStateNormal];
    // 设置标题颜色
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    // 设置标题文字大小
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    // 添加按钮到底部视图
    [self addSubview:btn];
    
    [self.buttons addObject:btn];
    
    return btn;
}

/**
 *  添加按钮分割线
 */
- (void)addDivider
{
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"timeline_card_bottom_line"]];
    [self addSubview:iv];
    [self.dividers addObject:iv];
}

/**
 *  添加顶部分割线
 */
- (void)addTopDiv{
    UIView * topView = [[UIView alloc] init];
    topView.backgroundColor = YFColor(225, 225, 225);
    topView.frame = CGRectMake(0, 10, YFScreenWith, 1);
    [self addSubview:topView];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 计算设置三个按钮的frame
    NSUInteger buttonCount = self.buttons.count;
    CGFloat buttonW = self.width / buttonCount;
    CGFloat buttonH = self.height;
    for (int i = 0; i < buttonCount; i++) {
        CGFloat buttonY = 0;
        CGFloat buttonX = i * buttonW;
        
        UIButton *btn = self.buttons[i];
        btn.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }
    
    // 计算设置两条分割线的frame
    NSUInteger dividerCount = self.dividers.count;
    for(int i = 0; i < dividerCount; i++)
    {
        CGFloat dividerX = (i + 1) * buttonW;
        CGFloat dividerY = 0;
        CGFloat dividerW = 1;
        CGFloat dividerH = self.height;
        
        UIImageView *iv = self.dividers[i];
        iv.frame = CGRectMake(dividerX, dividerY, dividerW, dividerH);
    }
}

- (void)setStatusFrame:(YFStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    // 设置底部自己的frame
    self.frame = _statusFrame.bottomViewF;
    
    // 取出frame模型中的数据模型
    YFStatus *status = _statusFrame.status;
    
    /*
     if (status.attitudes_count.intValue > 0) {
     
     [self.unlikeBtn setTitle: [status.attitudes_count description] forState:UIControlStateNormal];
     }else
     {
     [self.unlikeBtn setTitle:@"赞" forState:UIControlStateNormal];
     }
     */
    
    //    [self setButton:self.retweetBtn originalTitle:@"转发" count:status.reposts_count];
    /*
     如果超过1万就显示 几点几万
     10000 1万
     15000 1.5万
     */
    [self setButton:self.retweetBtn originalTitle:@"转发" count:@(15000)];
    [self setButton:self.commentBtn originalTitle:@"评论" count:status.comments_count];
    [self setButton:self.unlikeBtn originalTitle:@"赞" count:status.attitudes_count];
}

/**
 *  设置按钮显示的内容
 *
 *  @param btn   需要设置的按钮
 *  @param title 按钮的原始标题
 *  @param count 按钮对应的数字
 */
- (void)setButton:(UIButton *)btn originalTitle:(NSString *)title count:(NSNumber *)count
{
    if (count.intValue > 0) {
        NSString *title = nil;
        if (count.intValue >= 10000) {
            // 超过1万
            double result = count.intValue / 10000.0;
            title = [NSString stringWithFormat:@"%.1f万", result];
            // 只要title中包含.0就将.0替换为空白
            title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        }else
        {
            // 没有超过1万
            title = [count description];
        }
        
        // 有对应的数字
        [btn setTitle: title forState:UIControlStateNormal];
    }else
    {
        // 没有对应的数字
        [btn setTitle:title forState:UIControlStateNormal];
    }
}

#pragma mark - 懒加载
- (NSArray *)buttons
{
    if(!_buttons)
    {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (NSArray *)dividers
{
    if(!_dividers)
    {
        _dividers = [NSMutableArray array];
    }
    return _dividers;
}

@end
