//
//  MyRecordingViewController.m
//  pe762-ios
//
//  Created by wsy on 2018/4/23.
//  Copyright © 2018年 zmit. All rights reserved.
//  我的收藏夹页面 （播放记录、下载页面）

#import "MyRecordingViewController.h"

@interface MyRecordingViewController ()
{
    UIButton *setingBtn; //设置按钮
    UIButton *messageBtn; //消息按钮
    
    //1 我的收藏 2 播放记录 3 我的下载
    NSInteger type;
    
    UITableView *listTableView;
    NSArray *listDataArray;
}
@end

@implementation MyRecordingViewController

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
    [self createNavigationTitle:@"用户中心"];
    
    UIImageView *setImageView = [[UIImageView alloc] initWithFrame:CGRectMake(235 * kScreenWidthProportion, kStatusHeight + 12, 20, 20)];
    setImageView.image = [UIImage imageNamed:@"Layer_-2"];
    [self.view addSubview:setImageView];
    
    setingBtn = [[UIButton alloc] initWithFrame:CGRectMake(230 * kScreenWidthProportion, kStatusHeight, 30, 44)];
    [setingBtn addTarget:self action:@selector(setingBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setingBtn];
    
    UIImageView *messageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(275 * kScreenWidthProportion, kStatusHeight + 12, 18, 20)];
    messageImageView.image = [UIImage imageNamed:@"Layer_1_1_"];
    [self.view addSubview:messageImageView];
    
    messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(270 * kScreenWidthProportion, kStatusHeight, 30, 44)];
    [messageBtn addTarget:self action:@selector(messageBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:messageBtn];
    
    [self createEndBackView];
    
}

- (void)initUI {
    
}

#pragma makr - 设置点击
- (void)setingBtnAction {
    [self.navigationController pushViewController:[SettingViewController new] animated:YES];
}

#pragma makr - 消息点击
- (void)messageBtnAction {
    
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
