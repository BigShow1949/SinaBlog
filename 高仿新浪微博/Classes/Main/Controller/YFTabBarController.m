//
//  YFTabBarController.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-29.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFTabBarController.h"
#import "YFHomeViewController.h"
#import "YFMessageCenterViewController.h"
#import "YFDiscoverViewController.h"
#import "YFProfileViewController.h"
#import "YFTabBar.h"
#import "YFHttpTool.h"
#import "YFAccount.h"
#import "YFAccountTool.h"

@interface YFTabBarController ()

@property (nonatomic, strong) YFHomeViewController *home;
@property (nonatomic, strong) YFMessageCenterViewController *message;
@property (nonatomic, strong) YFDiscoverViewController *dicover;
@property (nonatomic, strong) YFProfileViewController *profile;

@end

@implementation YFTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加子控制器
    self.home = [self addOneChildVcClass:[YFHomeViewController class] title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    self.message = [self addOneChildVcClass:[YFMessageCenterViewController class] title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    self.dicover = [self addOneChildVcClass:[YFDiscoverViewController class] title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    self.profile = [self addOneChildVcClass:[YFProfileViewController class] title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    // 替换tabbar
    //    self.tabBar = [[YFTabBar alloc] init];
    //  KVC == key value coding
    [self setValue:[[YFTabBar alloc] init] forKeyPath:@"tabBar"];
    
    // 开启定时器时时获取未读数
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getUnReadCount) userInfo:nil repeats:YES];
    
    self.delegate = self;
}

- (void)getUnReadCount{

    NSString *url = @"https://rm.api.weibo.com/2/remind/unread_count.json";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"access_token"] = [YFAccountTool account].access_token;
    dict[@"uid"] =  [YFAccountTool account].uid;
    
    [YFHttpTool get:url params:dict success:^(id responseObject) {
        NSLog(@"responseObject = %@", responseObject[@"status"]);
        
        
        // 1.获取服务器返回的微博未读数
        NSNumber *count = responseObject[@"status"];
//        count = @2;
        // 2.判断是否有未读微博
        if (count.intValue > 0) {
            
            // 3.设置item
            self.home.tabBarItem.badgeValue = [count description];
            // 设置提醒数字
            // 注意: 在iOS8以后, 要想显示提醒, 必须申请权限
            YFLog(@"count --- %@", count);
            [UIApplication sharedApplication].applicationIconBadgeNumber = count.intValue;
        }
    } failure:^(NSError *error) {
        YFLog(@"失败了");
    }];
    
}

/**
 * 添加一个子控制器
 * @param vcClass : 子控制器的类名
 * @param title : 标题
 * @param image : 图片
 * @param selectedImage : 选中的图片
 */
- (UIViewController *)addOneChildVcClass:(Class)vcClass title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    UIViewController *vc = [[vcClass alloc] init];
    [self addOneChildVc:vc title:title image:image selectedImage:selectedImage];
    
    return vc;
}

/**
 * 添加一个子控制器
 * @param vc : 子控制器
 * @param title : 标题
 * @param image : 图片
 * @param selectedImage : 选中的图片
 */
- (void)addOneChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    [vc.tabBarItem setTitleTextAttributes:@{
                                            NSForegroundColorAttributeName : [UIColor orangeColor]
                                            } forState:UIControlStateSelected];
    // 同时设置tabbar每个标签的文字 和 navigationBar的文字
    vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    vc.view.backgroundColor = [UIColor blueColor];
    
    // 包装一个导航控制器后,再成为tabbar的子控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}


#pragma mark - UITabBarControllerDelegate
// 只要点击了对应的tabbar就会调用
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController;
{
        YFLog(@"%@----", viewController);
    // 0. 获取当前点击的控制器
    UINavigationController *nav = (UINavigationController *)viewController;
    UIViewController *vc = nav.topViewController;
    
    // 1.判断当前点击的是否是首页
    // 判断当前是否有提醒数字
    if ([vc isKindOfClass:[YFHomeViewController class]] &&
        vc.tabBarItem.badgeValue.intValue > 0) {
        NSLog(@"下拉刷新");
        [self.home refreshing];
    }else
    {
        NSLog(@"滚动到顶部");
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.home.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}
@end
