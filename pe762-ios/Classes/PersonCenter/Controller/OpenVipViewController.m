//
//  OpenVipViewController.m
//  pe762-ios
//
//  Created by Future on 2018/5/10.
//  Copyright © 2018年 zmit. All rights reserved.
//  开通VIP会员页面

#import "OpenVipViewController.h"
#import "PayVipPopView.h"

@interface OpenVipViewController ()
{
    // 用户名
    UILabel *nameLabel;
    // 开通费用金额
    UILabel *vipMoneyLabel;
    // 会员权益简介
    UILabel *powerDetailLabel;
    //
    NSString *vipmoney;
}
@end

@implementation OpenVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
    vipmoney = @"0.00";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initRechargeVipTwigAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initUI
- (void) initUI{
#pragma mark - 头部、底部
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = kBackgroundWhiteColor;
    
    [self createNavigationTitle:@"开通VIP会员"];
    
    [self createEndBackView];
    
#pragma mark - 颈部 - 用户名、宣传语
    // 用户名
    nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"用户名";
    nameLabel.textColor = kBlackLabelColor;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = FONT(13 * kFontProportion);
    [self.view addSubview:nameLabel];
    
    // 描述语
    UILabel *desLabel = [[UILabel alloc] init];
    desLabel.text = @"开通会员，免费收听所有音频";
    desLabel.textColor = kBlackLabelColor;
    desLabel.textAlignment = NSTextAlignmentCenter;
    desLabel.font = FONT(14 * kFontProportion);
    [self.view addSubview:desLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kHeaderHeight + 16 * kScreenHeightProportion);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(17 * kScreenHeightProportion);
    }];
    
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(6 * kScreenHeightProportion);
        make.left.right.mas_equalTo(nameLabel);
        make.height.mas_equalTo(16 * kScreenHeightProportion);
    }];
    
#pragma mark - 中间
    // 一级白色内容背景
    UIView *oneContenView = [[UIView alloc] init];
    oneContenView.backgroundColor = kWhiteColor;
    [self.view addSubview:oneContenView];
    
    [oneContenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(desLabel.mas_bottom).offset(24 * kScreenHeightProportion);
        make.left.mas_equalTo(nameLabel).offset(10 * kScreenWidthProportion);
        make.right.mas_equalTo(nameLabel).offset(-10 * kScreenWidthProportion);
        make.height.mas_equalTo(315 * kScreenHeightProportion);
    }];
    
    // 17 19  33 12
    UILabel *vipTitleLabel = [[UILabel alloc] init];
    vipTitleLabel.text = @"一年期会员";
    vipTitleLabel.textColor = kBlackLabelColor;
    vipTitleLabel.textAlignment = NSTextAlignmentLeft;
    vipTitleLabel.font = FONT(13 * kFontProportion);
    [oneContenView addSubview:vipTitleLabel];
    
    UIImageView *vipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 129"]];
    [oneContenView addSubview:vipImageView];
    
    vipMoneyLabel = [[UILabel alloc] init];
    //vipMoneyLabel.text = @"299元";
    vipMoneyLabel.textColor = kBlackLabelColor;
    vipMoneyLabel.textAlignment = NSTextAlignmentRight;
    vipMoneyLabel.font = FONT(13 * kFontProportion);
    [oneContenView addSubview:vipMoneyLabel];
    
    UIButton *openBtn = [[UIButton alloc] init];
    openBtn.backgroundColor = RGB(122, 37, 188);
    [openBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [openBtn setTitle:@"开通会员" forState:UIControlStateNormal];
    openBtn.titleLabel.font = FONT(15 * kFontProportion);
    [oneContenView addSubview:openBtn];
    
    UILabel *powerTitleLabel = [[UILabel alloc] init];
    powerTitleLabel.text = @"会员权益";
    powerTitleLabel.textColor = kBlackLabelColor;
    powerTitleLabel.textAlignment = NSTextAlignmentLeft;
    powerTitleLabel.font = FONT(13 * kFontProportion);
    [oneContenView addSubview:powerTitleLabel];
    
    UIView *twoContenView = [[UIView alloc] init];
    twoContenView.backgroundColor = RGB(234, 234, 234);
    [oneContenView addSubview:twoContenView];
    
    powerDetailLabel = [[UILabel alloc] init];
    powerDetailLabel.textColor = kBlackLabelColor;
    powerDetailLabel.textAlignment = NSTextAlignmentLeft;
    powerDetailLabel.font = FONT(13 * kFontProportion);
    [twoContenView addSubview:powerDetailLabel];
    
    [vipTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(oneContenView).offset(17 * kScreenHeightProportion);
        make.left.mas_equalTo(oneContenView).offset(18 * kScreenWidthProportion);
        make.width.mas_equalTo(70 * kScreenWidthProportion);
        make.height.mas_equalTo(19 * kScreenHeightProportion);
    }];
    
    [vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(vipTitleLabel).offset(4);
        make.left.mas_equalTo(vipTitleLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(33 * kScreenWidthProportion, 12 * kScreenHeightProportion));
    }];
    
    [vipMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(oneContenView).offset(17 * kScreenHeightProportion);
        make.right.mas_equalTo(oneContenView).offset(-18 * kScreenWidthProportion);
        make.width.mas_equalTo(78 * kScreenWidthProportion);
        make.height.mas_equalTo(19 * kScreenHeightProportion);
    }];
    
    [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(vipTitleLabel.mas_bottom).offset(20 * kScreenHeightProportion);
        make.left.mas_equalTo(vipTitleLabel);
        make.right.mas_equalTo(vipMoneyLabel);
        make.height.mas_equalTo(40 * kScreenHeightProportion);
    }];
    
    [powerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(openBtn.mas_bottom).offset(24 * kScreenHeightProportion);
        make.left.right.mas_equalTo(openBtn);
        make.height.mas_equalTo(16 * kScreenHeightProportion);
    }];
    
    [twoContenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(powerTitleLabel.mas_bottom).offset(7 * kScreenHeightProportion);
        make.left.mas_equalTo(openBtn).offset(-8 * kScreenWidthProportion);
        make.right.mas_equalTo(openBtn).offset(8 * kScreenWidthProportion);
        make.height.mas_equalTo(150 * kScreenHeightProportion);
    }];
    
    
    [powerDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(twoContenView).offset(18 * kScreenHeightProportion);
        make.left.mas_equalTo(twoContenView).offset(20 * kScreenWidthProportion);
        make.right.mas_equalTo(twoContenView).offset(-20 * kScreenWidthProportion);
        make.bottom.mas_equalTo(twoContenView).offset(-18 * kScreenHeightProportion);
    }];
    
    [openBtn addTarget:self action:@selector(openAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void) openAction{
    
    [[PayVipPopView alloc] createViewWithBlock:^(UIView *popView, NSInteger payType) {
        
        NSLog(@"typeID -> %ld", payType);
        
    } andMoney:vipmoney];
    
}

#pragma mark - 获取充值页面的数据API
- (void) initRechargeVipTwigAPI{
    NSString *url = [NSString stringWithFormat:@"%@", kRechargeVipTwigURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        //判断有无数据
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            
            if ([errorCode isEqualToString:@"0"]) {
                NSDictionary *dataDict = dict[@"data"];
                vipmoney = [NSString stringWithFormat:@"%@", dataDict[@"vipmoney"]];
                NSString *vip_introduction = [NSString stringWithFormat:@"%@", dataDict[@"vip_introduction"]];
                NSString *username = [NSString stringWithFormat:@"%@", dataDict[@"username"]];
                
                // 会员金额
                vipMoneyLabel.text = [NSString stringWithFormat:@"%@元", vipmoney];
                
                // 会员名称
                nameLabel.text = username;
                
                // 会员权益
                NSAttributedString *detailsAttrStr = [[NSAttributedString alloc] initWithData:[vip_introduction dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                powerDetailLabel.attributedText = detailsAttrStr;
                //[powerDetailLabel setLineSpacing:5.0f];
                powerDetailLabel.numberOfLines = 0;
                //powerDetailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                
                
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
