//
//  YFStatusTextView.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-11.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFStatusTextView.h"
#import "YFTextPart.h"

@implementation YFStatusTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        
        // 清空默认的内边距
        //        self.contentInset = UIEdgeInsetsZero;
        // 注意, 如果仅仅设置UIEdgeInsetsZero还是不能去除左边和右边的间隙
        //        self.textContainerInset = UIEdgeInsetsZero;
        self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
        // 禁止用户输入
        self.editable = NO;
        // 如果设置内容的内边距为负数, 会导致内容显示不出来, 解决该奇葩bug的办法是禁止TextView滚动
        self.scrollEnabled = NO;
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    NSLog(@"%s", __func__);
    
    // 1.获取手指点击的位置
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    
    /*
     现在已经能够获取到指定范围文字的frame, 我们将来只需要设置selectedRange为特殊字符串的范围, 然后计算出特殊字符串的frame; 然后判断手指点击的位置是否在特殊字符串的frame范围内即可
     */
    /*
     self.selectedRange = NSMakeRange(0, 5);
     NSArray *rects = [self selectionRectsForRange:self.selectedTextRange];
     for (int i = 0; i < rects.count; i++) {
     UITextSelectionRect *selectionRect = rects[i];
     
     // 创建一个蒙版盖住选中的范围
     UIView *conver = [[UIView alloc] init];
     conver.frame = selectionRect.rect;
     conver.backgroundColor = [UIColor purpleColor];
     [self addSubview:conver];
     }
     */
    
    NSArray *array =  [self.attributedText attribute:@"specialsParts" atIndex:0 effectiveRange:NULL];
    //    NSLog(@"%@", array);
    
    BOOL contains = NO;
    // 遍历特殊字符范围数组, 设置self.selectedRange属性计算所有特殊字符的frame
    for (YFTextPart *part in array) {
        // 1.设置范围
        self.selectedRange = part.range;
        // 2.获取范围对应的frame
        NSArray *rects = [self selectionRectsForRange:self.selectedTextRange];
        // 清空选中范围
        self.selectedRange = NSMakeRange(0, 0);
        
        // 3.遍历所有特殊字符串的frame
        for (UITextSelectionRect *selectionRect in rects) {
            //            NSLog(@"%@", NSStringFromCGRect(selectionRect.rect));
            
            
            if (selectionRect.rect.size.width == 0 ||
                selectionRect.rect.size.height == 0) {
                continue;
            }
            
            if (CGRectContainsPoint(selectionRect.rect, point)) {
                NSLog(@"点击了高亮范围");
                /*
                 // 创建一个蒙版盖住选中的范围
                 UIView *conver = [[UIView alloc] init];
                 conver.frame = selectionRect.rect;
                 conver.backgroundColor = [UIColor purpleColor];
                 conver.tag = 998;
                 [self insertSubview:conver atIndex:0];
                 break;
                 */
                contains = YES;
                break;
            }
        }
        
        if (contains) {
            for (UITextSelectionRect *selectionRect in rects) {
                if (selectionRect.rect.size.width == 0 ||
                    selectionRect.rect.size.height == 0) {
                    continue;
                }
                // 创建一个蒙版盖住选中的范围
                UIView *conver = [[UIView alloc] init];
                conver.frame = selectionRect.rect;
                conver.backgroundColor = [UIColor purpleColor];
                conver.tag = 998;
                [self insertSubview:conver atIndex:0];
            }
            break;
        }
        
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //    NSLog(@"%s", __func__);
        [self touchesCancelled:touches withEvent:event];
    });
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    NSLog(@"%s", __func__);
    
    for (UIView *subView in self.subviews) {
        if (subView.tag == 998) {
            [subView removeFromSuperview];
        }
    }
}

@end
