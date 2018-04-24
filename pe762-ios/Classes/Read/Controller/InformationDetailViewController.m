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
    UIButton *leftBtn;//专业
    UILabel *typeLabel;//页面标题
    
    UIButton *shareBtn;//分享
    UIButton *likeBtn; //喜欢
    
    UILabel *titleLabel;//标题
    UILabel *authorLabel;//作者
    UILabel *releaseTimeLabel;//发布时间
    UILabel *hotLabel;//热度
    UILabel *contentLabel;//内容
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
    self.view.backgroundColor = kBackgroundWhiteColor;
    
    leftBtn = [[UIButton alloc] init];
    typeLabel = [[UILabel alloc] init];
    [self createNavigationFeatureAndTitle:@"读资讯" withLeftBtn:leftBtn andTypeTitle:typeLabel];
    
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    typeLabel.text = @"专业";
    
#pragma mark - 底部返回、分享、喜欢
    // 返回
    [self createEndBackView];
    
    //分享
    shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(228 * kScreenWidthProportion, kScreenHeight - kEndBackViewHeight, 51 * kScreenWidthProportion * 0.8, kEndBackViewHeight)];
    [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    UIImageView *shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (kEndBackViewHeight - 37 * kScreenWidthProportion * 0.8)/2.0 + 3 * kScreenWidthProportion, shareBtn.width, 37 * kScreenHeightProportion * 0.8)];
    shareImageView.image = [UIImage imageNamed:@"Group 131"];
    [shareBtn addSubview:shareImageView];
    
    //喜欢
    likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(272 * kScreenWidthProportion, kScreenHeight - kEndBackViewHeight, 51 * kScreenWidthProportion * 0.8, kEndBackViewHeight)];
    [likeBtn addTarget:self action:@selector(likeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:likeBtn];
    
    UIImageView *zanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (kEndBackViewHeight - 37 * kScreenWidthProportion * 0.8)/2.0 + 3 * kScreenWidthProportion, likeBtn.width, 37 * kScreenWidthProportion * 0.8)];
    zanImageView.image = [UIImage imageNamed:@"Group 132"];
    [likeBtn addSubview:zanImageView];
    
#pragma mark - 标题、作者、发布时间、热度、内容
    // 标题
    titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = kBlackLabelColor;
    titleLabel.font = FONT(15 * kFontProportion);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"句透|历史惊人相似，但它不会重复自身";
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10 * kScreenWidthProportion);
        make.top.mas_equalTo(kHeaderHeight + 22 * kScreenHeightProportion);
        make.size.mas_equalTo(CGSizeMake(300 * kScreenWidthProportion, 20 * kScreenHeightProportion));
    }];
    
    // 作者
    authorLabel = [[UILabel alloc] init];
    authorLabel.textColor = kLightGreyColor;
    authorLabel.font = FONT(10 * kFontProportion);
    authorLabel.textAlignment = NSTextAlignmentLeft;
//    authorLabel.backgroundColor = kRedColor;
    authorLabel.text = @"作者:智取大学专业说";
    [self.view addSubview:authorLabel];
    [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10 * kScreenWidthProportion);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(3 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(100 * kScreenWidthProportion, 11 * kScreenHeightProportion));
    }];
    
    // 发布时间
    releaseTimeLabel = [[UILabel alloc] init];
    releaseTimeLabel.textColor = kLightGreyColor;
    releaseTimeLabel.font = FONT(10 * kFontProportion);
    releaseTimeLabel.textAlignment = NSTextAlignmentLeft;
//    releaseTimeLabel.backgroundColor = kRedColor;
    releaseTimeLabel.text = @"发布时间:2018-03-17";
    [self.view addSubview:releaseTimeLabel];
    [releaseTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(authorLabel.mas_right).offset(10);
        make.top.mas_equalTo(authorLabel.mas_top);
        make.size.mas_equalTo(CGSizeMake(110 * kScreenWidthProportion, 11 * kScreenHeightProportion));
    }];
    
    // 热度
    hotLabel = [[UILabel alloc] init];
    hotLabel.textColor = kLightGreyColor;
    hotLabel.font = FONT(10 * kFontProportion);
//    hotLabel.backgroundColor = kRedColor;
    hotLabel.textAlignment = NSTextAlignmentLeft;
    hotLabel.text = @"热度:208次";
    [self.view addSubview:hotLabel];
    [hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(releaseTimeLabel.mas_right).offset(10);
        make.top.mas_equalTo(authorLabel.mas_top);
        make.size.mas_equalTo(CGSizeMake(70 * kScreenWidthProportion, 11 * kScreenHeightProportion));
    }];
    
    // 内容
    contentLabel = [[UILabel alloc] init];
    contentLabel.textColor = kLightGreyColor;
    contentLabel.font = FONT(10 * kFontProportion);
//    contentLabel.backgroundColor = kRedColor;
    contentLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(authorLabel.mas_left);
        make.top.mas_equalTo(authorLabel.mas_bottom).offset(15 * kScreenHeightProportion);
    }];
}

#pragma mark - 点击事件
- (void)leftBtnAction{
    NSLog(@"专业");
}

- (void)shareBtnAction{
    NSLog(@"分享");
}

- (void)likeBtnAction{
    NSLog(@"喜欢");
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
