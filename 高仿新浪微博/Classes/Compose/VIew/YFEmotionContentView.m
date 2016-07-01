//
//  YFEmotionContentView.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-30.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//


#import "YFEmotionContentView.h"
#import "YFEmotion.h"
#import "YFEmotionButton.h"
#import "YFEmotionPopView.h"
#import "YFEmotionTool.h"


@interface YFEmotionContentView () <UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *divider;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, strong) YFEmotionPopView *popView;

@end

@implementation YFEmotionContentView

- (YFEmotionPopView *)popView
{
    if (!_popView) {
        self.popView = [YFEmotionPopView popView];
    }
    return _popView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        // 1.UIScollView
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        // 只要隐藏了滚动条,那么滚动条控件就不会被创建
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        // 2.pageControl
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        /*
         // 如果截图放大,可以看到小点不是原图片,Pattern这个方法决定了,不管怎么拉伸,他都会把拉伸好的图片再平铺出来,一个图片不够再截取一部分
         pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_keyboard_dot_normal"]];
         pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_keyboard_dot_selected"]];
         // UIPageControl有这两个成员变量,但是是私有的,用KVC
         UIImage*        _currentPageImage;
         UIImage*        _pageImage;
         
         注意:这里可以不加_, 如果是pageImage,相当于点调用setter方法
         pageControl.pageImage = [UIImage imageNamed:@"compose_keyboard_dot_normal"];
         找不到的话,改成员变量,改为_pageImage
         优先级是setter方法,再是_pageImage
         所以效率是_pageImage高
         */
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_normal"] forKey:@"_pageImage"];
        [pageControl setValue:[UIImage imageNamed:@"compose_keyboard_dot_selected"] forKey:@"_currentPageImage"];
        
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
        // 3.分割线
        UIView *divider = [[UIView alloc] init];
        divider.backgroundColor = [UIColor grayColor];
        divider.alpha = 0.5;
        [self addSubview:divider];
        self.divider = divider;
        
        // 3.添加拖拽手势
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

/**
 * 返回loc位置对应的表情按钮
 */
- (YFEmotionButton *)emotionButtonForLoc:(CGPoint)loc
{
    for (YFEmotionButton *emotionButton in self.scrollView.subviews) {
        if (![emotionButton isKindOfClass:[YFEmotionButton class]]) continue;// 过滤删除按钮
        // 让按钮的x值减去一定个数的屏幕宽度
        CGRect frame = emotionButton.frame;
        frame.origin.x -= self.pageControl.currentPage * self.width;
        if (CGRectContainsPoint(frame, loc)) {
            return emotionButton;
        }
    }
    return nil;
}

/**
 * 在表情上面长按并且滑动
 */
- (void)drag:(UILongPressGestureRecognizer *)recognizer
{
    // 手指所在的位置
    CGPoint loc = [recognizer locationInView:recognizer.view];
    // 手指所在的表情按钮
    YFEmotionButton *emotionButton = [self emotionButtonForLoc:loc];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateEnded: // 被迫结束, 比如一个电话打过来
        case UIGestureRecognizerStateCancelled: { // 松开(人为结束)
            [self.popView removeFromSuperview];
            if (emotionButton == nil)  return;
            
            // 发出通知
            [self postEmotionClickNote:emotionButton];
            break;
        }
            
        default: { // 按住
            if (emotionButton == nil) return; // 找不到, 表情键盘外松开
            
            [self.popView popFromEmotionButton:emotionButton];
            break;
        }
    }
}

/**
 * 发出通知
 */
- (void)postEmotionClickNote:(YFEmotionButton *)emotionButton
{
    
    // 存储表情模型到沙盒中
    [YFEmotionTool addRecentEmotion:emotionButton.emotion];
    
    // 发出通知
    NSDictionary *userInfo = @{YFClickedEmotion : emotionButton.emotion};
    [[NSNotificationCenter defaultCenter] postNotificationName:YFEmotionButtonDidClickNotification object:nil userInfo:userInfo];
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    // 如果 "最近""默认"来回点, 这里还是每次都删再增加
    // 不是比较地址, 是比较装的一样
    
//    // 第一种做法:
//    // 移除之前的所有数据控件
//    for (UIView *child in self.scrollView.subviews) {
//        [child removeFromSuperview];
//    }
    
    // 第二种做法:
    // 让数组中的元素都执行removeFromSuperview方法 如果有参数可以加withObject:<#(id)#>
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger count = emotions.count;
    for (NSUInteger i = 0; i < count; i++) {
        // 表情按钮
        YFEmotionButton *emotionButton = [[YFEmotionButton alloc] init];
        emotionButton.emotion = emotions[i];
        [emotionButton addTarget:self action:@selector(emotionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:emotionButton];
        
    }
    
    self.pageControl.numberOfPages = (count + YFEmotionPageSize - 1) / YFEmotionPageSize;
    // 添加删除按钮
    for (NSUInteger i = 0; i < self.pageControl.numberOfPages; i++) {
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
    }
    
    // 重新布局子控件
    // 第一次调的时候有尺寸, 尺寸改变就会调用, 后来只是传新的数据, 尺寸没有改变,不会调layoutSubviews
    [self setNeedsLayout];
    
//    // 重新调东西画东西
//    [self setNeedsDisplay];
}

/**
 *  点击表情按钮
 */
- (void)emotionButtonClick:(YFEmotionButton *)emotionButton
{
    // 发出通知
    [self postEmotionClickNote:emotionButton];
    
    // 在按钮上面显示一个放大镜
    [self.popView popFromEmotionButton:emotionButton];
    
    // 延迟消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
}

/**
 *  点击删除按钮
 */
- (void)deleteButtonClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:YFDeleteButtonDidClickNotification object:nil];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 0.pageControl
    self.pageControl.width = self.width;
    self.pageControl.height = 25;
    self.pageControl.y = self.height - self.pageControl.height;
    
    // 1.scrollView
    self.scrollView.width = self.width;
    self.scrollView.height = self.pageControl.y;
    /*
     //    NSUInteger count = self.scrollView.subviews.count;
     NSUInteger count = self.emotions.count;
     NSUInteger pageCount = (count + YFPageSize - 1) / YFPageSize;
     //    if (count % YFPageSize == 0) {
     //        pageCount = count / YFPageSize;
     //    }else{
     //        pageCount = count / YFPageSize + 1;
     //    }
     self.scrollView.contentSize = CGSizeMake(self.scrollView.width * pageCount, 0);
     */
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * self.pageControl.numberOfPages, 0);
    
    
    // 2.表情
    CGFloat leftMargin = 15;
    CGFloat topMargin = 15;
    CGFloat buttonW = (self.scrollView.width - 2 * leftMargin) / YFEmotionMaxCols;
    CGFloat buttonH = (self.scrollView.height - topMargin) / YFEmotionMaxRows;
    
    // 表情按钮数:count = 全部子控件 - 删除按钮
    NSUInteger count = self.scrollView.subviews.count - self.pageControl.numberOfPages;
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *button = self.scrollView.subviews[i];
        button.width = buttonW;
        button.height = buttonH;
        
        if (i >= YFEmotionPageSize) {
            UIButton *lastButton = self.scrollView.subviews[i - YFEmotionPageSize];
            button.y = lastButton.y;
            button.x = lastButton.x + self.scrollView.width;
        }else{ // 最前面那一页
            NSUInteger row = i / YFEmotionMaxCols;
            NSUInteger col = i % YFEmotionMaxCols;
            button.x = leftMargin + col * buttonW;
            button.y = topMargin + row * buttonH;
        }
    }
    
    // 3.分割线
    self.divider.height = 1;
    self.divider.width = self.width;
    
    // 4.删除按钮
    for (NSUInteger i = count; i < self.scrollView.subviews.count; i++) {
        UIButton *button = self.scrollView.subviews[i];
        button.width = buttonW;
        button.height = buttonH;
        
        if (i == count) {
            button.x = self.scrollView.width - leftMargin -buttonW;
        }else{
            UIButton *lastButton = self.scrollView.subviews[i - 1];
            button.x = lastButton.x + self.scrollView.width;
        }
        button.y = self.scrollView.height - buttonH;
    }
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double pageNo = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(pageNo + 0.5);
}



@end
