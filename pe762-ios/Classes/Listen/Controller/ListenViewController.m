//
//  ListenViewController.m
//  pe762-ios
//
//  Created by wsy on 2018/4/20.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import "ListenViewController.h"

@interface ListenViewController ()
{
    UIButton *majorBtn;//专业
    UILabel *typeLabel;//页面标题
    UIButton *noticeBtn;//消息通知
    
    UIScrollView *mainScrollView;
    UIView *mainView;
    SDCycleScrollView *bannerScrollView;//轮播图
    
    UICollectionView *gratisCollectionView;//免费试听
    UICollectionView *hotCollectionView;//热门课程
    UITableView *freshTableView;//最新
}
@end

@implementation ListenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 显示tabbar
    [self showTabBarView:YES];
    
    // 加载数据
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void)initUI {
#pragma mark - 头部
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = kWhiteColor;
    
    majorBtn = [[UIButton alloc] init];
    noticeBtn = [[UIButton alloc] init];
    typeLabel = [[UILabel alloc] init];
    [self createNavigationFeatureAndTitle:@"知趣大学专业说" withLeftBtn:majorBtn andRightBtn:noticeBtn andTypeTitle:typeLabel];
    
    [majorBtn addTarget:self action:@selector(majorBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [noticeBtn addTarget:self action:@selector(noticeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    typeLabel.text = @"专业";
    
#pragma mark - mainScrollView
    mainScrollView = [UIScrollView new];
    [self.view addSubview:mainScrollView];
    [mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kHeaderHeight);
        make.bottom.equalTo(self.view).offset(-kTabBarHeight);
        make.left.right.equalTo(self.view);
    }];
    
    if (@available(iOS 11.0, *)) {
        mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        mainScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        mainScrollView.scrollIndicatorInsets = mainScrollView.contentInset;
    }
    
    mainView = [[UIView alloc] init];
    [mainScrollView addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainScrollView);
        make.width.equalTo(mainScrollView);
    }];
    
#pragma mark - bannerScrollView
    bannerScrollView = [[SDCycleScrollView alloc] init];
    bannerScrollView.showPageControl = YES;
    bannerScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    bannerScrollView.autoScrollTimeInterval = 2;
    bannerScrollView.currentPageDotColor = kDefaultColor;
    bannerScrollView.pageDotColor = kLineGrayColor;
    bannerScrollView.titleLabelBackgroundColor = [UIColor clearColor];
    
    [SDCycleScrollView clearImagesCache];// 清除缓存。
    [mainView addSubview:bannerScrollView];
    
    [bannerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.mas_equalTo(mainView);
        make.height.mas_equalTo(128 * kScreenHeightProportion);
    }];
    
#pragma mark - 搜索
    UIView *searchView = [[UIView alloc] init];
    [searchView setCornerRadius:(10 * kScreenHeightProportion)];
    searchView.backgroundColor = kBackgroundWhiteColor;
    [mainView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bannerScrollView.mas_bottom).offset(10 * kScreenHeightProportion);
        make.left.mas_equalTo(mainView.mas_left).offset(35 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 70 * kScreenWidthProportion, 20 * kScreenHeightProportion));
    }];
    
    UILabel *searchLabel = [[UILabel alloc] init];
    searchLabel.textColor = kTextFieldColor;
    searchLabel.text = @"知趣与你同在";
    searchLabel.font = FONT(10 * kFontProportion);
    [searchView addSubview:searchLabel];
    CGFloat searchLabelWidth = [searchLabel getTitleTextWidth:searchLabel.text font:FONT(10 * kFontProportion)];
    [searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchView.mas_centerY).offset(-6 * kScreenHeightProportion);
        make.left.mas_equalTo(searchView.mas_centerX).offset(-searchLabelWidth/2.0 + 6 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(searchLabelWidth, 12 * kScreenWidthProportion));
    }];
    
    UIImageView *searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Layer_-1"]];
    [searchView addSubview:searchImageView];
    [searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchLabel.mas_top);
        make.right.mas_equalTo(searchLabel.mas_left).offset(-6 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(12 * kScreenWidthProportion, 12 * kScreenWidthProportion));
    }];
    
#pragma mark - 讲专业、降学压、填志愿
    UIImageView *professionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 117"]];
    [mainView addSubview:professionImageView];
    [professionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchView.mas_bottom).offset(10 * kScreenHeightProportion);
        make.left.mas_equalTo(searchView.mas_left);
        make.size.mas_equalTo(CGSizeMake(74 * kScreenWidthProportion, 74 * kScreenWidthProportion));
    }];
    
    UIImageView *pressureImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 119"]];
    [mainView addSubview:pressureImageView];
    [pressureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(professionImageView.mas_top);
        make.right.mas_equalTo(searchView.mas_right);
        make.size.mas_equalTo(CGSizeMake(74 * kScreenWidthProportion, 74 * kScreenWidthProportion));
    }];
    
    UIImageView *intentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 118"]];
    [mainView addSubview:intentImageView];
    [intentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(searchView.mas_centerX);
        make.top.mas_equalTo(professionImageView.mas_top);
        make.size.mas_equalTo(CGSizeMake(74 * kScreenWidthProportion, 74 * kScreenWidthProportion));
    }];
    
#pragma mark - 免费试听
    UILabel *gratisLabel = [[UILabel alloc] init];
    gratisLabel.textColor = kBlackLabelColor;
    gratisLabel.text = @"免费试听";
    gratisLabel.font = FONT(14 * kFontProportion);
    [mainView addSubview:gratisLabel];
    [gratisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(intentImageView.mas_bottom).offset(30 * kScreenHeightProportion);
        make.left.mas_equalTo(mainView.mas_left).offset(10 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(120 * kScreenWidthProportion, 40 * kScreenWidthProportion));
    }];
    
    
}

#pragma mark - 按钮点击方法
// 专业
- (void) majorBtnAction{
    NSLog(@"专业");
    //[self showTabBarView:NO];

}

// 消息通知
- (void) noticeBtnAction{
    NSLog(@"消息通知");
    //[self showTabBarView:NO];
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
