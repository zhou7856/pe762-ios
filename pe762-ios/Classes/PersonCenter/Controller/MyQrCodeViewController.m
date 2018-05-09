//
//  MyQrCodeViewController.m
//  pe762-ios
//
//  Created by Future on 2018/5/8.
//  Copyright © 2018年 zmit. All rights reserved.
//  我的二维码页面

#import "MyQrCodeViewController.h"

@interface MyQrCodeViewController ()
{
    // 二维码
    UIImageView *qrCodeImageView;
}
@end

@implementation MyQrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initQrCodeAPI:@"https://www.baidu.com"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initUI
- (void) initUI{
    // 背景图片
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"24-二维码"]];
    [self.view addSubview:bgImageView];
    bgImageView.userInteractionEnabled = YES;
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    // 点击背景返回上一页
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [bgImageView addGestureRecognizer:tap];
    
    // 二维码背景
    UIButton *backgroundBtn = [[UIButton alloc] init];
    //backgroundBtn.backgroundColor = kRedColor;
    [bgImageView addSubview:backgroundBtn];
    [backgroundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bgImageView).offset(82 * kScreenWidthProportion);
        make.right.mas_equalTo(bgImageView).offset(-82 * kScreenWidthProportion);
        make.top.mas_equalTo(bgImageView).offset(kHeaderHeight + 124 * kScreenHeightProportion);
        make.height.mas_equalTo(213 * kScreenHeightProportion);
    }];
    
    // 边框
    UIView *boderView = [[UIView alloc] init];
    boderView.userInteractionEnabled = NO;
    [boderView setBorder:1 color:kLightGreyColor];
    [backgroundBtn addSubview:boderView];
    [boderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backgroundBtn).offset(8 * kScreenWidthProportion);
        make.right.mas_equalTo(backgroundBtn).offset(-8 * kScreenWidthProportion);
        make.top.mas_equalTo(backgroundBtn).offset(5 * kScreenHeightProportion);
        make.bottom.mas_equalTo(backgroundBtn).offset(-7 * kScreenHeightProportion);
    }];
    
    // icon 49 18
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = [UIImage imageNamed:@"logo_register"];
    [boderView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(boderView).offset(18 * kScreenHeightProportion);
        make.height.mas_equalTo(18 * kScreenHeightProportion);
        make.width.mas_equalTo(49 * kScreenWidthProportion);
        make.centerX.mas_equalTo(boderView);
    }];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"知趣大学专业说";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = FONT(15 * kFontProportion);
    titleLabel.textColor = kLightGreyColor;
    [boderView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconImageView.mas_bottom).offset(12 * kScreenHeightProportion);
        make.height.mas_equalTo(20 * kScreenHeightProportion);
        make.left.right.width.mas_equalTo(boderView);
    }];
    
    // 二维码
    qrCodeImageView = [[UIImageView alloc] init];
    qrCodeImageView.backgroundColor = kRedColor;
    [boderView addSubview:qrCodeImageView];
    [qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(boderView).offset(-8 * kScreenHeightProportion);
        make.width.height.mas_equalTo(115 * kScreenWidthProportion);
        make.centerX.mas_equalTo(boderView);
    }];
}


#pragma mark - 生成二维码API
- (void) initQrCodeAPI:(NSString *) urlStr{
    //获取新的图形验证码
    NSString *url = [NSString stringWithFormat:@"%@", kQrCodeURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *parameters = @{
                                 @"site_url":urlStr
                                 };
    
    // 建立请求访问
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 加载缓冲
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 开始请求访问
    [manager POST:url parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        // 关闭缓冲
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSData *data = [[NSData data] initWithData:responseObject];
        
        UIImage *image = [UIImage imageWithData: data];
        
        qrCodeImageView.image = image;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
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
