//
//  SettingViewController.m
//  pe762-ios
//
//  Created by wsy on 2018/4/23.
//  Copyright © 2018年 zmit. All rights reserved.
//  设置页面

#import "SettingViewController.h"
#import "AudioPlayViewController.h"

@interface SettingViewController ()
{
//    UIButton *messageBtn; //消息按钮
}
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTabBarView:NO];
}

- (void)dealloc {
    NSLog(@"页面销毁了");
}

- (void)initNav {
    self.view.backgroundColor = RGB(243, 243, 243);
    [self createNavigationTitle:@"设置"];
    
//    UIImageView *messageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(275 * kScreenWidthProportion, kStatusHeight + 12, 18, 20)];
//    messageImageView.image = [UIImage imageNamed:@"Layer_1_1_"];
//    [self.view addSubview:messageImageView];
//
//    messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(270 * kScreenWidthProportion, kStatusHeight, 30, 44)];
//    [messageBtn addTarget:self action:@selector(messageBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:messageBtn];
    
    [self createEndBackView];
}

- (void)initUI {
    {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 20 * kScreenWidthProportion + kHeaderHeight, kScreenWidth, 40 * kScreenWidthProportion)];
        [self.view addSubview:contentView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * kScreenWidthProportion, 0 * kScreenWidthProportion, 100 * kScreenWidthProportion, 40 * kScreenWidthProportion)];
        [titleLabel setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentLeft font:13];
        titleLabel.text = @"清空下载缓存";
        [contentView addSubview:titleLabel];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(295 * kScreenWidthProportion, 0, 6 * kScreenWidthProportion, 9 * kScreenWidthProportion)];
        iconImageView.image = [UIImage imageNamed:@"Path 185"];
        iconImageView.centerY = titleLabel.centerY;
        [contentView addSubview:iconImageView];
        
        UIView *endLineView = [UIView viewWithFrame:CGRectMake(15 * kScreenWidthProportion, contentView.height - 1, 290 * kScreenWidthProportion, 1) backgroundColor:kLineGrayColor];
        [contentView addSubview:endLineView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            NSLog(@"清空下载缓存");
        }];
        [contentView addGestureRecognizer:tap];
    }
    
    {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 60 * kScreenWidthProportion + kHeaderHeight, kScreenWidth, 40 * kScreenWidthProportion)];
        [self.view addSubview:contentView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * kScreenWidthProportion, 0 * kScreenWidthProportion, 100 * kScreenWidthProportion, 40 * kScreenWidthProportion)];
        [titleLabel setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentLeft font:13];
        titleLabel.text = @"关于知趣";
        [contentView addSubview:titleLabel];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(295 * kScreenWidthProportion, 0, 6 * kScreenWidthProportion, 9 * kScreenWidthProportion)];
        iconImageView.image = [UIImage imageNamed:@"Path 185"];
        iconImageView.centerY = titleLabel.centerY;
        [contentView addSubview:iconImageView];
        
        UIView *endLineView = [UIView viewWithFrame:CGRectMake(15 * kScreenWidthProportion, contentView.height - 1, 290 * kScreenWidthProportion, 1) backgroundColor:kLineGrayColor];
        [contentView addSubview:endLineView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            NSLog(@"关于知趣");
        }];
        [contentView addGestureRecognizer:tap];
    }
    
    {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 100 * kScreenWidthProportion + kHeaderHeight, kScreenWidth, 40 * kScreenWidthProportion)];
        [self.view addSubview:contentView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * kScreenWidthProportion, 0 * kScreenWidthProportion, 100 * kScreenWidthProportion, 40 * kScreenWidthProportion)];
        [titleLabel setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentLeft font:13];
        titleLabel.text = @"版本信息";
        [contentView addSubview:titleLabel];
        
//        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(295 * kScreenWidthProportion, 0, 6 * kScreenWidthProportion, 9 * kScreenWidthProportion)];
//        iconImageView.image = [UIImage imageNamed:@"Path 185"];
//        iconImageView.centerY = titleLabel.centerY;
//        [contentView addSubview:iconImageView];
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSLog(@"当前应用软件版本:%@",appCurVersion);
        
        UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(240 * kScreenWidthProportion, 0, 60 * kScreenWidthProportion, 20 * kScreenWidthProportion)];
        versionLabel.centerY = titleLabel.centerY;
        [versionLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentRight font:13];
        versionLabel.text = appCurVersion;
        [contentView addSubview:versionLabel];
        
        UIView *endLineView = [UIView viewWithFrame:CGRectMake(15 * kScreenWidthProportion, contentView.height - 1, 290 * kScreenWidthProportion, 1) backgroundColor:kLineGrayColor];
        [contentView addSubview:endLineView];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
//        [[tap rac_gestureSignal] subscribeNext:^(id x) {
//            NSLog(@"版本信息");
//        }];
//        [contentView addGestureRecognizer:tap];
    }
    
    UIButton *quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20 * kScreenWidthProportion, 160 * kScreenWidthProportion + kHeaderHeight, 280 * kScreenWidthProportion, 40 * kScreenWidthProportion)];
    [quitBtn setTitle:@"退出登录" forState:0];
    [quitBtn setTitleColor:kWhiteColor forState:0];
    quitBtn.titleLabel.font = FONT(13 * kFontProportion);
    quitBtn.backgroundColor = kRedColor;
    [self.view addSubview:quitBtn];
    [quitBtn addTarget:self action:@selector(quitBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

//#pragma makr - 消息点击
//- (void)messageBtnAction {
//
//}

#pragma mark - 退出登录
- (void)quitBtnAction {
//    [self.navigationController pushViewController:[AudioPlayViewController new] animated:YES];
    NSString *url = [NSString stringWithFormat:@"%@",kLogoutURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        //判断有无数据
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            if ([errorCode isEqualToString:@"-1"]){
                //判断当前是不是登陆页面
                if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[LoginViewController class]]) {
                    return;
                }
                
                //未登陆
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                
                [self.navigationController pushViewController:loginVC animated:YES];
                return;
            }
            
            if ([errorCode isEqualToString:@"0"]) {
//                NSDictionary *dataDic = dict[@"data"];
                //处理数据
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"token"];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}


- (void)shareBtnAction{
    NSLog(@"分享");
}

- (void)likeBtnAction{
    NSLog(@"喜欢");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
