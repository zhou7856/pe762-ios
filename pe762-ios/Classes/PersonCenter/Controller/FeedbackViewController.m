//
//  FeedbackViewController.m
//  pe762-ios
//
//  Created by Future on 2018/4/24.
//  Copyright © 2018年 zmit. All rights reserved.
//  意见反馈页面

#import "FeedbackViewController.h"

@interface FeedbackViewController ()
{
    UIButton *majorBtn;//专业
    UILabel *typeLabel;//页面标题
    UIButton *noticeBtn;//消息通知
    
    SZTextView *contentTextView;//内容
}
@end

@implementation FeedbackViewController

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

- (void)initUI{
#pragma mark - 头部、底部
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = kBackgroundWhiteColor;
    
    majorBtn = [[UIButton alloc] init];
    noticeBtn = [[UIButton alloc] init];
    typeLabel = [[UILabel alloc] init];
    [self createNavigationFeatureAndTitle:@"意见反馈" withLeftBtn:majorBtn andRightBtn:noticeBtn andTypeTitle:typeLabel];
    
    [majorBtn addTarget:self action:@selector(majorBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [noticeBtn addTarget:self action:@selector(noticeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    typeLabel.text = @"专业";
    
    //底部
    [self createEndBackView];

#pragma mark - 内容
    contentTextView = [[SZTextView alloc] initWithFrame:CGRectMake(10 * kScreenWidthProportion, kHeaderHeight + 20 * kScreenHeightProportion, kScreenWidth - 20 * kScreenWidthProportion, 104 * kScreenHeightProportion)];
    contentTextView.placeholder = @"请输入您的意见反馈";
    contentTextView.font = FONT(12 * kFontProportion);
    contentTextView.placeholderTextColor = kTextFieldColor;
    [contentTextView setCornerRadius:4.0f];
    [self.view addSubview:contentTextView];
    
#pragma mark - 提交反馈
    UIButton *submitBtn = [[UIButton alloc] init];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"Rectangle 61"] forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交反馈" forState:UIControlStateNormal];
    [submitBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    submitBtn.titleLabel.font = FONT(14 * kFontProportion);
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentTextView.mas_left);
        make.top.mas_equalTo(contentTextView.mas_bottom).offset(20 * kScreenHeightProportion);
        make.size.mas_equalTo(CGSizeMake(339 * kScreenWidthProportion * 0.885, 41 * kScreenHeightProportion * 0.885));
    }];
}

#pragma mark - 点击事件
// 专业
- (void) majorBtnAction{
    NSLog(@"专业");
}

// 消息通知
- (void) noticeBtnAction{
    NSLog(@"消息通知");
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
