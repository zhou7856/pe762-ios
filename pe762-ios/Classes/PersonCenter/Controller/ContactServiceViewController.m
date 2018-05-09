//
//  ContactServiceViewController.m
//  pe762-ios
//
//  Created by Future on 2018/4/24.
//  Copyright © 2018年 zmit. All rights reserved.
//  联系客服页面

#import "ContactServiceViewController.h"

@interface ContactServiceViewController ()
{
    UIButton *majorBtn;//专业
    UILabel *typeLabel;//页面标题
    UIButton *noticeBtn;//消息通知
    UILabel *phoneLabel;
    UILabel *emailLabel;
}
@end

@implementation ContactServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 加载数据
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI{
#pragma mark - 头部、底部
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = kBackgroundWhiteColor;
    
    [self createNavigationTitle:@"联系客服"];
    
    //底部
    [self createEndBackView];
    
#pragma mark - 标语
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kHeaderHeight, kScreenWidth, 54 * kScreenHeightProportion)];
    titleLabel.textColor = kBlackLabelColor;
    titleLabel.font = FONT(14 * kFontProportion);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"您可以通过以下方式联系我们的客服";
    titleLabel.backgroundColor = kBackgroundWhiteColor;
    [self.view addSubview:titleLabel];
    CGFloat titleLabelWidth = [titleLabel getTitleTextWidth:titleLabel.text font:FONT(14 * kFontProportion)];

#pragma mark - 联系电话
    UIView *contactPhoneView = [[UIView alloc] init];
    contactPhoneView.backgroundColor = kWhiteColor;
    [contactPhoneView setCornerRadius:4.0f];
    [self.view addSubview:contactPhoneView];
    [contactPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_centerX).offset(-titleLabelWidth/2.0);
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(titleLabelWidth, 46 * kScreenWidthProportion));
    }];

    UIImageView *phoneIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_service"]];
    //phoneIconImageView.backgroundColor = kRedColor;
    [phoneIconImageView setCornerRadius:16 * kScreenWidthProportion];
    [contactPhoneView addSubview:phoneIconImageView];
    [phoneIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10 * kScreenWidthProportion);
        make.top.mas_equalTo(contactPhoneView.mas_centerY).offset(-16 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(32 * kScreenWidthProportion, 32 * kScreenWidthProportion));
    }];
    
    phoneLabel = [[UILabel alloc] init];
    phoneLabel.textColor = RGB(124, 38, 191);
    phoneLabel.font = FONT(16 * kFontProportion);
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    phoneLabel.text = @"400-855-0958";
    [contactPhoneView addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneIconImageView.mas_right).offset(14 * kScreenWidthProportion);
        make.top.mas_equalTo(contactPhoneView.mas_centerY).offset(-16 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(160 * kScreenWidthProportion, 32 * kScreenWidthProportion));
    }];
    
#pragma mark - 联系邮箱
    UIView *contactEmailView = [[UIView alloc] init];
    contactEmailView.backgroundColor = kWhiteColor;
    [contactEmailView setCornerRadius:4.0f];
    [self.view addSubview:contactEmailView];
    [contactEmailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contactPhoneView.mas_left);
        make.top.mas_equalTo(contactPhoneView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(titleLabelWidth, 46 * kScreenWidthProportion));
    }];
    
    UIImageView *emailIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_mailbox"]];
    //emailIconImageView.backgroundColor = kRedColor;
    [emailIconImageView setCornerRadius:16 * kScreenWidthProportion];
    [contactEmailView addSubview:emailIconImageView];
    [emailIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10 * kScreenWidthProportion);
        make.top.mas_equalTo(contactEmailView.mas_centerY).offset(-16 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(32 * kScreenWidthProportion, 32 * kScreenWidthProportion));
    }];
    
    emailLabel = [[UILabel alloc] init];
    emailLabel.textColor = RGB(124, 38, 191);
    emailLabel.font = FONT(16 * kFontProportion);
    emailLabel.textAlignment = NSTextAlignmentLeft;
    emailLabel.text = @"efeu@izhiqu.com.cn";
    [contactEmailView addSubview:emailLabel];
    [emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(emailIconImageView.mas_right).offset(14 * kScreenWidthProportion);
        make.top.mas_equalTo(contactEmailView.mas_centerY).offset(-16 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(160 * kScreenWidthProportion, 32 * kScreenWidthProportion));
    }];
}

#pragma mark - 点击事件
- (void)initData {
    NSString *url = [NSString stringWithFormat:@"%@",kServiceWayTwigURL];
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
                NSDictionary *dataDic = dict[@"data"];
                //处理数据
                NSDictionary *infoDic = dataDic[@"info"];
                phoneLabel.text = [NSString stringWithFormat:@"%@", infoDic[@"service_tel"]];
                emailLabel.text = [NSString stringWithFormat:@"%@", infoDic[@"service_email"]];
                [emailLabel fontForLabel:16];
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
