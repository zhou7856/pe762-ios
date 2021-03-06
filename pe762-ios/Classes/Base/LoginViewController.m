//
//  LoginViewController.m
//  pe762-ios
//
//  Created by wsy on 2018/4/20.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"//注册
#import "ReadViewController.h"//读咨询
#import "ListenViewController.h"//听知识
#import "PersonCenterViewController.h"//个人中心

@interface LoginViewController ()
{
    UIButton *leftBtn;//专业
    UILabel *typeLabel;//页面标题
    
    UIImageView *headImageView;//头像
    UITextField *phoneTextField;//手机号
    UIButton *getVerifyCodeBtn;//获取验证码
    UITextField *verifyTextField;//验证码
    UITextField *imageCodeTextField;//图像验证码
    UIImageView *verifyImageView;//图像验证码
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self onClickImage];
    // 加载数据
    [self showTabBarView:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void)initUI{
#pragma mark - 头部
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = kWhiteColor;
    
    [self createNavigationTitle:@"登录"];
    
    leftBtn = [[UIButton alloc] init];
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"Path 164"] forState:0];
    [self.view addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(kStatusHeight + 11);
        make.left.mas_equalTo(self.view).mas_offset(10 * kScreenWidthProportion);
    }];
    
    UIButton *shadowLeftBtn = [[UIButton alloc] init];
    shadowLeftBtn.backgroundColor = [UIColor clearColor];
    [self.view addSubview:shadowLeftBtn];
    [shadowLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(kStatusHeight);
        make.left.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(80, kNavigationBarHeight));
    }];
    
    // 点击返回到首页
    [[shadowLeftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        //登录成功，跳转到案例界面
        [self.navigationController popToRootViewControllerAnimated:NO];
        UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        TabBarController *tabBarController = (TabBarController *)nav.topViewController;
        
        [tabBarController setSelect:1];
        
    }];
    
    
#pragma mark - 头像、背景图片、背景阴影
    // 背景图片
    UIImageView *shadowImageView = [[UIImageView alloc] init];
    shadowImageView.image =[UIImage imageNamed:@"VCG211124209403"];
    shadowImageView.backgroundColor = kBackgroundWhiteColor;
    [self.view addSubview:shadowImageView];
    [shadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(kHeaderHeight);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 114 * kScreenHeightProportion));
    }];
    
    // 背景阴影
    UIView *shadowView = [[UIView alloc] initWithFrame:shadowImageView.frame];
    shadowView.backgroundColor = kBlackColor;
    [self.view addSubview:shadowView];
    
    // 头像背景
    UIButton *shadowBtn = [[UIButton alloc] init];
    shadowBtn.backgroundColor = kWhiteColor;
    [shadowBtn setCornerRadius:35 * kScreenWidthProportion];
    [self.view addSubview:shadowBtn];
    [shadowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(shadowImageView.centerX);
        make.top.mas_equalTo(shadowImageView.mas_bottom).offset(-35 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(70 * kScreenWidthProportion, 70 * kScreenWidthProportion));
    }];
    
    // 头像背景
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(3 * kScreenWidthProportion, 3 * kScreenWidthProportion, 64 * kScreenWidthProportion, 64 * kScreenWidthProportion)];
    headImageView.image = [UIImage imageNamed:@"APP图标-120x120-2"];
    //headImageView.backgroundColor = kRedColor;
    [headImageView setCornerRadius:32 * kScreenWidthProportion];
    [shadowBtn addSubview:headImageView];
    
#pragma mark - 输入手机号
    phoneTextField = [[UITextField alloc] init];
    phoneTextField.placeholder = @"输入手机号码";
    phoneTextField.textColor = kBlackLabelColor;
    //phoneTextField.backgroundColor = kRedColor;
    phoneTextField.font = FONT(12 * kFontProportion);
    [self.view addSubview:phoneTextField];
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10 * kScreenWidthProportion);
        make.top.mas_equalTo(shadowImageView.mas_bottom).offset(70 * kScreenHeightProportion);
        make.size.mas_equalTo(CGSizeMake(200 * kScreenWidthProportion, 25 * kScreenHeightProportion));
    }];
    
#pragma mark - 获取验证码
    getVerifyCodeBtn = [[UIButton alloc] init];
    [getVerifyCodeBtn setBackgroundImage:[UIImage imageNamed:@"Rectangle 41"] forState:UIControlStateNormal];
    //getVerifyCodeBtn.backgroundColor = kRedColor;
    [getVerifyCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVerifyCodeBtn setTitleColor:kTextFieldColor forState:UIControlStateNormal];
    getVerifyCodeBtn.titleLabel.font = FONT(12 * kFontProportion);
    [self.view addSubview:getVerifyCodeBtn];
    [getVerifyCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(shadowImageView.mas_right).offset(-12 * kScreenWidthProportion);
        make.top.mas_equalTo(phoneTextField.mas_top).offset(1 * kScreenHeightProportion);
        make.size.mas_equalTo(CGSizeMake(89 * kScreenWidthProportion * 0.9, 26 * kScreenHeightProportion * 0.9));
    }];
    [getVerifyCodeBtn addTarget:self action:@selector(getVerifyCodeAPI) forControlEvents:UIControlEventTouchUpInside];
    
    // 下划线
    UIView *firstLineView = [[UIView alloc] init];
    firstLineView.backgroundColor = kLineGrayColor;
    [self.view addSubview:firstLineView];
    [firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(phoneTextField.mas_left);
        make.right.mas_equalTo(getVerifyCodeBtn.mas_right);
        make.top.mas_equalTo(phoneTextField.mas_bottom).offset(6 * kScreenHeightProportion);
        make.height.mas_equalTo(1);
    }];
    
#pragma mark - 输入图形验证码
    imageCodeTextField = [[UITextField alloc] init];
    imageCodeTextField.placeholder = @"输入图形验证码";
    imageCodeTextField.textColor = kBlackLabelColor;
    //imageCodeTextField.backgroundColor = kRedColor;
    imageCodeTextField.font = FONT(12 * kFontProportion);
    [self.view addSubview:imageCodeTextField];
    [imageCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(firstLineView.mas_left);
        make.top.mas_equalTo(firstLineView.mas_bottom).offset(10 * kScreenHeightProportion);
        make.size.mas_equalTo(CGSizeMake(200 * kScreenWidthProportion, 25 * kScreenHeightProportion));
    }];
    
    //图形验证码-图片
    verifyImageView = [[UIImageView alloc] init];
//    verifyImageView.backgroundColor = kRedColor;
    [self.view addSubview:verifyImageView];
    [verifyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(shadowImageView.mas_right).offset(-12 * kScreenWidthProportion);
        make.bottom.mas_equalTo(imageCodeTextField.mas_bottom).offset(2 * kScreenHeightProportion);
        make.size.mas_equalTo(CGSizeMake(86 * kScreenWidthProportion * 0.9, 37 * kScreenHeightProportion * 0.9));
    }];
    verifyImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        [self onClickImage];
    }];
    [verifyImageView addGestureRecognizer:tap];
    
    // 下划线
    UIView *threeLineView = [[UIView alloc] init];
    threeLineView.backgroundColor = kLineGrayColor;
    [self.view addSubview:threeLineView];
    [threeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(firstLineView.mas_left);
        make.right.mas_equalTo(firstLineView.mas_right);
        make.top.mas_equalTo(imageCodeTextField.mas_bottom).offset(6 * kScreenHeightProportion);
        make.height.mas_equalTo(1);
    }];
#pragma mark - 输入手机验证码
    verifyTextField = [[UITextField alloc] init];
    verifyTextField.placeholder = @"输入手机验证码";
    verifyTextField.textColor = kBlackLabelColor;
    //verifyTextField.backgroundColor = kRedColor;
    verifyTextField.font = FONT(12 * kFontProportion);
    [self.view addSubview:verifyTextField];
    [verifyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(threeLineView.mas_left);
        make.right.mas_equalTo(threeLineView.mas_right);
        make.top.mas_equalTo(threeLineView.mas_bottom).offset(10 * kScreenHeightProportion);
        make.height.mas_equalTo(phoneTextField.mas_height);
    }];
    
    // 下划线
    UIView *twoLineView = [[UIView alloc] init];
    twoLineView.backgroundColor = kLineGrayColor;
    [self.view addSubview:twoLineView];
    [twoLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(firstLineView.mas_left);
        make.right.mas_equalTo(firstLineView.mas_right);
        make.top.mas_equalTo(verifyTextField.mas_bottom).offset(6 * kScreenHeightProportion);
        make.height.mas_equalTo(1);
    }];
    
#pragma mark - 登录
    UIButton *loginBtn = [[UIButton alloc] init];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"Rectangle 61"] forState:UIControlStateNormal];
    //loginBtn.backgroundColor = kRedColor;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    loginBtn.titleLabel.font = FONT(14 * kFontProportion);
    [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(firstLineView.mas_left);
        make.top.mas_equalTo(twoLineView.mas_bottom).offset(23 * kScreenHeightProportion);
        make.size.mas_equalTo(CGSizeMake(339 * kScreenWidthProportion * 0.885, 41 * kScreenHeightProportion * 0.885));
    }];
    
#pragma mark - 注册
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.textColor = kBlackLabelColor;
    tipLabel.font = FONT(12 * kFontProportion);
    tipLabel.textAlignment = NSTextAlignmentLeft;
    //tipLabel.backgroundColor = kRedColor;
    tipLabel.text = @"您还没有账号，请";
    [self.view addSubview:tipLabel];
    CGFloat tipLabelWidth = [tipLabel getTitleTextWidth:tipLabel.text font:FONT(12 * kFontProportion)];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(shadowImageView.mas_centerX).offset(-16 * kScreenWidthProportion - (tipLabelWidth / 2.0));
        make.top.mas_equalTo(loginBtn.mas_bottom).offset(10 * kScreenHeightProportion);
        make.size.mas_equalTo(CGSizeMake(tipLabelWidth, 14 * kScreenHeightProportion));
    }];
    
    UIButton *registerBtn = [[UIButton alloc] init];
    //registerBtn.backgroundColor = kRedColor;
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:RGB(124, 38, 191) forState:UIControlStateNormal];
    registerBtn.titleLabel.font = FONT(12 * kFontProportion);
    [registerBtn addTarget:self action:@selector(registerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(tipLabel.mas_right).offset(1 * kScreenWidthProportion);
        make.top.mas_equalTo(tipLabel.mas_top);
        make.size.mas_equalTo(CGSizeMake(30 * kScreenWidthProportion, 14 * kScreenHeightProportion));
    }];
    
#pragma mark - LOGO
    // 背景图片
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.image =[UIImage imageNamed:@"logo_register"];
//    logoImageView.backgroundColor = kRedColor;
    [self.view addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view.mas_centerX).offset(-25 * kScreenWidthProportion);
        make.top.mas_equalTo(tipLabel.mas_bottom).offset(66 * kScreenHeightProportion);
        make.size.mas_equalTo(CGSizeMake(49 * kScreenWidthProportion, 18 * kScreenHeightProportion));
        make.centerX.mas_equalTo(self.view);
    }];
}

#pragma mark - 点击事件
- (void)leftBtnAction{
    NSLog(@"专业");
}

- (void)loginBtnAction{
    // 收起键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    NSLog(@"登录");
    if (phoneTextField.text.length == 0) {
        [self showHUDTextOnly:@"请输入手机号码"];
        return;
    }
    
    if (imageCodeTextField.text.length == 0) {
        [self showHUDTextOnly:@"请输入图形验证码"];
        return;
    }
    
    if (verifyTextField.text.length == 0) {
        [self showHUDTextOnly:@"请输入短信验证码"];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@",kLoginURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    NSDictionary *parameter = @{
                                @"salt":verifyTextField.text,
                                @"phone":phoneTextField.text
                                };
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:parameter withMethod:kPOST withBlock:^(NSDictionary *dict, NSError *error) {
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
                NSDictionary *serverDic = dataDic[@"server"];
                //是否是代理
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", serverDic[@"is_proxy"]] forKey:@"is_proxy"];
                //是否vip
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", serverDic[@"is_vip"]] forKey:@"is_vip"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", dataDic[@"token"]] forKey:@"token"];
                
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }else {
                imageCodeTextField.text = @"";
                verifyTextField.text = @"";
                [self onClickImage];
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

- (void)registerBtnAction{
    NSLog(@"注册");
    [self.navigationController pushViewController:[RegisterViewController new] animated:YES];
}

//获取短信验证码
- (void)getVerifyCodeAPI {
    // 收起键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (phoneTextField.text.length == 0) {
        [self showHUDTextOnly:@"请输入手机号码"];
        return;
    }
    
    if (imageCodeTextField.text.length == 0) {
        [self showHUDTextOnly:@"请输入图形验证码"];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@",kSendSmsURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    NSDictionary *parameter = @{
                                @"type":@"2",
                                @"phone":phoneTextField.text,
                                @"captcha":imageCodeTextField.text
                                };
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:parameter withMethod:kPOST withBlock:^(NSDictionary *dict, NSError *error) {
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
                //处理数据
                [self timeFire:getVerifyCodeBtn];
                NSDictionary *dataDic = dict[@"data"];
                NSString *saltStr = dataDic[@"salt"];
                NSLog(@"saltStr%@",saltStr);
                /*
                if (saltStr.length >0) {
                    [self showHUDTextOnly:saltStr];
                }
                else
                {
                    [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                }
                 */
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }else {
                [self onClickImage];
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

#pragma mark 图形验证码
-(void)onClickImage{
    // 收起键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    NSLog(@"图片被点击!");
    //获取新的图形验证码
    NSString *url = [NSString stringWithFormat:@"%@",kImageVerificationURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    // url = [NSString stringWithFormat:@"%@&type=company_register_img_salt",url];
    //    url = [NSString stringWithFormat:@"%@&type=user_register_img_salt",url];
    // 建立请求访问
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 加载缓冲
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 开始请求访问
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        // 关闭缓冲
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSData *data = [[NSData data] initWithData:responseObject];
        
        UIImage *image = [UIImage imageWithData: data];
        
        imageCodeTextField.text = @"";
        
        verifyImageView.image = image;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark - 获取图形验证码


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
