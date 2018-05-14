//
//  ListenViewController.m
//  pe762-ios
//
//  Created by wsy on 2018/4/20.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import "ListenViewController.h"
#import "CourseTableViewCell.h"//课程-列表
#import "NewestTableViewCell.h"//上新-列表
#import "ListViewController.h"//列表页面
#import "AudioPlayViewController.h"//音频播放
#import "MessageViewController.h" //消息

@interface ListenViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *majorBtn;//专业
    UILabel *typeLabel;//页面标题
    UIButton *noticeBtn;//消息通知
    UILabel *redLabel;//未读消息数
    
    UIScrollView *mainScrollView;
    UIView *mainView;
    SDCycleScrollView *bannerScrollView;//轮播图
    
    UITableView *courseTableView;//免费试听、热门课程
    UITableView *freshTableView;//最新
}
@end

@implementation ListenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    //获得专业
    [self getProfessionListAPI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 显示tabbar
    [self showTabBarView:YES];
    
    // 加载数据
    [self initData];
    
    //
    [self getBannerAPI];
    
    // 未读消息
    [self initNoticeNotReadAPI];
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
    typeLabel.text = @"专业";
    
    redLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 16 * kScreenWidthProportion, kStatusHeight + 10, 8, 8)];
    redLabel.backgroundColor = [UIColor redColor];
    redLabel.hidden = YES;
    [redLabel setCornerRadius:4];
    [self.view addSubview:redLabel];
    
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
    //mainView.backgroundColor = kRedColor;
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
        make.top.left.right.mas_equalTo(mainView);
        make.height.mas_equalTo(128 * kScreenHeightProportion);
    }];
    
#pragma mark - 搜索
    UIView *searchView = [[UIView alloc] init];
    [searchView setCornerRadius:(10 * kScreenHeightProportion)];
    searchView.backgroundColor = kBackgroundWhiteColor;
    [mainView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bannerScrollView.mas_bottom).offset(10 * kScreenHeightProportion);
        make.left.mas_equalTo(bannerScrollView).offset(35 * kScreenWidthProportion);
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
    professionImageView.userInteractionEnabled = YES;
    [mainView addSubview:professionImageView];
    [professionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchView.mas_bottom).offset(10 * kScreenHeightProportion);
        make.left.mas_equalTo(searchView.mas_left);
        make.size.mas_equalTo(CGSizeMake(74 * kScreenWidthProportion, 74 * kScreenWidthProportion));
    }];
    
    UITapGestureRecognizer *proTap = [[UITapGestureRecognizer alloc] init];
    [[proTap rac_gestureSignal] subscribeNext:^(id x) {
        [self showTabBarView:NO];
        [self.navigationController pushViewController:[ListViewController new] animated:YES];
    }];
    [professionImageView addGestureRecognizer:proTap];
    
    UIImageView *pressureImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 119"]];
    pressureImageView.userInteractionEnabled = YES;
    [mainView addSubview:pressureImageView];
    [pressureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(professionImageView.mas_top);
        make.right.mas_equalTo(searchView.mas_right);
        make.size.mas_equalTo(CGSizeMake(74 * kScreenWidthProportion, 74 * kScreenWidthProportion));
    }];
    
    UITapGestureRecognizer *preTap = [[UITapGestureRecognizer alloc] init];
    [[preTap rac_gestureSignal] subscribeNext:^(id x) {
        [self showTabBarView:NO];
        [self.navigationController pushViewController:[ListViewController new] animated:YES];
    }];
    [pressureImageView addGestureRecognizer:preTap];
    
    UIImageView *intentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 118"]];
    intentImageView.userInteractionEnabled = YES;
    [mainView addSubview:intentImageView];
    [intentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(searchView.mas_centerX);
        make.top.mas_equalTo(professionImageView.mas_top);
        make.size.mas_equalTo(CGSizeMake(74 * kScreenWidthProportion, 74 * kScreenWidthProportion));
    }];
    
    UITapGestureRecognizer *intTap = [[UITapGestureRecognizer alloc] init];
    [[intTap rac_gestureSignal] subscribeNext:^(id x) {
        [self showTabBarView:NO];
        [self.navigationController pushViewController:[ListViewController new] animated:YES];
    }];
    [intentImageView addGestureRecognizer:intTap];
    
#pragma mark - 免费试听、热门课程
    courseTableView = [[UITableView alloc] init];
    courseTableView.backgroundColor = kWhiteColor;
    courseTableView.delegate = self;
    courseTableView.dataSource = self;
    courseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    courseTableView.scrollEnabled = NO;
    courseTableView.estimatedRowHeight = 0;
    courseTableView.estimatedSectionHeaderHeight = 0;
    courseTableView.estimatedSectionFooterHeight = 0;
    [mainView addSubview:courseTableView];
    [courseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(mainView);
        make.top.mas_equalTo(intentImageView.mas_bottom);
        make.height.mas_equalTo(2 * 242 * kScreenHeightProportion);
    }];
    
#pragma mark - 最新
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = kBlackLabelColor;
    titleLabel.font = FONT(14 * kFontProportion);
    titleLabel.text = @"最新";
    [mainView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(courseTableView.mas_bottom).offset(30 * kScreenHeightProportion);
        make.left.mas_equalTo(courseTableView).offset(10 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(120 * kScreenWidthProportion, 40 * kScreenWidthProportion));
    }];
    
    freshTableView = [[UITableView alloc] init];
    freshTableView.backgroundColor = kWhiteColor;
    freshTableView.delegate = self;
    freshTableView.dataSource = self;
    freshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    freshTableView.scrollEnabled = NO;
    freshTableView.estimatedRowHeight = 0;
    freshTableView.estimatedSectionHeaderHeight = 0;
    freshTableView.estimatedSectionFooterHeight = 0;
    [mainView addSubview:freshTableView];
    [freshTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(mainView);
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.height.mas_equalTo(3 * 120 * kScreenHeightProportion);
    }];
    
    [mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(freshTableView.mas_bottom);
    }];
}

#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == courseTableView) {
        return 2;
    } else {
        return 3;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == courseTableView) {
        return 242 * kScreenHeightProportion;
    } else {
        return 120 * kScreenHeightProportion;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == courseTableView) {
        static NSString *cellID = @"CourseTableViewCell";
        CourseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[CourseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.superVC = self;
        }
        // 取消点击cell的效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLabel.text = @"热门课程";
        
        return cell;
        
    } else {
        static NSString *cellID = @"NewestTableViewCell";
        NewestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[NewestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        // 取消点击cell的效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.iconImageView.backgroundColor = kRedColor;
        cell.classLabel.text = @"学习工作";
        cell.nameLabel.text = @"《直面就业问题》";
        cell.detailLabel.text = @"面对就业我们为你提供最专业的客观分析";
        cell.hotLabel.text = @"75万";
        cell.dateLabel.text = @"2018.02.17 上新";
        
        CGFloat height = [cell.detailLabel getTitleHeight:cell.detailLabel.text withWidth:146 * kScreenWidthProportion andFont:11];
        cell.detailLabel.numberOfLines = 0;
        [cell.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(height);
        }];
        
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"你点击了第%ld行", indexPath.row);
    
    // 跳转到资讯详情页面
    [self showTabBarView:NO];
    AudioPlayViewController *pushVC = [[AudioPlayViewController alloc] init];
    //pushVC.idStr = [NSString stringWithFormat:@"%ld", indexPath.row];
    [self.navigationController pushViewController:pushVC animated:YES];
    
}

#pragma mark - 按钮点击方法

- (void)initData {
    NSString *url = [NSString stringWithFormat:@"%@",kHomeIndexURL];
    url = [self stitchingTokenAndPlatformForURL:url];
   
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        //判断有无数据
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            if ([errorCode isEqualToString:@"-1"]){
                //判断当前是不是登陆页面
                if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[LoginViewController class]]) {
                    return;
                }
                
                //未登陆
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                
                [self.navigationController pushViewController:loginVC animated:YES];
                return;
            }
            
            if ([errorCode isEqualToString:@"0"]) {
                NSDictionary *dataDic = dict[@"data"];
                //处理数据
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

#pragma mark - 获取banner图
- (void) getBannerAPI{
    NSString *url = [NSString stringWithFormat:@"%@",kBannerURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        //判断有无数据
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            
            if ([errorCode isEqualToString:@"0"]) {
                NSDictionary *dataDic = dict[@"data"];
                //处理数据
                NSArray *infoArray = dataDic[@"info"];
                
                NSMutableArray *pathArray = [[NSMutableArray alloc] init];
                for (NSDictionary *temp in infoArray) {
                    [pathArray addObject:temp[@"image_path"]];
                }
                
                bannerScrollView.imageURLStringsGroup = pathArray;
                
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

#pragma mark - 获取专业
- (void)getProfessionListAPI {
    NSString *url = [NSString stringWithFormat:@"%@",kGetProfessionListURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        //判断有无数据
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            if ([errorCode isEqualToString:@"-1"]){
                //判断当前是不是登陆页面
                if ([[self.navigationController.viewControllers lastObject] isKindOfClass:[LoginViewController class]]) {
                    return;
                }
                
                //未登陆
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                
                [self.navigationController pushViewController:loginVC animated:YES];
                return;
            }
            
            if ([errorCode isEqualToString:@"0"]) {
                NSDictionary *dataDic = dict[@"data"];
                //处理数据
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

#pragma mark - 未读消息API
- (void) initNoticeNotReadAPI{
    NSString *url = [NSString stringWithFormat:@"%@", kNoticeReadNumURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
        
        //判断有无数据
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            
            if ([errorCode isEqualToString:@"0"]) {
                NSDictionary *dataDic = dict[@"data"];
                NSString *num = [NSString stringWithFormat:@"%@", dataDic[@"num"]];
                
                if (![[self stringForNull:num] isEqualToString:@""]) {
                    redLabel.hidden = NO;
                }
                
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
