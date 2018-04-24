//
//  ProblemDetailViewController.m
//  pe762-ios
//
//  Created by Future on 2018/4/24.
//  Copyright © 2018年 zmit. All rights reserved.
//  常见问题详情页面

#import "ProblemDetailViewController.h"

@interface ProblemDetailViewController ()
{
    UIButton *majorBtn;//专业
    UILabel *typeLabel;//页面标题
    UIButton *noticeBtn;//消息通知
    
    UILabel *titleLabel;//标题
    UILabel *dateLabel;//发布时间
    UILabel *authorLabel;//作者
    UILabel *hotLabel;//热度
    UILabel *contentLabel;//内容
}
@end

@implementation ProblemDetailViewController

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
    
    majorBtn = [[UIButton alloc] init];
    noticeBtn = [[UIButton alloc] init];
    typeLabel = [[UILabel alloc] init];
    [self createNavigationFeatureAndTitle:@"常见问题" withLeftBtn:majorBtn andRightBtn:noticeBtn andTypeTitle:typeLabel];
    
    [majorBtn addTarget:self action:@selector(majorBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [noticeBtn addTarget:self action:@selector(noticeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    typeLabel.text = @"专业";
    
    [self createEndBackView];
    
#pragma mark - 标题、作者、发布时间、热度、内容
    // 标题
    titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = kBlackLabelColor;
    titleLabel.font = FONT(15 * kFontProportion);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"如何注册知趣大学专业说？";
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10 * kScreenWidthProportion);
        make.top.mas_equalTo(kHeaderHeight + 22 * kScreenHeightProportion);
        make.size.mas_equalTo(CGSizeMake(300 * kScreenWidthProportion, 20 * kScreenHeightProportion));
    }];
    
    // 发布时间
    dateLabel = [[UILabel alloc] init];
    dateLabel.textColor = kTextFieldColor;
    dateLabel.font = FONT(10 * kFontProportion);
    dateLabel.textAlignment = NSTextAlignmentLeft;
    dateLabel.text = @"2018-03-17";
    [self.view addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10 * kScreenWidthProportion);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(3 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(60 * kScreenWidthProportion, 11 * kScreenHeightProportion));
    }];
    
    // 作者
    authorLabel = [[UILabel alloc] init];
    authorLabel.textColor = kTextFieldColor;
    authorLabel.font = FONT(10 * kFontProportion);
    authorLabel.textAlignment = NSTextAlignmentLeft;
    authorLabel.text = @"智取大学专业说";
    [self.view addSubview:authorLabel];
    CGFloat authorLabelWidth = [authorLabel getTitleTextWidth:authorLabel.text font:FONT(10 * kFontProportion)];
    [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(dateLabel.mas_right).offset(10);
        make.top.mas_equalTo(dateLabel.mas_top);
        make.size.mas_equalTo(CGSizeMake(authorLabelWidth, 11 * kScreenHeightProportion));
    }];
    
    // 热度
    hotLabel = [[UILabel alloc] init];
    hotLabel.textColor = kTextFieldColor;
    hotLabel.font = FONT(10 * kFontProportion);
    hotLabel.textAlignment = NSTextAlignmentLeft;
    hotLabel.text = @"27万次";
    [self.view addSubview:hotLabel];
    [hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(authorLabel.mas_right).offset(10);
        make.top.mas_equalTo(authorLabel.mas_top);
        make.size.mas_equalTo(CGSizeMake(70 * kScreenWidthProportion, 11 * kScreenHeightProportion));
    }];
    
    // 内容
    contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = kTextFieldColor;
    contentLabel.font = FONT(10 * kFontProportion);
    //    contentLabel.backgroundColor = kRedColor;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(authorLabel.mas_left);
        make.top.mas_equalTo(authorLabel.mas_bottom).offset(15 * kScreenHeightProportion);
    }];
}

#pragma mark - 点击事件
// 专业
- (void) majorBtnAction{
    NSLog(@"专业");
    [self showTabBarView:NO];
    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
}

// 消息通知
- (void) noticeBtnAction{
    NSLog(@"消息通知");
    [self showTabBarView:NO];
    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
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