//
//  InformationDetailViewController.m
//  pe762-ios
//
//  Created by Future on 2018/4/23.
//  Copyright © 2018年 zmit. All rights reserved.
//  资讯详情页面

#import "InformationDetailViewController.h"

@interface InformationDetailViewController ()<WKUIDelegate>
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
    UIImageView *zanImageView;
    
    WKWebView * webView;
}
@end

@implementation InformationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self initUI];
    [self initWKWebUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 加载数据
    [self initReadInfoDetailAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initWKWebUI{
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
    likeBtn.selected = NO;
    [likeBtn addTarget:self action:@selector(likeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:likeBtn];
    
    zanImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (kEndBackViewHeight - 37 * kScreenWidthProportion * 0.8)/2.0 + 3 * kScreenWidthProportion, likeBtn.width, 37 * kScreenWidthProportion * 0.8)];
    zanImageView.image = [UIImage imageNamed:@"Group 132"];
    [likeBtn addSubview:zanImageView];
    
    webView = [[WKWebView alloc] init];
    webView.backgroundColor = kBackgroundWhiteColor;
    //- 33 * kScreenHeightProportion
    if (kScreenHeight == 812) {
        webView.frame = CGRectMake(0, kHeaderHeight, kScreenWidth, kScreenHeight - kHeaderHeight - kEndBackViewHeight);
    } else {
        webView.frame = CGRectMake(0, kHeaderHeight, kScreenWidth, kScreenHeight - kHeaderHeight - kEndBackViewHeight);
    }
    [self.view addSubview:webView];
    
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
    authorLabel.textColor = kTextFieldColor;
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
    releaseTimeLabel.textColor = kTextFieldColor;
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
    hotLabel.textColor = kTextFieldColor;
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
    contentLabel.textColor = kTextFieldColor;
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
    if (likeBtn.isSelected) {
        //目前喜欢 点击取消点赞
        NSString *url = [NSString stringWithFormat:@"%@",kLikeDeleteURL];
        url = [self stitchingTokenAndPlatformForURL:url];
        NSDictionary *parameter = @{
                                    @"id":self.idStr,
                                    @"type":@"2"
                                    };
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [self defaultRequestwithURL:url withParameters:parameter withMethod:kPOST withBlock:^(NSDictionary *dict, NSError *error) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            //判断有无数据
            if ([[dict allKeys] containsObject:@"errorCode"]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
                
                if ([errorCode isEqualToString:@"0"]) {
                    //处理数据
                    [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                    likeBtn.selected = NO;
                    zanImageView.image = [UIImage imageNamed:@"Group 132"];
                    
                }else {
                    [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                    return;
                }
            }
        }];
    } else {
        //目前不喜欢 点击则点赞
        NSString *url = [NSString stringWithFormat:@"%@",kLikeAddURL];
        url = [self stitchingTokenAndPlatformForURL:url];
        NSDictionary *parameter = @{
                                    @"id":self.idStr,
                                    @"type":@"2"
                                    };
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        [self defaultRequestwithURL:url withParameters:parameter withMethod:kPOST withBlock:^(NSDictionary *dict, NSError *error) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            //判断有无数据
            if ([[dict allKeys] containsObject:@"errorCode"]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
                
                if ([errorCode isEqualToString:@"0"]) {
                    //                    NSDictionary *dataDic = dict[@"data"];
                    //处理数据
                    [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                    
                    likeBtn.selected = YES;
                    zanImageView.image = [UIImage imageNamed:@"icon_good_red"];
                    
                }else {
                    [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                    return;
                }
            }
        }];
    }
}

#pragma mark - 读资讯详情API
- (void) initReadInfoDetailAPI{
    //目前喜欢 点击取消点赞
    NSString *url = [NSString stringWithFormat:@"%@", kReadInfoDetailURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    url = [NSString stringWithFormat:@"%@&id=%@", url, self.idStr];
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:nil withMethod:kPOST withBlock:^(NSDictionary *dict, NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        //判断有无数据
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            
            if ([errorCode isEqualToString:@"0"]) {
                NSDictionary *dataDict = dict[@"data"];
                NSString *urlStr = [NSString stringWithFormat:@"%@", dataDict[@"url"]];
                NSLog(@"%@", urlStr);
                
                urlStr = [self stitchingTokenAndPlatformForURL:urlStr];
                [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
                
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
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
