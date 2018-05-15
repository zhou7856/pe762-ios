//
//  ChangeInfoViewController.m
//  pe762-ios
//
//  Created by wsy on 2018/4/23.
//  Copyright © 2018年 zmit. All rights reserved.
//  修改信息页面 6-

#import "ChangeInfoViewController.h"

@interface ChangeInfoViewController ()
{
    UITextField *changeText;
}
@end

@implementation ChangeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTabBarView:NO];
}

- (void)initNav {
    self.view.backgroundColor = RGB(243, 243, 243);
    if ([_typeStr isEqualToString:@"1"]) {
        [self createNavigationTitle:@"修改昵称"];
    } else {
        [self createNavigationTitle:@"修改邮箱"];
    }
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(250 * kScreenWidthProportion, kStatusHeight, 60 * kScreenWidthProportion, 44)];
    [saveBtn setTitle:@"保存" forState:0];
    [saveBtn setTitleColor:kBlackLabelColor forState:0];
    saveBtn.titleLabel.font = FONT(16);
    [self.view addSubview:saveBtn];
    [saveBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self createEndBackView];
}

- (void)initUI {
    UIView *textView = [UIView viewWithFrame:CGRectMake(12 * kScreenWidthProportion, 20 * kScreenWidthProportion + kHeaderHeight, 296 * kScreenWidthProportion, 40 * kScreenWidthProportion) backgroundColor:kWhiteColor];
    [self.view addSubview:textView];
    
    changeText = [[UITextField alloc] initWithFrame:CGRectMake(12 * kScreenWidthProportion, 0, 200 * kScreenWidthProportion, 40 * kScreenWidthProportion)];
    [textView addSubview:changeText];
    if ([_typeStr isEqualToString:@"1"]) {
        changeText.placeholder = _userInfo;
    } else {
        changeText.placeholder = @"User Email";
    }
    
}

#pragma mark - 保存点击
- (void)saveBtnAction {
    
    NSDictionary *parameter;
    if ([_typeStr isEqualToString:@"1"]) {
        if (changeText.text.length == 0) {
            [self showHUDTextOnly:@"请输入昵称"];
            return;
        }
        //昵称
        parameter = @{@"name":changeText.text};
    } else {
        if (changeText.text.length == 0) {
            [self showHUDTextOnly:@"请输入邮箱"];
            return;
        }
        //邮箱
        parameter = @{@"e_mail":changeText.text};
    }
    
    NSString *url = [NSString stringWithFormat:@"%@",kEditInfoURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    
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
//                NSDictionary *dataDic = dict[@"data"];
                //处理数据
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
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
