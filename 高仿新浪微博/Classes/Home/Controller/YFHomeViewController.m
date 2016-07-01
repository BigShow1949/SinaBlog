//
//  YFHomeViewController.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-29.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFHomeViewController.h"
#import "YFTitleButton.h"
#import "YFPopMenu.h"

#import "YFTitleMenuViewController.h"
#import "YFTitleMenu2ViewController.h"

#import "AFNetworking.h"
#import "YFAccountTool.h"
#import "YFHttpTool.h"
#import "UIImageView+WebCache.h"
#import "YFUser.h"
#import "YFStatus.h"
#import "YFHomeStatusResult.h"
#import "MJExtension.h"
#import "YFPicUrl.h"
#import "MBProgressHUD+MJ.h"
//#import "YFLoadMoreFooter.h"
#import "MJRefresh.h"
#import "YFTableViewCell.h"
#import "YFStatusFrame.h"
#import "YFStatusRequest.h"
#import "YFStatusTool.h"

@interface YFHomeViewController ()<UITableViewDataSource,UITableViewDelegate>

///** 微博数组(里面放的都是YFStatus对象) */
//@property (nonatomic, strong) NSMutableArray *statuses;

/**
 *  微博frame模型, 里面放的都是YFStatusFrame对象
 */
@property (nonatomic, strong) NSMutableArray *statusFrames;

@property (nonatomic, weak) UITableView *tableView;
@end

@implementation YFHomeViewController

- (NSMutableArray *)statusFrames
{
    if (!_statusFrames) {
        _statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏内容
    [self setupNav];
    
    // 添加tableView
    [self setupTableView];
    
    // 增加刷新
    [self setupRefresh];
    
    // 加载用户信息
    [self setupUserInfo];
}

#pragma mark - 导航栏
/**
 *  初始化导航栏内容
 */
- (void)setupNav{
    // 设置导航栏左边
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithBg:@"navigationbar_friendsearch" highBg:@"navigationbar_friendsearch_highlighted" target:self action:@selector(friendSearch)];
    
    // 设置导航栏右边
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithBg:@"navigationbar_pop" highBg:@"navigationbar_pop_highlighted" target:self action:@selector(pop)];
    
    // 设置导航栏中间
    YFTitleButton *titleButton = [[YFTitleButton alloc] init];
    NSString *name = [YFAccountTool account].name;
    [titleButton setTitle:name?name:@"首页" forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
    
}

/**
 *  弹出菜单
 */
- (void)titleClick:(YFTitleButton *)titleButton
{
    // 显示菜单
    // 需要显示的内容
    UIViewController *menuVc = [[YFTitleMenuViewController alloc] init];
    // 将控制器view的自动拉伸属性清空(控制器view的宽度不再会自动拉伸, 可以自由设置)
    menuVc.view.autoresizingMask = UIViewAutoresizingNone;
    menuVc.view.width = 217;
    menuVc.view.height = 250;
    
    // 弹出菜单
    [YFPopMenu popFromView:self.navigationItem.titleView contentVc:menuVc dismiss:^{
        // 切换箭头方向
        titleButton.selected = !titleButton.isSelected;
    }];
    
    // 切换箭头方向
    titleButton.selected = !titleButton.isSelected;
}

/**
 *  左边按钮点击
 */
- (void)friendSearch
{
    YFLog(@"friendSearch---");
}

/**
 *  右边按钮点击
 */
- (void)pop {
    YFLog(@"pop---");
}


#pragma mark - 用户信息
/**
 *  加载用户信息
 */
- (void)setupUserInfo
{
    // 1.创建一个请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    YFAccount *account = [YFAccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 3.发送一个GET请求
    [mgr GET:@"https://api.weibo.com/2/users/show.json" parameters:params
     success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
         YFUser *user = [YFUser objectWithKeyValues:responseObject];
         
         // 设置标题
         YFTitleButton *titleButton = (YFTitleButton *)self.navigationItem.titleView;
         [titleButton setTitle:user.name forState:UIControlStateNormal];
         
         // 存储名字
         if ([account.name isEqualToString:user.name]) return;
         account.name = user.name;
         [YFAccountTool save:account];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         YFLog(@"请求失败 - %@", error);
         
         // 提示错误信息
         [MBProgressHUD showError:@"网络繁忙,请稍后再试"];
     }];
}


#pragma mark - TableView
/**
 *  添加tableView
 */
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor redColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.frame = self.view.bounds;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
}


/**
 *  增加刷新
 */
- (void)setupRefresh
{
    
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewStatus)];
    [self.tableView headerBeginRefreshing];
    
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreStatus)];

}

- (void)refreshing
{
    [self.tableView headerBeginRefreshing];
}

/**
 *  下拉刷新控件进入刷新状态 : 加载更新(时间更晚)的微博数据
 */
- (void)loadNewStatus
{
    // 0. 清空提醒数字
    self.tabBarItem.badgeValue = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    // 1.拼接请求参数
    /*
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [YFAccountTool account].access_token;
    YFStatusFrame *statusFrame = [self.statusFrames firstObject];
    YFStatus *status = statusFrame.status;
    // id类型的对象不能用点语法
    if (status) {
        params[@"since_id"] = @([[status idstr] longLongValue]);
        // since_id	false	int64	若指定此参数，则返回ID比since_id大的微博（即比since_id时间晚的微博），默认为0。
    }
    */
    
    YFStatusRequest *request = [[YFStatusRequest alloc] init];
    request.access_token = [YFAccountTool account].access_token;
    YFStatusFrame *statusFrame = [self.statusFrames firstObject];
    YFStatus *status = statusFrame.status;
    if (status) {
        request.since_id = @([[status idstr] longLongValue]);
    }
    
    
    [YFStatusTool statusWithParams:request success:^(YFHomeStatusResult *result) {
        
        // 通过数据模型创建frame模型
        NSArray *frameModels = [self frameModelsWithStatus:result.statuses];
        // 将最新的微博数据添加到旧数据的最前面
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, frameModels.count)];
        [self.statusFrames insertObjects:frameModels atIndexes:set];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView headerEndRefreshing];
        
        // 提醒
        [self showNewStatusCount:result.statuses.count];
    } failure:^(NSError *error) {
        
        YFLog(@"请求失败 - %@", error);
        
        // 提示错误信息
        [MBProgressHUD showError:@"网络繁忙,请稍后再试"];
        
        // 结束刷新
        [self.tableView headerEndRefreshing];
    }];
    
    /*
    //  2.发送一个GET请求
    [YFHttpTool get:@"https://api.weibo.com/2/statuses/home_timeline.json" params:params success:^(id responseObject) {
        
        // 字典转模型
        YFHomeStatusResult *result = [YFHomeStatusResult objectWithKeyValues:responseObject];
        // 通过数据模型创建frame模型
        NSArray *frameModels = [self frameModelsWithStatus:result.statuses];
        // 将最新的微博数据添加到旧数据的最前面
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, frameModels.count)];
        [self.statusFrames insertObjects:frameModels atIndexes:set];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        //         [control endRefreshing];
        [self.tableView headerEndRefreshing];
        
        // 提醒
        [self showNewStatusCount:result.statuses.count];
        
    } failure:^(NSError *error) {
        
        // 提示错误信息
        [MBProgressHUD showError:@"网络繁忙,请稍后再试"];
        
        // 结束刷新
        [self.tableView headerEndRefreshing];
        
    }];
     */

}

/**
 *  提醒最新的微博数
 */
- (void)showNewStatusCount:(NSUInteger)count
{
    // 1.显示的文字
    NSString *title = @"没有新的微博";
    if (count) {
        title = [NSString stringWithFormat:@"有%zd条新的微博", count];
    }
    
//        [YFStatusBarHUD showSuccess:title];
    // 2.显示形式
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = self.view.width;
    label.height = 35;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.y = -label.height - 64; // 64随便设置的, 为的就是开始, 不要显示label
    [self.view addSubview:label];
    
    [UIView animateWithDuration:1.0 animations:^{
        label.y = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            label.y = -label.height;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

/**
 *  加载最新的微博数据
 */
- (void)loadMoreStatus
{
    
    // 1.拼接请求参数
    /*
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [YFAccountTool account].access_token;
    YFStatusFrame *statusFrame = [self.statusFrames lastObject];
    YFStatus *status = statusFrame.status;
    if (status) {
#warning 这里需要减一吗
        // max_id	若指定此参数，则返回ID小于或等于max_id的微博。
        params[@"max_id"] = @([[status idstr] longLongValue]);
    }
     */
    
    YFStatusRequest *request = [[YFStatusRequest alloc] init];
    request.access_token = [YFAccountTool account].access_token;
    YFStatusFrame *statusFrame = [self.statusFrames lastObject];
    YFStatus *status = statusFrame.status;
    if (status) {
        request.max_id =  @([[status idstr] longLongValue]);;
    }
    
    [YFStatusTool statusWithParams:request success:^(YFHomeStatusResult *result) {
        // 通过数据模型创建frame模型
        NSArray *frameModels = [self frameModelsWithStatus:result.statuses];
        // 将最新的微博数据添加到旧数据的最后面
        [self.statusFrames addObjectsFromArray:frameModels];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView footerEndRefreshing];
    } failure:^(NSError *error) {
        YFLog(@"请求失败 - %@", error);
        
        // 提示错误信息
        [MBProgressHUD showError:@"网络繁忙,请稍后再试"];
        
        // 结束刷新
        [self.tableView footerEndRefreshing];
    }];
    
    /*
    
    // 2.发送一个GET请求
    [YFHttpTool get:@"https://api.weibo.com/2/statuses/friends_timeline.json" params:params success:^(id responseObject) {
        
        // 字典转模型
        YFHomeStatusResult *result = [YFHomeStatusResult objectWithKeyValues:responseObject];
        
        // 通过数据模型创建frame模型
        NSArray *frameModels = [self frameModelsWithStatus:result.statuses];
        // 将最新的微博数据添加到旧数据的最后面
        [self.statusFrames addObjectsFromArray:frameModels];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        self.tableView.tableFooterView.hidden = YES;
        
    } failure:^(NSError *error) {
        
        // 提示错误信息
        [MBProgressHUD showError:@"网络繁忙,请稍后再试"];
        
        // 结束刷新
        self.tableView.tableFooterView.hidden = YES;
        
    }];
     
     */
    
}

/**
 *  根据模型数组转换frame模型数组
 *
 *  @param statuses 模型数组
 *
 *  @return frame模型数组
 */
- (NSArray *)frameModelsWithStatus:(NSArray *)statuses
{
    // 通过数据模型创建frame模型
    NSMutableArray *frameModels = [NSMutableArray arrayWithCapacity:statuses.count];
    for (YFStatus *status in statuses) {
        YFStatusFrame *frame = [[YFStatusFrame alloc] init];
        frame.status = status;
        [frameModels addObject:frame];
    }
    return [frameModels copy];
}




#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.statusFrames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1.创建cell
    YFTableViewCell *cell = [YFTableViewCell  cellWithTableview:tableView];
    // 2.设置frame模型给cell
    cell.statusFrame = self.statusFrames[indexPath.row];
    // 3.返回cell
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  告诉系统每一行cell有多高
 *  @return 当前航对应的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取出对应行的frame模型
    YFStatusFrame *frame = self.statusFrames[indexPath.row];
    // 2.返回当前行对应的高度
    return frame.cellHeight;
}

//#pragma mark - Table view delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (self.statuses.count == 0 || self.tableView.tableFooterView.hidden == NO) return;
//    
//    // 当scrollView滚动到最底部时contentOffset.y值
//    CGFloat judgeY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
//
//    if (scrollView.contentOffset.y >= judgeY) {
//        self.tableView.tableFooterView.hidden = NO;
//        
//        // 发送请求给服务器, 加载更多的微博数据
//        [self loadMoreStatus];
//    }
//}

@end
