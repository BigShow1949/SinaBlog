//
//  YFTableViewCell.h
//  高仿新浪微博
//
//  Created by 杨帆 on 15-7-6.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YFStatusFrame;
@interface YFTableViewCell : UITableViewCell
+ (instancetype)cellWithTableview:(UITableView *)tableview;

#warning 注意, 变量名不要和系统自带的属性重名, 不然会引发一些未知的bug
@property (nonatomic, strong) YFStatusFrame *statusFrame;
@end
