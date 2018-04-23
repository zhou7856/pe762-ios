//
//  PersonCenterViewController.m
//  pe762-ios
//
//  Created by wsy on 2018/4/20.
//  Copyright © 2018年 zmit. All rights reserved.
//  个人中心

#import "PersonCenterViewController.h"
#import "ListenViewController.h"

@interface PersonCenterViewController ()
{
    UIButton *leftBtn;
    UIButton *rightBtn;
    UILabel *typeLabel;
}
@end

@implementation PersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)initUI {
    self.view.backgroundColor = kWhiteColor;
    
    leftBtn = [[UIButton alloc] init];
    rightBtn = [[UIButton alloc] init];
    typeLabel = [[UILabel alloc] init];
    [self createNavigationFeatureAndTitle:@"知趣大学专业说" withLeftBtn:leftBtn andRightBtn:rightBtn andTypeTitle:typeLabel];
    
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    typeLabel.text = @"专业";
}

- (void)leftBtnAction {
    NSLog(@"左按钮点击");
    typeLabel.text = @"哈斯璐瑶克";
}

- (void)rightBtnAction {
    NSLog(@"右按钮点击");
    [self showTabBarView:NO];
    [self.navigationController pushViewController:[ListenViewController new] animated:YES];
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
