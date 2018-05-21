//
//  OpenVipViewController.m
//  pe762-ios
//
//  Created by Future on 2018/5/10.
//  Copyright © 2018年 zmit. All rights reserved.
//  开通VIP会员页面

#import "OpenVipViewController.h"
#import "PayVipPopView.h"
// 充值
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

@interface OpenVipViewController ()
{
    // 用户名
    UILabel *nameLabel;
    // 开通费用金额
    UILabel *vipMoneyLabel;
    // 会员权益简介
    UILabel *powerDetailLabel;
    UITextView *powerDetailTextView;
    // 会员金额
    NSString *vipmoney;
    // 支付方式
    NSInteger paymentType;
}
@end

@implementation OpenVipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 默认支付方式1 支付宝
    paymentType = 1;
    // 充值金额
    vipmoney = @"0.00";
    // 监听支付
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPayResultAction:) name:@"payResult" object:nil];
    
    // 初始化界面
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initRechargeVipTwigAPI];
}

// 支付宝的回调使用
- (void)getPayResultAction:(NSNotification *)noti
{
    NSString *result = noti.object;
    NSString *strMsg;
    switch (result.intValue) {
        {
            //成功
        case 9000:{
            strMsg = @"支付成功";
            [self showHUDTextOnly:strMsg];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        case 6001: {
            strMsg = @"取消支付";
            [self showHUDTextOnly:strMsg];
        }
            break;
            
        case 6002: {
            strMsg = @"网络错误";
            [self showHUDTextOnly:strMsg];
        }
            break;
            
        case 4000:{
            strMsg = @"支付失败";
            [self showHUDTextOnly:strMsg];
        }
            break;
            
        default:
            break;
        }
    }
    
    //取消支付，再次选择去支付后，这个通知已经被移除了，就不会再走这个通知方法了
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"payResult" object:nil];
}

- (void)dealloc {
    NSLog(@"释放了所有内存");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"payResult" object:nil];
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
    
    //powerDetailLabel = [[UILabel alloc] init];
    //powerDetailLabel.textColor = kBlackLabelColor;
    //powerDetailLabel.textAlignment = NSTextAlignmentLeft;
    //powerDetailLabel.font = FONT(13 * kFontProportion);
    //[twoContenView addSubview:powerDetailLabel];
    
    powerDetailTextView = [[UITextView alloc] init];
    powerDetailTextView.textColor = kBlackLabelColor;
    powerDetailTextView.backgroundColor = RGB(234, 234, 234);
    powerDetailTextView.font = FONT(13 * kFontProportion);
    [twoContenView addSubview:powerDetailTextView];
    
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
    
    
    [powerDetailTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(twoContenView).offset(18 * kScreenHeightProportion);
        make.left.mas_equalTo(twoContenView).offset(20 * kScreenWidthProportion);
        make.right.mas_equalTo(twoContenView).offset(-20 * kScreenWidthProportion);
        make.bottom.mas_equalTo(twoContenView).offset(-18 * kScreenHeightProportion);
    }];
    
    [openBtn addTarget:self action:@selector(openAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void) openAction{
    
    [[PayVipPopView alloc] createViewWithBlock:^(UIView *popView, NSInteger payType) {
        
        paymentType = payType;
        
        [self initRechargeAPI];
        
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
                //powerDetailLabel.attributedText = detailsAttrStr;
                powerDetailTextView.attributedText = detailsAttrStr;
                
                
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

#pragma mark - 充值VIP-API
- (void) initRechargeAPI{
    
    NSString *url = [NSString stringWithFormat:@"%@", kRechargeVipURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    
    NSString *payment = [self stringForNull:[NSString stringWithFormat:@"%ld", (long)paymentType]];
    
    NSDictionary *parameters = @{
                                 @"payment_method":payment
                                 };
    
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    [self defaultRequestwithURL:url withParameters:parameters withMethod:kPOST withBlock:^(NSDictionary *dict, NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        //判断有无数据
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            if ([errorCode isEqualToString:@"-1"]){
                //未登陆
                [self showTabBarView:NO];
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                [self.navigationController pushViewController:loginVC animated:YES];
                return;
            }
            
            if ([errorCode isEqualToString:@"0"]) {
                NSDictionary *dataDict = dict[@"data"];
                //NSDictionary *infoDict = dataDict[@"info"];
                
                //[支付方式 1支付宝 2微信]
                //[self weChatPay:dataDict];
                
                if (paymentType == 1) {
                    
                    [self alipay:dataDict];
                    
                } else if (paymentType == 2) {
                    
                    [self weChatPay:dataDict];
                    
                }
            }
            
        }
        
    }];
}

// 微信支付
- (void) weChatPay:(NSDictionary *)data {
    
    //NSDictionary *payDict = data[@"pay"];
    
    NSDictionary *payDict = [self dictionaryWithJsonString:[self stringForNull:data[@"pay"]]];
    
    PayReq* req = [PayReq new];
    req.partnerId = [self stringForNull:payDict[@"partnerid"]];
    req.prepayId = [self stringForNull:payDict[@"prepayid"]];
    req.nonceStr = [self stringForNull:payDict[@"noncestr"]];
    req.timeStamp = [[self stringForNull:payDict[@"timestamp"]] intValue];
    req.package = [self stringForNull:payDict[@"package"]];
    req.sign = [self stringForNull:payDict[@"sign"]];
    [WXApi sendReq:req];
}

// 支付宝支付
- (void) alipay:(NSDictionary *)data {
    // NOTE: 调用支付结果开始支付
    NSString *payStr = [self stringForNull:data[@"pay"]];
    
    [[AlipaySDK defaultService] payOrder:payStr fromScheme:@"pe762user" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        NSString *strMsg;
        switch ([resultDic[@"resultStatus"]intValue]) {
                //成功
            case 9000:{
                strMsg = @"支付成功";
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
                
            case 6001: {
                strMsg = @"取消支付";
                [self showHUDTextOnly:strMsg];
            }
                break;
                
            case 6002: {
                strMsg = @"网络错误";
                [self showHUDTextOnly:strMsg];
            }
                break;
                
            case 4000:{
                strMsg = @"支付失败";
                [self showHUDTextOnly:strMsg];
            }
                break;
                
            default:
                break;
        }
    }];
}

// 字符串转字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
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
