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
    changeText.placeholder = @"User name";
}

#pragma mark - 保存点击
- (void)saveBtnAction {
    
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
