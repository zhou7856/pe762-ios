//
//  PersonCenterViewController.m
//  pe762-ios
//
//  Created by wsy on 2018/4/20.
//  Copyright © 2018年 zmit. All rights reserved.
//  个人中心

#import "PersonCenterViewController.h"
#import "PersonalInformationViewController.h" //个人信息

@interface PersonCenterViewController ()
{
    UIButton *setingBtn; //设置按钮
    UIButton *messageBtn; //消息按钮
    UIImageView *backgroundImageView; //背景图片
    UIView *vipView; //vip页面
    UIImageView *headImageVIew; //头像
    UILabel *nameLabel;
    UIImageView *isVipView; //vip显示页面
    UIImageView *editImageView; //编辑图标
    UIView *typeView; //功能按钮页面
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
}

- (void)initUI {
    backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, kScreenWidth, 178 * kScreenWidthProportion)];
    backgroundImageView.backgroundColor = [UIColor redColor];
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
    
    isVipView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 129"]];
    [centerView addSubview:isVipView];
    
    [isVipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(33 * kScreenWidthProportion, 12 * kScreenWidthProportion));
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(2 * kScreenWidthProportion);
        make.centerX.mas_equalTo(centerView);
    }];
    
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

#pragma makr - 设置点击
- (void)setingBtnAction {
    
}

#pragma makr - 消息点击
- (void)messageBtnAction {
    
}

#pragma mark - 功能点击
- (void)typeClickAction:(NSInteger)typeNumber {
    
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
