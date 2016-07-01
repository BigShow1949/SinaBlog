//
//  YFComposeViewController.m
//  高仿新浪微博
//
//  Created by 杨帆 on 15-6-30.
//  Copyright (c) 2015年 杨帆_company. All rights reserved.
//

#import "YFComposeViewController.h"
#import "YFAccountTool.h"
#import "YFHttpTool.h"
//#import "AFNetworking.h"
#import "YFEmotionKeyboard.h"
#import "YFEmotion.h"
#import "YFEmotionAttachment.h"
#import "YFEmotionTextView.h"
#import "YFComposeToolbar.h"
#import "YFComposePhotosView.h"
#import "QBImagePickerController.h"

@interface YFComposeViewController ()<UITextViewDelegate,YFComposeToolbarDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,QBImagePickerControllerDelegate>
@property (nonatomic, weak) YFEmotionTextView *textView;
@property (nonatomic, strong) YFEmotionKeyboard *keyboard;
@property (nonatomic, strong) YFComposePhotosView *photosView;
@property (nonatomic, strong) YFComposeToolbar *toolbar;
@property (nonatomic, strong) YFComposeToolbar *tempToolbar;


@end

@implementation YFComposeViewController

- (YFComposePhotosView *)photosView
{
    if (!_photosView) {
        self.photosView = [[YFComposePhotosView alloc] init];
        self.photosView.y = 100;
        self.photosView.width = self.view.width;
        self.photosView.height = self.view.height;
        [self.textView addSubview:self.photosView];
    }
    return _photosView;
}

- (YFEmotionKeyboard *)keyboard
{
    if (!_keyboard) {
        self.keyboard = [[YFEmotionKeyboard alloc] init];
        self.keyboard.height = 216;
    }
    return _keyboard;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏内容
    [self setupNav];
    
    // 添加输入框
    [self setupTextView];
    
}

// 写在setupNav里不好使, ios8里不行, ios7,6可能好使
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 如果发的微博内容就是文字? 这样写也不好
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;

    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.textView resignFirstResponder];
}

/**
 *  添加输入框
 */
- (void)setupTextView
{
    YFEmotionTextView *textView = [[YFEmotionTextView alloc] init];
    textView.placehoder = @"分享新鲜事...140个字内";
    textView.frame = self.view.bounds;
    textView.font = [UIFont systemFontOfSize:15];
    textView.alwaysBounceVertical = YES; // 垂直方向上永远有弹簧效果
    textView.delegate = self;
    self.textView = textView;
    [self.view addSubview:textView];
    
    // 设置键盘上面的工具条
    YFComposeToolbar *toolbar = [[YFComposeToolbar alloc] init];
    self.toolbar = toolbar;
    toolbar.height = 44;
    toolbar.delegate = self;
    self.textView.inputAccessoryView = toolbar;
    
    YFComposeToolbar *tempToolbar = [[YFComposeToolbar alloc] init];
    tempToolbar.height = toolbar.height;
    tempToolbar.delegate = self;
    tempToolbar.width = self.view.width;
    tempToolbar.y = self.view.height - tempToolbar.height;
    [self.view addSubview:tempToolbar];
    self.tempToolbar = tempToolbar;
    
    // 监听键盘内部删除按钮点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self.textView selector:@selector(deleteBackward) name:YFDeleteButtonDidClickNotification object:nil];
    // 监听键盘内部表情按钮点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionButtonClick:) name:YFEmotionButtonDidClickNotification object:nil];
}

- (void)deleteButtonDidClick
{
    [self.textView deleteBackward];
}

- (void)emotionButtonClick:(NSNotification *)note
{
    // 插入表情
    [self.textView insertEmotion:note.userInfo[YFClickedEmotion]];
    
    // 改变文字
    [self textViewDidChange:self.textView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.textView];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  设置导航栏内容
 */
- (void)setupNav
{
    // 统一设置UIBarButtonItem的主题
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:@{
                                   NSForegroundColorAttributeName : [UIColor orangeColor]
                                   } forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{
                                   NSForegroundColorAttributeName : [UIColor lightGrayColor]
                                   } forState:UIControlStateDisabled];
    
    // 默认是clearColor
    self.view.backgroundColor = [UIColor whiteColor];
    // 导航栏内容
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];

    
    // 标题
    NSString *prefix = @"发微博";
    NSString *name = [YFAccountTool account].name;
    if (name) {
        UILabel *label = [[UILabel alloc] init];
        self.navigationItem.titleView = label;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.height = 44;
        
        NSString *text = [NSString stringWithFormat:@"%@\n%@", prefix, name];
        // 创建可变的属性文字
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
        // 设置属性
        [string addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17] range:NSMakeRange(0, prefix.length)];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[text rangeOfString:name]];
        label.attributedText = string;
    } else {
        self.title = prefix;
    }
}

/**
 *  取消
 */
- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  发送
 */
- (void)send
{
    // 0.关闭控制器
    [self cancel];
    
    // 提醒
    [YFStatusBarHUD showLoading:@"正在发布微博中..."];
    
//    // 1.创建一个请求管理者
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [YFAccountTool account].access_token;
    params[@"status"] = self.textView.emotionText;
    
    // 3.发送一个POST请求
    NSUInteger count = self.photosView.images.count;
    if (count) {
//        [self sendWithImage:mgr params:params];
        [self sendWithImage:params];
    } else {
//        [self sendWithoutImage:mgr params:params];
        [self sendWithoutImage:params];

    }

}

/**
 *  发布有图片的微博
 */
//- (void)sendWithImage:(AFHTTPRequestOperationManager *)mgr params:(NSMutableDictionary *)params
//{
- (void)sendWithImage:(NSMutableDictionary *)params{
    // 封装前
//    [mgr POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        // 文件数据 , 新浪接口只能上传一张
//        UIImage *image = [self.photosView.images firstObject];
//        NSData *data = UIImageJPEGRepresentation(image, 0.5);
//        
//        // 拼接文件数据, pic 服务器字段, image/jpeg固定格式 test.jpg自己取的名字
//        [formData appendPartWithFileData:data name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];
//    } success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
//        [YFStatusBarHUD showSuccess:@"发布成功"];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [YFStatusBarHUD showError:@"网络繁忙,请稍后再试"];
//    }];
    
    // 封装后
    [YFHttpTool post:@"https://upload.api.weibo.com/2/statuses/upload.json" params:params buildFile:^(YFHttpFileManager *manager) {
        // 文件参数
        NSData *data = UIImageJPEGRepresentation([self.photosView.images firstObject], 0.5);
        [manager appendFileData:data name:@"pic" filename:@"123.jpg" mimeType:@"image/jpeg"];
    } success:^(id responseObject) {
        [YFStatusBarHUD showSuccess:@"发布成功"];
    } failure:^(NSError *error) {
        [YFStatusBarHUD showError:@"网络繁忙,请稍后再试"];
    }];
}

/**
 *  发布没有图片的微博
 */
//- (void)sendWithoutImage:(AFHTTPRequestOperationManager *)mgr params:(NSMutableDictionary *)params
- (void)sendWithoutImage:(NSMutableDictionary *)params
{
    // 封装前
//    [mgr POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params
//      success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
//          [YFStatusBarHUD showSuccess:@"发布成功"];
//      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//          [YFStatusBarHUD showError:@"网络繁忙,请稍后再试"];
//      }];
    
    // 封装后
    [YFHttpTool post:@"https://api.weibo.com/2/statuses/update.json" params:params
             success:^(id responseObject) {
                 [YFStatusBarHUD showSuccess:@"发布成功"];
             } failure:^(NSError *error) {
                 [YFStatusBarHUD showError:@"网络繁忙,请稍后再试"];
             }];
}


#pragma mark - <UITextViewDelegate>
- (void)textViewDidChange:(UITextView *)textView
{
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    YFLog(@"滚动了----");
    [self.textView resignFirstResponder];
}

#pragma mark - YFComposeToolbarDelegate
- (void)composeToolbar:(YFComposeToolbar *)composeToolbar didClickButton:(YFComposeToolbarButtonType)buttonType{

    switch (buttonType) {
        case YFComposeToolbarButtonTypeCamera:
            [self openCamera];
            break;
            
        case YFComposeToolbarButtonTypePicture:
            [self openAlbum];
            break;
            
        case YFComposeToolbarButtonTypeMention:
            YFLog(@"@");
            break;
            
        case YFComposeToolbarButtonTypeTrend:
            YFLog(@"#");
            break;
            
        case YFComposeToolbarButtonTypeEmotion:
            [self switchKeyboard];
            break;
    }
}

/**
 * 打开照相机
 */
- (void)openCamera
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}

/**
 * 打开相册
 */
- (void)openAlbum
{
    //    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    //    // PhotoLibrary 的范围 > SavedPhotosAlbum
    //    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    ipc.delegate = self;
    //    [self presentViewController:ipc animated:YES completion:nil];
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.limitsMaximumNumberOfSelection = YES;
    imagePickerController.maximumNumberOfSelection = 6;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

/**
 * 切换键盘
 */
- (void)switchKeyboard
{
    [self.textView resignFirstResponder];
    
    if (self.textView.inputView) { // 正在使用自定义键盘,切换为系统键盘
        self.textView.inputView = nil;
        
        // 显示表情图片
        [self.toolbar switchEmotionButtonImage:YES];
        [self.tempToolbar switchEmotionButtonImage:YES];
    } else {  // 正在使用系统键盘,切换为自定义键盘
        self.textView.inputView = self.keyboard;
        
        // 显示键盘图片
        [self.toolbar switchEmotionButtonImage:NO];
        [self.tempToolbar switchEmotionButtonImage:NO];

    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textView becomeFirstResponder];
    });
}

#pragma mark - <UIImagePickerControllerDelegate>
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//}

#pragma mark - <QBImagePickerController>
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    // 关闭控制器
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
    // 选择的图片
    for (NSDictionary *dict in info) {
        [self.photosView addImage:dict[UIImagePickerControllerOriginalImage]];
    }
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    // 关闭控制器
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

@end
