//
//  PersonalInformationViewController.m
//  pe762-ios
//
//  Created by wsy on 2018/4/23.
//  Copyright © 2018年 zmit. All rights reserved.
//  个人信息页面

#import "PersonalInformationViewController.h"
#import "ChangeInfoViewController.h" //修改信息

@interface PersonalInformationViewController ()
{
    UIButton *setingBtn; //设置按钮
    UIButton *messageBtn; //消息按钮
    
    UIImageView *headImageView;
    UILabel *nicknameLabel;
    UILabel *emainLabel;
}
@end

@implementation PersonalInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    [self initUI];
}

- (void)dealloc {
    NSLog(@"页面销毁");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTabBarView:NO];
}

- (void)initNav {
    self.view.backgroundColor = RGB(243, 243, 243);
    [self createNavigationTitle:@"个人信息"];
    
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
    {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 20 * kScreenWidthProportion + kHeaderHeight, kScreenWidth, 80 * kScreenWidthProportion)];
        [self.view addSubview:contentView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * kScreenWidthProportion, 20 * kScreenWidthProportion, 100 * kScreenWidthProportion, 40 * kScreenWidthProportion)];
        [titleLabel setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentLeft font:13];
        titleLabel.text = @"头像";
        [contentView addSubview:titleLabel];
        
        headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(230 * kScreenWidthProportion, 15 * kScreenWidthProportion, 50 * kScreenWidthProportion, 50 * kScreenWidthProportion)];
        headImageView.backgroundColor = [UIColor greenColor];
        [headImageView setCornerRadius:25 * kScreenWidthProportion];
        [contentView addSubview:headImageView];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(295 * kScreenWidthProportion, 0, 6 * kScreenWidthProportion, 9 * kScreenWidthProportion)];
        iconImageView.image = [UIImage imageNamed:@"Path 185"];
        iconImageView.centerY = titleLabel.centerY;
        [contentView addSubview:iconImageView];
        
        UIView *endLineView  = [[UIView alloc] initWithFrame:CGRectMake(15 * kScreenWidthProportion, contentView.height - 10, 290 * kScreenWidthProportion, 1)];
        endLineView.backgroundColor = RGB(238, 234, 234);
//        UIView *endLineView = [UIView viewWithFrame:CGRectMake(15 * kScreenWidthProportion, contentView.maxY - 10, 290 * kScreenWidthProportion, 10) backgroundColor:RGB(238, 234, 234)];
        [contentView addSubview:endLineView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            NSLog(@"头像切换");
        }];
        [contentView addGestureRecognizer:tap];
    }
    
    {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 100 * kScreenWidthProportion + kHeaderHeight, kScreenWidth, 40 * kScreenWidthProportion)];
        [self.view addSubview:contentView];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * kScreenWidthProportion, 0, 100 * kScreenWidthProportion, 40 * kScreenWidthProportion)];
        [titleLabel setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentLeft font:13];
        titleLabel.text = @"昵称";
        [contentView addSubview:titleLabel];

        nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(150 * kScreenWidthProportion, 0, 135 * kScreenWidthProportion, titleLabel.height)];
        [nicknameLabel setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentRight font:13];
        [contentView addSubview:nicknameLabel];
        nicknameLabel.text = @"User name";


        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(295 * kScreenWidthProportion, 0, 6 * kScreenWidthProportion, 9 * kScreenWidthProportion)];
        iconImageView.image = [UIImage imageNamed:@"Path 185"];
        iconImageView.centerY = titleLabel.centerY;
        [contentView addSubview:iconImageView];

        UIView *endLineView = [UIView viewWithFrame:CGRectMake(15 * kScreenWidthProportion, contentView.height - 1, 290 * kScreenWidthProportion, 1) backgroundColor:RGB(238, 234, 234)];
        [contentView addSubview:endLineView];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            NSLog(@"昵称修改");
            [self.navigationController pushViewController:[ChangeInfoViewController new] animated:YES];
        }];
        [contentView addGestureRecognizer:tap];
    }
    
    {
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 140 * kScreenWidthProportion + kHeaderHeight, kScreenWidth, 40 * kScreenWidthProportion)];
        [self.view addSubview:contentView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * kScreenWidthProportion, 0 * kScreenWidthProportion, 100 * kScreenWidthProportion, 40 * kScreenWidthProportion)];
        [titleLabel setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentLeft font:13];
        titleLabel.text = @"邮箱";
        [contentView addSubview:titleLabel];
        
        emainLabel = [[UILabel alloc] initWithFrame:CGRectMake(150 * kScreenWidthProportion, 0, 135 * kScreenWidthProportion, titleLabel.height)];
        [emainLabel setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentRight font:13];
        [contentView addSubview:emainLabel];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(295 * kScreenWidthProportion, 0, 6 * kScreenWidthProportion, 9 * kScreenWidthProportion)];
        iconImageView.image = [UIImage imageNamed:@"Path 185"];
        iconImageView.centerY = titleLabel.centerY;
        [contentView addSubview:iconImageView];
        
        UIView *endLineView = [UIView viewWithFrame:CGRectMake(15 * kScreenWidthProportion, contentView.height - 1, 290 * kScreenWidthProportion, 1) backgroundColor:RGB(238, 234, 234)];
        [contentView addSubview:endLineView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            NSLog(@"邮箱修改");
        }];
        [contentView addGestureRecognizer:tap];
    }
}

#pragma makr - 设置点击
- (void)setingBtnAction {
    
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
