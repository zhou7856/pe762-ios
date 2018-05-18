//
//  ReadSearchViewController.m
//  pe762-ios
//
//  Created by Future on 2018/5/17.
//  Copyright © 2018年 zmit. All rights reserved.
//  读咨询搜索页面

#import "ReadSearchViewController.h"
#import "informationTableViewCell.h"//资讯cell
#import "InformationDetailViewController.h"//资讯详情

@interface ReadSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    // 最新
    UITableView *informationTabelView;
    // 搜索的数据
    NSMutableArray *dataArray;
    // 搜索文本
    NSString *keyWordStr;
    // 搜索输入框
    UITextField *searchTextField;
    //分页
    NSInteger page;
    NSInteger rows;
    
}
@end

@implementation ReadSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
    keyWordStr = @"";
    [self updataAction];
    page = 1;
    rows = 10;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initUI
- (void) initUI{
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = kBackgroundWhiteColor;
    
    [self createEndBackView];
    
#pragma mark - 搜索框
    UIView *searchView = [[UIView alloc] init];
    searchView.backgroundColor = kWhiteColor;
    [self.view addSubview:searchView];
    
    // 12 12
    UIImageView *searchImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Layer_-1"]];
    [searchView addSubview:searchImageView];
    
    searchTextField = [[UITextField alloc] init];
    searchTextField.placeholder = @"哲学类";
    searchTextField.font = FONT(12 * kFontProportion);
    searchTextField.textColor = kBlackLabelColor;
    [searchView addSubview:searchTextField];
    
    UIButton *searchBtn = [[UIButton alloc] init];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:kBlackLabelColor forState:UIControlStateNormal];
    searchBtn.titleLabel.font = FONT(13 * kFontProportion);
    [self.view addSubview:searchBtn];
    
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kStatusHeight + 10 * kScreenHeightProportion);
        make.left.mas_equalTo(self.view).offset(13 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(246 * kScreenWidthProportion, 20 * kScreenHeightProportion));
        [searchView setCornerRadius:2.0f];
    }];
    
    [searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(searchView);
        make.left.mas_equalTo(searchView).offset(9 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(12 * kScreenWidthProportion, 12 * kScreenWidthProportion));
    }];
    
    [searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(searchView);
        make.left.mas_equalTo(searchImageView.mas_right).offset(6 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(210 * kScreenWidthProportion, 12 * kScreenWidthProportion));
    }];
    
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(searchView);
        make.left.mas_equalTo(searchView.mas_right).offset(14 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(30 * kScreenWidthProportion, 20 * kScreenWidthProportion));
    }];
    
#pragma mark - 搜索
    informationTabelView = [[UITableView alloc] init];
    informationTabelView.hidden = NO;
    informationTabelView.backgroundColor = kBackgroundWhiteColor;
    informationTabelView.delegate = self;
    informationTabelView.dataSource = self;
    informationTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    informationTabelView.scrollEnabled = YES;
    informationTabelView.estimatedRowHeight = 0;
    informationTabelView.estimatedSectionHeaderHeight = 0;
    informationTabelView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:informationTabelView];
    [informationTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchView.mas_bottom).offset(10 * kScreenHeightProportion);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-kEndBackViewHeight);
    }];
    
    [searchBtn addTarget:self action:@selector(searchBtnAction) forControlEvents:UIControlEventTouchUpInside];
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


#pragma mark - 搜索点击事件
- (void) searchBtnAction{
    NSLog(@"%@", searchTextField.text);
    // 收起键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    // 搜索内容不为空 则搜索
    if (![searchTextField.text isEqualToString:@""]) {
        // 开始请求
        keyWordStr = searchTextField.text;
        
        [self initReadInformationAPI];
    } else {
        dataArray = nil;
        keyWordStr = @"";
        [informationTabelView reloadData];
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
                                 @"title":keyWordStr,
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
                if(dataArray.count == 0){
                    [self showHUDTextOnly:@"搜索不到任何信息"];
                }
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
                                     @"title":keyWordStr,
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
                                     @"title":keyWordStr,
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
