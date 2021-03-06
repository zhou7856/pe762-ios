//
//  ReadViewController.m
//  pe762-ios
//
//  Created by wsy on 2018/4/20.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import "ReadViewController.h"
#import "informationTableViewCell.h"//资讯cell
#import "InformationDetailViewController.h"//资讯详情
#import "LoginViewController.h"//登录
#import "MessageViewController.h"//消息
#import "ReadSearchViewController.h"


@interface ReadViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *informationTabelView;//资讯列表
    UIButton *searchBtn;//搜索按钮
    
    // 无网络页面
    UIView *notNetView;
    
    //分页
    NSInteger page;
    NSInteger rows;
    //数据
    NSMutableArray *dataArray;
}
@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建页面
    [self initUI];
    // 数据刷新
    [self updataAction];
    // 无网络
    [self initNotNetView];
    
    // 设置rows
    rows = 10;
    
    //notNetView.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 显示底部tabbar
    [self showTabBarView:YES];
    // 加在数据
    [self initReadInformationAPI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void) initUI{
#pragma mark - 头部
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = kWhiteColor;
    
    // 标题
    [self createNavigationTitle:@"读资讯"];
    
    // 搜索按钮
    searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(285 * kScreenWidthProportion, kStatusHeight, 30, 44)];
    [searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(291 * kScreenWidthProportion, kStatusHeight + 12.5, 19, 19)];
    searchImageView.image = [UIImage imageNamed:@"Layer_1_1_1"];
    [self.view addSubview:searchImageView];
    
#pragma mark - 内容
    informationTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, kScreenWidth, kScreenHeight - kHeaderHeight - kTabBarHeight) style:UITableViewStylePlain];
    informationTabelView.backgroundColor = kBackgroundWhiteColor;
    informationTabelView.delegate = self;
    informationTabelView.dataSource = self;
    informationTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    informationTabelView.estimatedRowHeight = 0;
    informationTabelView.estimatedSectionHeaderHeight = 0;
    informationTabelView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:informationTabelView];
}

- (void) initNotNetView{
    notNetView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, kScreenWidth, kScreenHeight - kHeaderHeight - kTabBarHeight)];
    notNetView.backgroundColor = kWhiteColor;
    notNetView.hidden = YES;
    [self.view addSubview:notNetView];
    
    UIImageView *netImageView = [[UIImageView alloc] init];
    netImageView.image = [UIImage imageNamed:@"Group 182"];
    [notNetView addSubview:netImageView];
    
    UILabel *mainTitleLabel = [[UILabel alloc] init];
    mainTitleLabel.text = @"当前无网络";
    mainTitleLabel.textColor = kBlackLabelColor;
    mainTitleLabel.font = FONT(14 * kFontProportion);
    mainTitleLabel.textAlignment = NSTextAlignmentCenter;
    [notNetView addSubview:mainTitleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = @"请打开手机网络";
    subTitleLabel.textColor = RGB(192, 192, 192);
    subTitleLabel.font = FONT(12 * kFontProportion);
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [notNetView addSubview:subTitleLabel];
    
    UIButton *refreshBtn = [[UIButton alloc] init];
    refreshBtn.backgroundColor = RGB(122, 37, 188);
    [refreshBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    refreshBtn.titleLabel.font = FONT(13 * kFontProportion);
    [notNetView addSubview:refreshBtn];
    
    [netImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(notNetView).offset(80 * kScreenHeightProportion);
        make.centerX.mas_equalTo(notNetView);
        make.size.mas_equalTo(CGSizeMake(189 * kScreenHeightProportion, 128 * kScreenWidthProportion));
    }];
    
    [mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(netImageView.mas_bottom).offset(13 * kScreenHeightProportion);
        make.left.right.with.equalTo(notNetView);
        make.height.mas_equalTo(22 * kScreenHeightProportion);
    }];
    
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mainTitleLabel.mas_bottom).offset(4 * kScreenHeightProportion);
        make.left.right.with.equalTo(mainTitleLabel);
        make.height.mas_equalTo(18 * kScreenHeightProportion);
    }];
    
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(subTitleLabel.mas_bottom).offset(76 * kScreenHeightProportion);
        make.left.mas_equalTo(subTitleLabel).offset(10 * kScreenWidthProportion);
        make.right.mas_equalTo(subTitleLabel).offset(-10 * kScreenWidthProportion);
        make.height.mas_equalTo(45 * kScreenHeightProportion);
        [refreshBtn setCornerRadius:(45 * kScreenHeightProportion / 2)];
    }];
}

#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 192 * kScreenHeightProportion;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"informationTableViewCell";
    informationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[informationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    // 取消点击cell的效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 取数据
    NSDictionary *dict = dataArray[indexPath.row];
    
    // 赋值
    NSString *creatTimeStr = [NSString stringWithFormat:@"%@", dict[@"created_at"]];
    NSString *hmStr = [creatTimeStr substringWithRange:NSMakeRange(0, 10)];
    NSString *classifyNameStr = [NSString stringWithFormat:@"%@", dict[@"classify_name"]];
    
    cell.contentImageView.image = nil;
    NSString *thumbPathStr = [NSString stringWithFormat:@"%@", dict[@"thumb_path"]];
    [cell.contentImageView setImageWithURL:[NSURL URLWithString:thumbPathStr]];
    
    cell.mainTitleLabel.text = [NSString stringWithFormat:@"%@", dict[@"title"]];
    cell.subTitleLabel.text = [NSString stringWithFormat:@"%@", dict[@"introductions"]];
    cell.sourceAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", classifyNameStr, hmStr];
    cell.zanNumberLabel.text = [NSString stringWithFormat:@"%@", dict[@"like_num"]];
    cell.authorLabel.text = [NSString stringWithFormat:@"作者:%@", dict[@"author"]];

    // 作者
    CGFloat authorLabelWidth = [cell.authorLabel getTitleTextWidth:cell.authorLabel.text font:FONT(9 * kFontProportion)];
    [cell.authorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if (authorLabelWidth >= 110 * kScreenWidthProportion) {
            make.size.mas_equalTo(CGSizeMake(100 * kScreenWidthProportion, 11 * kScreenHeightProportion));
        } else {
            make.size.mas_equalTo(CGSizeMake(authorLabelWidth, 11 * kScreenHeightProportion));
        }
        
    }];
    
    // 点赞
    CGFloat zanNumberLabelWidth = [cell.zanNumberLabel getTitleTextWidth:cell.zanNumberLabel.text font:FONT(9 * kFontProportion)];
    [cell.zanNumberLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        if (zanNumberLabelWidth >= 24 * kScreenWidthProportion) {
            make.size.mas_equalTo(CGSizeMake(24 * kScreenWidthProportion, 11 * kScreenHeightProportion));
            cell.zanNumberLabel.text = @"999+";
        } else {
            make.size.mas_equalTo(CGSizeMake(zanNumberLabelWidth, 11 * kScreenHeightProportion));
        }
        
    }];
    
//    cell.likeBtn.tag = kTagStart + 10000 + [dict[@"id"] integerValue];
//    [cell.likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"你点击了第%ld行", indexPath.row);

    NSDictionary *dict = dataArray[indexPath.row];
    NSString *idStr = [NSString stringWithFormat:@"%@", dict[@"id"]];
    
    // 跳转到资讯详情页面
    [self showTabBarView:NO];
    InformationDetailViewController *pushVC = [[InformationDetailViewController alloc] init];
    pushVC.idStr = idStr;
    [self.navigationController pushViewController:pushVC animated:YES];
    
}

#pragma mark - 搜索
- (void) searchBtnAction{
    NSLog(@"搜索");
    //[self showTabBarView:NO];
    //[self.navigationController pushViewController:[MessageViewController new] animated:YES];
    [self showTabBarView:NO];
    ReadSearchViewController *pushVC = [[ReadSearchViewController alloc] init];
    [self.navigationController pushViewController:pushVC animated:YES];
}

#pragma mark - 点赞
- (void) likeBtnAction:(UIButton *)likeBtn{
    NSString *readIdStr = [NSString stringWithFormat:@"%ld", likeBtn.tag - kTagStart - 10000];
    
    if (likeBtn.isSelected) {
        //目前喜欢 点击取消点赞
        NSString *url = [NSString stringWithFormat:@"%@",kLikeDeleteURL];
        url = [self stitchingTokenAndPlatformForURL:url];
        NSDictionary *parameter = @{
                                    @"id":readIdStr,
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
                    likeBtn.selected = NO;
                    [self initReadInformationAPI];
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
                                    @"id":readIdStr,
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

                    [self initReadInformationAPI];

                }else {
                    [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                    return;
                }
            }
        }];
    }
    
}

#pragma mark - 读资讯API
- (void)initReadInformationAPI{
    //重置page
    page = 1;
    
    //拼接url
    NSString *url = [NSString stringWithFormat:@"%@", kReadInformationHomeURL];
    url = [self stitchingTokenAndPlatformForURL:url];

    NSDictionary *parameters = @{
                                 @"title":@"",
                                 @"page":[NSString stringWithFormat:@"%ld", page],
                                 @"rows":[NSString stringWithFormat:@"%ld", rows]
                                 };
    
    // 添加菊花
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    // 开始请求
    [self defaultRequestwithURL:url withParameters:parameters withMethod:kPOST withBlock:^(NSDictionary *dict, NSError *error) {
        // 隐藏菊花
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        
        //判断有无数据
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            if ([errorCode isEqualToString:@"-1"]){
                //未登陆
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                [self.navigationController pushViewController:loginVC animated:YES];
                return;
            }
            
            if ([errorCode isEqualToString:@"0"]) {
                NSDictionary *dataDic = dict[@"data"];
                
                dataArray = [[NSMutableArray alloc] init];
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                
                if ([dataDic[@"info"] isKindOfClass:[NSArray class]]) {
                    if ([dataDic[@"info"] count] > 0) {
                        page++;
                        [tempArray addObjectsFromArray:dataDic[@"info"]];
                    }
                }
                
                [dataArray addObjectsFromArray:tempArray];
                
                [informationTabelView reloadData];
                
            } else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

- (void) updataAction{
    // 下拉刷新
    informationTabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //重置page
        page = 1;
        
        //拼接url
        NSString *url = [NSString stringWithFormat:@"%@", kReadInformationHomeURL];
        url = [self stitchingTokenAndPlatformForURL:url];
        
        NSDictionary *parameters = @{
                                     @"title":@"",
                                     @"page":[NSString stringWithFormat:@"%ld", page],
                                     @"rows":[NSString stringWithFormat:@"%ld", rows]
                                     };
        
        // 添加菊花
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
        // 开始请求
        [self defaultRequestwithURL:url withParameters:parameters withMethod:kPOST withBlock:^(NSDictionary *dict, NSError *error) {
            // 隐藏菊花
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            [informationTabelView.mj_header endRefreshing];
            
            //判断有无数据
            if ([[dict allKeys] containsObject:@"errorCode"]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
                if ([errorCode isEqualToString:@"-1"]){
                    //未登陆
                    LoginViewController *loginVC = [[LoginViewController alloc] init];
                    [self.navigationController pushViewController:loginVC animated:YES];
                    return;
                }
                
                if ([errorCode isEqualToString:@"0"]) {
                    NSDictionary *dataDic = dict[@"data"];
                    
                    dataArray = [[NSMutableArray alloc] init];
                    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                    
                    if ([dataDic[@"info"] isKindOfClass:[NSArray class]]) {
                        if ([dataDic[@"info"] count] > 0) {
                            page++;
                            [tempArray addObjectsFromArray:dataDic[@"info"]];
                        }
                    }
                    [dataArray addObjectsFromArray:tempArray];
                    
                    [informationTabelView reloadData];
                    
                } else {
                    [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                    return;
                }
            }
        }];
        
    }];
    
    //上啦加载
    informationTabelView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (page == 1) {
            [informationTabelView.mj_footer endRefreshing];
            return;
        }
        
        //拼接url
        NSString *url = [NSString stringWithFormat:@"%@", kReadInformationHomeURL];
        url = [self stitchingTokenAndPlatformForURL:url];
        
        NSDictionary *parameters = @{
                                     @"title":@"",
                                     @"page":[NSString stringWithFormat:@"%ld", page],
                                     @"rows":[NSString stringWithFormat:@"%ld", rows]
                                     };
        
        // 添加菊花
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
        // 开始请求
        [self defaultRequestwithURL:url withParameters:parameters withMethod:kPOST withBlock:^(NSDictionary *dict, NSError *error) {
            // 隐藏菊花
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            [informationTabelView.mj_footer endRefreshing];
            
            //判断有无数据
            if ([[dict allKeys] containsObject:@"errorCode"]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
                if ([errorCode isEqualToString:@"-1"]){
                    //未登陆
                    LoginViewController *loginVC = [[LoginViewController alloc] init];
                    [self.navigationController pushViewController:loginVC animated:YES];
                    return;
                }
                
                if ([errorCode isEqualToString:@"0"]) {
                    NSDictionary *dataDic = dict[@"data"];
                    
                    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                    
                    if ([dataDic[@"info"] isKindOfClass:[NSArray class]]) {
                        if ([dataDic[@"info"] count] > 0) {
                            page++;
                            [tempArray addObjectsFromArray:dataDic[@"info"]];
                        }
                    }
                    [dataArray addObjectsFromArray:tempArray];
                    
                    [informationTabelView reloadData];
                    
                } else {
                    [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                    return;
                }
            }
        }];
        
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
