//
//  InformationDetailViewController.m
//  pe762-ios
//
//  Created by Future on 2018/4/23.
//  Copyright © 2018年 zmit. All rights reserved.
//  资讯详情页面

#import "InformationDetailViewController.h"

@interface InformationDetailViewController ()
{
    UIButton *leftBtn;
    UIButton *rightBtn;
    UILabel *typeLabel;
}
@end

@implementation InformationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 加载数据
    
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
    
    leftBtn = [[UIButton alloc] init];
    rightBtn = [[UIButton alloc] init];
    typeLabel = [[UILabel alloc] init];
    [self createNavigationFeatureAndTitle:@"读资讯" withLeftBtn:leftBtn andRightBtn:rightBtn andTypeTitle:typeLabel];
    
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    typeLabel.text = @"专业";
    
#pragma mark - 底部返回、分享、点赞
    
}

#pragma mark - 点击事件
- (void)leftBtnAction{
    
}

- (void)rightBtnAction{
    
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
