//
//  PersonCenterViewController.m
//  pe762-ios
//
//  Created by wsy on 2018/4/20.
//  Copyright © 2018年 zmit. All rights reserved.
//  个人中心

#import "PersonCenterViewController.h"
#import "PersonalInformationViewController.h" //个人信息
#import "MyRecordingViewController.h" //  我的收藏夹 （播放记录、下载）
#import "CommonProblemViewController.h"//常见问题
#import "FeedbackViewController.h"//意见反馈
#import "ContactServiceViewController.h"//联系客服
#import "AgentsViewController.h" //代理商
#import "MessageViewController.h" //消息

@interface PersonCenterViewController ()
{
    UIButton *setingBtn; //设置按钮
    UIButton *messageBtn; //消息按钮
    UIImageView *backgroundImageView; //背景图片
    UIView *vipView; //vip页面
    UILabel *vipTimeLabel; //vip剩余天数
    UIButton *renewalsBtn; //续费按钮
    
    UIView *reviewView; //审核页面
    UIView *proxyFeaturesView; //代理功能页面
    
    UIImageView *headImageVIew; //头像
    UILabel *nameLabel;
    UIView *isVipView; //vip显示页面
    UIImageView *editImageView; //编辑图标
    UIView *typeView; //功能按钮页面
    
    NSString *isVip; //是否Vip 0 不是
    NSString *isProxy; //是否代理商
    NSString *audit_status; //代理商审核状态  1审核中 2:失败 3:成功
}
@end

@implementation PersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTabBarView:YES];
    [self initData];
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
}

- (void)initUI {
    backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, kScreenWidth, 178 * kScreenWidthProportion)];
//    backgroundImageView.backgroundColor = [UIColor redColor];
    backgroundImageView.image = [UIImage imageNamed:@"VCG211124209403"];
    [self.view addSubview:backgroundImageView];
    
    vipView = [UIView viewWithFrame:CGRectMake(0, 0, kScreenWidth, 40 * kScreenWidthProportion) backgroundColor:kBlackColor];
    [backgroundImageView addSubview:vipView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"diamond_2_"]];
    [vipView addSubview:iconImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setLabelWithTextColor:kGoldenColor textAlignment:NSTextAlignmentCenter font:13];
    [vipView addSubview:titleLabel];
    titleLabel.text = @"开通会员，免费收听所有音频 >";
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(vipView);
        make.center.mas_equalTo(vipView);
    }];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(25 * kScreenWidthProportion, 19 * kScreenWidthProportion));
        make.right.mas_equalTo(titleLabel.mas_left).offset(-10 * kScreenWidthProportion);
        make.centerY.mas_equalTo(titleLabel);
    }];
    
    UIView *centerView = [UIView viewWithFrame:CGRectMake(12 * kScreenWidthProportion, 115 * kScreenWidthProportion + kHeaderHeight, 296 * kScreenWidthProportion, 320 * kScreenWidthProportion) backgroundColor:kWhiteColor];
    [centerView setCornerRadius:3.f];
    [self.view addSubview:centerView];
    
    headImageVIew = [[UIImageView alloc] init];
    headImageVIew.backgroundColor = [UIColor greenColor];
    [self.view addSubview:headImageVIew];
    
    [headImageVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(82 * kScreenWidthProportion, 82 * kScreenWidthProportion));
        make.top.mas_equalTo(centerView.mas_top).offset(- 41 * kScreenWidthProportion);
        make.centerX.mas_equalTo(centerView);
    }];
    [headImageVIew setCornerRadius:41 * kScreenWidthProportion];
    
    headImageVIew.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        //跳转我的信息
        [self.navigationController pushViewController:[PersonalInformationViewController new] animated:YES];
    }];
    [self.view addGestureRecognizer:tap];
    
    nameLabel = [[UILabel alloc] init];
    [nameLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentCenter font:18];
//    nameLabel.font = FONT_BOLD(15);
    nameLabel.text = @"User name";
    [centerView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50 * kScreenWidthProportion);
        make.centerX.mas_equalTo(centerView);
        make.height.mas_equalTo(20 * kScreenWidthProportion);
    }];
    
    editImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Path 180"]];
    [centerView addSubview:editImageView];
    
    [editImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18 * kScreenWidthProportion, 18 * kScreenWidthProportion));
        make.centerY.mas_equalTo(nameLabel);
        make.left.mas_equalTo(nameLabel.mas_right).offset(5 * kScreenWidthProportion);
    }];
    
    {
        editImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            NSLog(@"编辑");
        }];
        [editImageView addGestureRecognizer:tap];
    }
    
    isVipView = [[UIView alloc] init];
    [centerView addSubview:isVipView];
    [isVipView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(33 * kScreenWidthProportion, 12 * kScreenWidthProportion));
        make.top.mas_equalTo(nameLabel.mas_bottom);
        make.left.right.mas_equalTo(centerView);
        make.height.mas_equalTo(16 * kScreenWidthProportion);
    }];

    UIImageView *vipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 129"]];
    [isVipView addSubview:vipImageView];
    
    [vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(33 * kScreenWidthProportion, 12 * kScreenWidthProportion));
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(2 * kScreenWidthProportion);
        make.centerX.mas_equalTo(isVipView);
    }];
    
    vipTimeLabel = [[UILabel alloc] init];
    [vipTimeLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentLeft font:13];
    vipTimeLabel.text = @"剩余218天";
    [isVipView addSubview:vipTimeLabel];
    
    [vipTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(isVipView);
        make.left.mas_equalTo(vipImageView.mas_right).offset(5 * kScreenWidthProportion);
    }];
    
    renewalsBtn = [[UIButton alloc] init];
    [renewalsBtn setTitle:@"续费" forState:0];
    [renewalsBtn setTitleColor:kWhiteColor forState:0];
    renewalsBtn.backgroundColor = kRedColor;
    [renewalsBtn setCornerRadius:3.f];
    renewalsBtn.titleLabel.font = FONT(13 * kFontProportion);
    [isVipView addSubview:renewalsBtn];
    
    [renewalsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(isVipView);
        make.left.mas_equalTo(vipTimeLabel.mas_right).offset(5 * kScreenWidthProportion);
        make.width.mas_equalTo(40 * kScreenWidthProportion);
    }];
    
    reviewView = [[UIView alloc] init];
    [centerView addSubview:reviewView];
    reviewView.hidden = YES;
    
    [reviewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(isVipView);
    }];
    
    UILabel *reviewTitleLabel = [[UILabel alloc] init];
    [reviewTitleLabel setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentCenter font:13];
    reviewTitleLabel.text = @"代理商申请审核中";
    [reviewView addSubview:reviewTitleLabel];
    
    [reviewTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(reviewView);
//        make.centerX.mas_equalTo(reviewView);
    }];
    
    proxyFeaturesView = [[UIView alloc] initWithFrame:CGRectMake(0, 90 * kScreenWidthProportion, centerView.width, 25 * kScreenWidthProportion)];
    [centerView addSubview:proxyFeaturesView];
    
   {
       UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * kScreenWidthProportion, 0, 120 * kScreenWidthProportion, proxyFeaturesView.height)];
       [titleLabel setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentLeft font:12];
       titleLabel.text = @"查看我的分享二维码";
       [proxyFeaturesView addSubview:titleLabel];
       
       UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.maxX + 3 * kScreenWidthProportion, 0, 6 * kScreenWidthProportion, 9 * kScreenWidthProportion)];
       iconImageView.image = [UIImage imageNamed:@"Path 185"];
       [proxyFeaturesView addSubview:iconImageView];
       iconImageView.centerY = titleLabel.centerY;
       
       UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(titleLabel.minX, 0, iconImageView.maxX, 25 * kScreenWidthProportion)];
       [proxyFeaturesView addSubview:shareBtn];
       [shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
   }
    
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(190 * kScreenWidthProportion, 0, 85 * kScreenWidthProportion, proxyFeaturesView.height)];
        [titleLabel setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentLeft font:12];
        titleLabel.text = @"邀请用户管理";
        [proxyFeaturesView addSubview:titleLabel];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.maxX + 3 * kScreenWidthProportion, 0, 6 * kScreenWidthProportion, 9 * kScreenWidthProportion)];
        iconImageView.image = [UIImage imageNamed:@"Path 185"];
        [proxyFeaturesView addSubview:iconImageView];
         iconImageView.centerY = titleLabel.centerY;
        
        UIButton *userManagementBtn = [[UIButton alloc] initWithFrame:CGRectMake(titleLabel.minX, 0, iconImageView.maxX, 25 * kScreenWidthProportion)];
        [proxyFeaturesView addSubview:userManagementBtn];
        [userManagementBtn addTarget:self action:@selector(userManagementBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *typeView = [[UIView alloc] init];
    [centerView addSubview:typeView];
//    typeView.backgroundColor = kRedColor;
    
    [typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(120 * kScreenWidthProportion);
        make.left.mas_equalTo(20 * kScreenWidthProportion);
        make.width.mas_equalTo(276 * kScreenWidthProportion);
        make.height.mas_equalTo(170 * kScreenWidthProportion);
    }];
    
    NSArray *titleArray = @[@"我的收藏",@"播放记录",@"已下载",@"常见问题",@"意见反馈",@"联系客服"];
    NSArray *imageArray = @[@"Group 120",@"Group 121",@"Group 122",@"Group 125",@"Group 124",@"Group 123"];
    NSMutableArray *viewArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int j = 0; j < 3; j++) {
            UIView *clickView = [[UIView alloc] init];
            [typeView addSubview:clickView];
            //            clickView.backgroundColor = [UIColor yellowColor];
            
            [array addObject:clickView];
            
            UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageArray[i * 3 + j]]];
            [clickView addSubview:iconImageView];
            
            [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(clickView);
                make.size.mas_equalTo(CGSizeMake(40 * kScreenWidthProportion, 40 * kScreenWidthProportion));
                make.top.mas_equalTo(clickView);
            }];
            
            UILabel *titleLabel = [[UILabel alloc] init];
            [titleLabel setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentCenter font:13];
            titleLabel.text = titleArray[i * 3 + j];
            [clickView addSubview:titleLabel];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.width.mas_equalTo(clickView);
                make.top.mas_equalTo(iconImageView.mas_bottom).mas_offset(8 * kScreenWidthProportion);
                make.height.mas_equalTo(20 * kScreenWidthProportion);
            }];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
            [[tap rac_gestureSignal] subscribeNext:^(id x) {
                [self typeClickAction:i * 3 + j];
            }];
            [clickView addGestureRecognizer:tap];
        }
        [viewArray addObject:array];
    }

    for (int i = 0; i < 2; i++) {
        NSArray *array = viewArray[i];
        // 实现masonry水平固定间隔方法
        [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];

        CGFloat topNumber = i * 85 * kScreenWidthProportion;
        // 设置array的垂直方向的约束
        [array mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topNumber);
            make.height.mas_equalTo(85 * kScreenWidthProportion);
        }];
    }
}

- (void)initData {
    NSString *url = [NSString stringWithFormat:@"%@",kGetUserInfoURL];
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
                NSDictionary *serverDic = dataDic[@"server"];
                
                //是否是代理
                isProxy = [NSString stringWithFormat:@"%@", serverDic[@"is_proxy"]];
                [[NSUserDefaults standardUserDefaults] setObject:isProxy forKey:@"is_proxy"];
                //是否vip
                isVip = [NSString stringWithFormat:@"%@", serverDic[@"is_vip"]];
                [[NSUserDefaults standardUserDefaults] setObject:isVip forKey:@"is_vip"];
                
                NSDictionary *infoDic = dataDic[@"info"];
                NSString *avatarUrlStr = [NSString stringWithFormat:@"%@",infoDic[@"avatar_path"]];
                headImageVIew.image = nil;
                [headImageVIew setImageWithURL:[NSURL URLWithString:avatarUrlStr]];
                
                nameLabel.text = [NSString stringWithFormat:@"%@", infoDic[@"name"]];
                vipTimeLabel.text = [NSString stringWithFormat:@"剩余%@天", infoDic[@"days"]];
                
                //根据vip状态切换
                [self changeView];
                
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

#pragma mark - 根据vip状态修改页面
- (void)changeView {
    if ([isVip isEqualToString:@"0"]) {
        vipView.hidden = NO;
        isVipView.hidden = YES;
    } else {
        vipView.hidden = YES;
        isVipView.hidden = NO;
        
        if ([isProxy isEqualToString:@"1"]) {
            if ([audit_status isEqualToString:@"1"]) {
                //审核中
                isVipView.hidden = YES;
                reviewView.hidden = NO;
            } else {
                reviewView.hidden = YES;
                isVipView.hidden = NO;
            }
        }
    }
    
    if ([isProxy isEqualToString:@"1"]) {
        proxyFeaturesView.hidden = NO;
    } else {
        proxyFeaturesView.hidden = YES;
    }
    
}

#pragma makr - 设置点击
- (void)setingBtnAction {
    [self.navigationController pushViewController:[SettingViewController new] animated:YES];
}

#pragma makr - 消息点击
- (void)messageBtnAction {
     [self.navigationController pushViewController:[MessageViewController new] animated:YES];
}

#pragma mark - 功能点击
- (void)typeClickAction:(NSInteger)typeNumber {
    switch (typeNumber) {
        case 0: {
            //我的收藏
            MyRecordingViewController *pushVC = [[MyRecordingViewController alloc] init];
            pushVC.typeNumber = typeNumber;
            [self.navigationController pushViewController:pushVC animated:YES];
        }
            break;
        case 1: {
            //播放记录
            MyRecordingViewController *pushVC = [[MyRecordingViewController alloc] init];
            pushVC.typeNumber = typeNumber;
            [self.navigationController pushViewController:pushVC animated:YES];
        }
            break;
        case 2: {
            //已下载
            MyRecordingViewController *pushVC = [[MyRecordingViewController alloc] init];
            pushVC.typeNumber = typeNumber;
            [self.navigationController pushViewController:pushVC animated:YES];
        }
            break;
        case 3: {
            //常见问题
            [self showTabBarView:NO];
            CommonProblemViewController *pushVC = [[CommonProblemViewController alloc] init];
            //pushVC.typeNumber = typeNumber;
            [self.navigationController pushViewController:pushVC animated:YES];
        }
            break;
        case 4: {
            //意见反馈
            [self showTabBarView:NO];
            FeedbackViewController *pushVC = [[FeedbackViewController alloc] init];
            //pushVC.typeNumber = typeNumber;
            [self.navigationController pushViewController:pushVC animated:YES];
        }
            break;
        case 5: {
            //联系客服
            [self showTabBarView:NO];
            ContactServiceViewController *pushVC = [[ContactServiceViewController alloc] init];
            //pushVC.typeNumber = typeNumber;
            [self.navigationController pushViewController:pushVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 查看我的分享二维码
- (void)shareBtnAction {
    
}

#pragma mark - 用户管理
- (void)userManagementBtnAction {
    [self.navigationController pushViewController:[AgentsViewController new] animated:YES];
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
