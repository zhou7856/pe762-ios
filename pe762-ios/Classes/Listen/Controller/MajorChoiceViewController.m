//
//  MajorChoiceViewController.m
//  pe762-ios
//
//  Created by Future on 2018/5/15.
//  Copyright © 2018年 zmit. All rights reserved.
//  专业选择页面

#import "MajorChoiceViewController.h"

@interface MajorChoiceViewController ()
{
    UIButton *majorBtn;//专业
    UILabel *typeLabel;//页面标题
    UIButton *noticeBtn;//消息通知
}
@end

@implementation MajorChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
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
#pragma mark - 头部
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = kWhiteColor;
    
    majorBtn = [[UIButton alloc] init];
    typeLabel = [[UILabel alloc] init];
    [self createNavigationFeatureAndTitle:@"专业" withLeftBtn:majorBtn andTypeTitle:typeLabel];
    typeLabel.text = @"专业";
    
    [self createEndBackView];
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
