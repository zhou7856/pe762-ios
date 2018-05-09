//
//  AboutUsViewController.m
//  pe762-ios
//
//  Created by Future on 2018/5/9.
//  Copyright © 2018年 zmit. All rights reserved.
//  关于我们页面

#import "AboutUsViewController.h"

@interface AboutUsViewController ()<WKUIDelegate>
{
    UIButton *leftBtn;//专业
    UILabel *typeLabel;//页面标题
    
    WKWebView * webView;
}
@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWKWebUI];
    [self initAboutUsAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initWKWebUI{
#pragma mark - 头部
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = kBackgroundWhiteColor;
    
    [self createNavigationTitle:@"关于我们"];
    
#pragma mark - 底部返回
    // 返回
    [self createEndBackView];
    
#pragma mark - 加载内容
    webView = [[WKWebView alloc] init];
    webView.backgroundColor = kBackgroundWhiteColor;
    //- 33 * kScreenHeightProportion
    if (kScreenHeight == 812) {
        webView.frame = CGRectMake(0, kHeaderHeight, kScreenWidth, kScreenHeight - kHeaderHeight - kEndBackViewHeight);
    } else {
        webView.frame = CGRectMake(0, kHeaderHeight, kScreenWidth, kScreenHeight - kHeaderHeight - kEndBackViewHeight);
    }
    [self.view addSubview:webView];
    
}

#pragma mark - 点击事件
- (void)leftBtnAction{
    NSLog(@"专业");
}

#pragma mark - 关于我们API
- (void) initAboutUsAPI{
    NSString *url = [NSString stringWithFormat:@"%@", kAboutUsURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    url = [NSString stringWithFormat:@"%@&id=%@", url, @"1"];
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        //判断有无数据
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            
            if ([errorCode isEqualToString:@"0"]) {
                NSDictionary *dataDict = dict[@"data"];
                NSString *urlStr = [NSString stringWithFormat:@"%@", dataDict[@"url"]];
                NSLog(@"%@", urlStr);
                
                urlStr = [self stitchingTokenAndPlatformForURL:urlStr];
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
                
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
