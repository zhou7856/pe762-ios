//
//  ListViewController.m
//  pe762-ios
//
//  Created by Future on 2018/4/24.
//  Copyright © 2018年 zmit. All rights reserved.
//  列表页面

#import "ListViewController.h"
#import "NewestTableViewCell.h"//上新-列表
#import "AudioPlayViewController.h"//音频播放

@interface ListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *majorBtn;//专业
    UILabel *typeLabel;//页面标题
    UIButton *noticeBtn;//消息通知
    UILabel *redLabel;//未读消息数
    
    UITableView *freshTableView;//最新
}
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 加载数据
    [self initData];
    
    // 红点
    [self initNoticeNotReadAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void)initUI {
#pragma mark - 头部、底部
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
    
    // 底部
    [self createEndBackView];
    
#pragma mark - 搜索
    UIView *searchView = [[UIView alloc] init];
    [searchView setCornerRadius:(10 * kScreenHeightProportion)];
    searchView.backgroundColor = kBackgroundWhiteColor;
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kHeaderHeight + 10 * kScreenHeightProportion);
        make.left.mas_equalTo(self.view).offset(35 * kScreenWidthProportion);
        make.right.mas_equalTo(self.view).offset(-35 * kScreenWidthProportion);
        make.height.mas_equalTo(20 * kScreenHeightProportion);
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
    
#pragma mark - 讲专业、降学压、填志愿 74
    // 讲专业
    UIImageView *professionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 103"]];
    [self.view addSubview:professionImageView];
    [professionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchView.mas_bottom).offset(10 * kScreenHeightProportion);
        make.left.mas_equalTo(searchView.mas_left).offset(10 * kScreenHeightProportion);
        make.size.mas_equalTo(CGSizeMake(49 * kScreenWidthProportion, 49 * kScreenWidthProportion));
    }];
    
    UILabel *professionLabel = [[UILabel alloc] init];
    professionLabel.text = @"讲专业";
    professionLabel.font = FONT(10 * kFontProportion);
    professionLabel.textColor = kBlackLabelColor;
    professionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:professionLabel];
    [professionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(professionImageView.mas_bottom).offset(2 * kScreenWidthProportion);
        make.left.right.mas_equalTo(professionImageView);
        make.height.mas_equalTo(13 * kScreenWidthProportion);
    }];
    
    UIButton *proBtn = [[UIButton alloc] init];
    proBtn.tag = 1;
    [proBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:proBtn];
    [proBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(professionImageView);
        make.left.right.mas_equalTo(professionImageView);
        make.height.mas_equalTo(74 * kScreenWidthProportion);
    }];
    
    // 降学压
    UIImageView *pressureImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 105"]];
    [self.view addSubview:pressureImageView];
    [pressureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(professionImageView.mas_top);
        make.right.mas_equalTo(searchView.mas_right).offset(-10 * kScreenHeightProportion);
        make.size.mas_equalTo(CGSizeMake(49 * kScreenWidthProportion, 49 * kScreenWidthProportion));
    }];
    
    UILabel *pressureLabel = [[UILabel alloc] init];
    pressureLabel.text = @"降学压";
    pressureLabel.font = FONT(10 * kFontProportion);
    pressureLabel.textColor = kBlackLabelColor;
    pressureLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:pressureLabel];
    [pressureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pressureImageView.mas_bottom).offset(2 * kScreenWidthProportion);
        make.left.right.mas_equalTo(pressureImageView);
        make.height.mas_equalTo(13 * kScreenWidthProportion);
    }];
    
    UIButton *preBtn = [[UIButton alloc] init];
    preBtn.tag = 3;
    [preBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:preBtn];
    [preBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pressureImageView);
        make.left.right.mas_equalTo(pressureImageView);
        make.height.mas_equalTo(74 * kScreenWidthProportion);
    }];
    
    // 填志愿
    UIImageView *intentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 104"]];
    [self.view addSubview:intentImageView];
    [intentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(searchView.mas_centerX);
        make.top.mas_equalTo(professionImageView.mas_top);
        make.size.mas_equalTo(CGSizeMake(49 * kScreenWidthProportion, 49 * kScreenWidthProportion));
    }];
    
    UILabel *intentLabel = [[UILabel alloc] init];
    intentLabel.text = @"填志愿";
    intentLabel.font = FONT(10 * kFontProportion);
    intentLabel.textColor = kBlackLabelColor;
    intentLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:intentLabel];
    [intentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(intentImageView.mas_bottom).offset(2 * kScreenWidthProportion);
        make.left.right.mas_equalTo(intentImageView);
        make.height.mas_equalTo(13 * kScreenWidthProportion);
    }];
    
    UIButton *intBtn = [[UIButton alloc] init];
    intBtn.tag = 2;
    [intBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:intBtn];
    [intBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(intentImageView);
        make.left.right.mas_equalTo(intentImageView);
        make.height.mas_equalTo(74 * kScreenWidthProportion);
    }];
    
#pragma mark - 列表
    freshTableView = [[UITableView alloc] init];
    freshTableView.backgroundColor = kWhiteColor;
    freshTableView.delegate = self;
    freshTableView.dataSource = self;
    freshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    freshTableView.estimatedRowHeight = 0;
    freshTableView.estimatedSectionHeaderHeight = 0;
    freshTableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:freshTableView];
    [freshTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(professionImageView.mas_bottom).offset(30 * kScreenHeightProportion);
        make.bottom.mas_equalTo(self.view).offset(-kEndBackViewHeight);
    }];
    
}

#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120 * kScreenHeightProportion;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"你点击了第%ld行", indexPath.row);
    
    // 跳转到资讯详情页面
    //    [self showTabBarView:NO];
        AudioPlayViewController *pushVC = [[AudioPlayViewController alloc] init];
    //    pushVC.idStr = [NSString stringWithFormat:@"%ld", indexPath.row];
        [self.navigationController pushViewController:pushVC animated:YES];
    
}

#pragma mark - 按钮点击方法
- (void) btnAction:(UIButton *)temp{
    if (temp.tag == 1) {
        
        NSLog(@"讲专业");
        
    } else if (temp.tag == 2) {
        
        NSLog(@"填志愿");
        
    } else {
        
        NSLog(@"降学压");
    }
}

- (void)initData {
    NSString *url = [NSString stringWithFormat:@"%@",kGetAudioListURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    NSDictionary *parameter = @{
                                @"type":@"5",
                                @"title":@"哲学A",
                                @"course_classify_id":@"1"
                                };
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:parameter withMethod:kPOST withBlock:^(NSDictionary *dict, NSError *error) {
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
