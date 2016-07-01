//
//  YFOAuthViewController.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-29.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFOAuthViewController.h"
#import "AFNetworking.h"
#import "YFTabBarController.h"
#import "YFAccountTool.h"
#import "MBProgressHUD+MJ.h"

@interface YFOAuthViewController ()<UIWebViewDelegate>
@property (nonatomic, weak) UIWebView *webView;
// 4240023836
@end

@implementation YFOAuthViewController

- (UIWebView *)webView{

    if (_webView == nil) {
        UIWebView *webView = [[UIWebView alloc] init];
        self.webView = webView;
        webView.delegate = self;
        webView.backgroundColor = [UIColor redColor];
        webView.frame = YFScreenBounds;
        [self.view addSubview:webView];
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@", YFAppKey, YFRedirectUri]];
    //    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}

#pragma mark - <UIWebViewDelegate>
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUD];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [MBProgressHUD showMessage:@"正在加载中..."];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD hideHUD];
}

/**
 *  每当webView想发送请求之前都会调用(能在这个方法中拦截webView的所有请求)
 *
 *  @param request        webView想发送的请求
 *
 *  @return YES : 允许加载这个请求, NO : 禁止加载这个请求
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    // 1.URL字符串
    NSString *url = request.URL.absoluteString;
    
    // 2.查找URL中是否有code=
    NSRange range = [url rangeOfString:@"code="];
    //    if (range.location != NSNotFound)
    if (range.length) { // 已经找到code=
        // 3.截取code
        NSString *code = [url substringFromIndex:range.location + range.length];
        
        // 4.利用code换取access_token
        [self accessTokenWithCode:code];
        return NO;
    }
    
    return YES;
}

/**
 *  利用code换取access_token
 */
- (void)accessTokenWithCode:(NSString *)code
{
    // URL : https://api.weibo.com/oauth2/access_token
    // 请求方式 : POST
    /*请求参数
     client_id	申请应用时分配的AppKey。
     client_secret	申请应用时分配的AppSecret。
     grant_type	请求的类型，填写authorization_code
     code	调用authorize获得的code值。
     redirect_uri 回调地址，需需与注册应用里的回调地址一致。
     */
    /*返回结果
     {
     "access_token": "ACCESS_TOKEN",
     "expires_in": 1234,
     "remind_in":"798114",
     "uid":"12341234"
     }
     */
    
    // 1.创建一个请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = YFAppKey;
    params[@"client_secret"] = YFAppSecret;
    params[@"grant_type"] = @"authorization_code";
    params[@"code"] = code;
    params[@"redirect_uri"] = YFRedirectUri;
    
    NSLog(@"发送请求外面----");
    // 3.发送一个POST请求
    [mgr POST:@"https://api.weibo.com/oauth2/access_token" parameters:params
      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
          
          // 字典转为模型
          YFAccount *account = [YFAccount accountWithDict:responseObject];
          
          // 存储账号信息
          [YFAccountTool save:account];
          
          // 切换到主控制器
          
          /**
           1.modal : 可逆, 上一个控制器还在内存中
           2.push : 可逆, 上一个控制器还在内存中, 需要UINavigationController的支持
           3.rootViewController : 不可逆, 上一个控制器不在内存中
           */
          NSLog(@"发送请求里面----");
          [UIApplication sharedApplication].keyWindow.rootViewController = [[YFTabBarController alloc] init];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          YFLog(@"请求失败 - %@", error);
    }];
    
    /**
     错误信息:
     Request failed: unacceptable content-type: text/plain
     
     新浪服务器返回给AFN的数据格式是text/plain
     AFN默认不接收text/plain格式的数据
     */
}

// "access_token" = "2.00vWf4GE3CDS8E082f1f060fSdU2jD"

// 一个accessToken对应着 1个用户 + 1个应用
// 3个用户 给 1个应用授权



@end
