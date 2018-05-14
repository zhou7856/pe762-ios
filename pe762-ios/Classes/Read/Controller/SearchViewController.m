//
//  SearchViewController.m
//  pe762-ios
//
//  Created by Future on 2018/5/10.
//  Copyright © 2018年 zmit. All rights reserved.
//  搜索页面

#import "SearchViewController.h"
#import "NewestTableViewCell.h"//上新-列表
#import "AudioPlayViewController.h"//音频播放

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    // 历史记录
    UIView *historyView;
    // 分类记录
    UIView *classTypeView;
    // 热门搜索
    UIView *hotTypeView;
    // 分类记录数组
    NSMutableArray *allCourseArray;
    // 热门搜索数组
    NSMutableArray *hotSearchArray;
    // 最新
    UITableView *freshTableView;
    // 搜索的数据
    NSMutableArray *dataArray;
    // 搜索文本
    NSString *keyWordStr;
    // 搜索输入框
    UITextField *searchTextField;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    keyWordStr = @"";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initSearchDataAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initUI
- (void) initUI{
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = kDefaultBackgroundColor;
    
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
    
    
    historyView = [[UIView alloc] init];
    historyView.backgroundColor = kDefaultBackgroundColor;
    [self.view addSubview:historyView];
    [historyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchView.mas_bottom).offset(10 * kScreenHeightProportion);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-kEndBackViewHeight);
    }];
    
#pragma mark - 分类搜索
    UILabel *classTypeLabel = [[UILabel alloc] init];
    classTypeLabel.text = @"分类搜索";
    classTypeLabel.font = FONT(13 * kFontProportion);
    classTypeLabel.textColor = kBlackLabelColor;
    classTypeLabel.textAlignment = NSTextAlignmentLeft;
    [historyView addSubview:classTypeLabel];
    
    [classTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(historyView).offset(6 * kScreenHeightProportion);
        make.left.mas_equalTo(historyView).offset(15 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(100 * kScreenWidthProportion, 20 * kScreenWidthProportion));
    }];
    
    classTypeView = [[UIView alloc] init];
    //classTypeView.backgroundColor = kWhiteColor;
    [historyView addSubview:classTypeView];
    [classTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(classTypeLabel.mas_bottom).offset(10 * kScreenHeightProportion);
        make.left.mas_equalTo(historyView).offset(15 * kScreenWidthProportion);
        make.right.mas_equalTo(historyView).offset(-15 * kScreenWidthProportion);
    }];
    
#pragma mark - 热门搜素
    UILabel *hotTypeLabel = [[UILabel alloc] init];
    hotTypeLabel.text = @"热门搜素";
    hotTypeLabel.font = FONT(13 * kFontProportion);
    hotTypeLabel.textColor = kBlackLabelColor;
    hotTypeLabel.textAlignment = NSTextAlignmentLeft;
    [historyView addSubview:hotTypeLabel];
    
    [hotTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(classTypeView.mas_bottom).offset(6 * kScreenHeightProportion);
        make.left.mas_equalTo(classTypeLabel);
        make.size.mas_equalTo(classTypeLabel);
    }];
    
    hotTypeView = [[UIView alloc] init];
    //hotTypeView.backgroundColor = kWhiteColor;
    [historyView addSubview:hotTypeView];
    [hotTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hotTypeLabel.mas_bottom).offset(10 * kScreenHeightProportion);
        make.left.mas_equalTo(historyView).offset(15 * kScreenWidthProportion);
        make.right.mas_equalTo(historyView).offset(-15 * kScreenWidthProportion);
    }];
    
#pragma mark - 搜索
    freshTableView = [[UITableView alloc] init];
    freshTableView.hidden = YES;
    freshTableView.backgroundColor = kWhiteColor;
    freshTableView.delegate = self;
    freshTableView.dataSource = self;
    freshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    freshTableView.scrollEnabled = NO;
    freshTableView.estimatedRowHeight = 0;
    freshTableView.estimatedSectionHeaderHeight = 0;
    freshTableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:freshTableView];
    [freshTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(historyView);
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
    
    // 获取数据
    NSDictionary *dict = dataArray[indexPath.row];
    
    NSString *avatarPathStr = [NSString stringWithFormat:@"%@%@", kHostURL ,dict[@"thumb"]];
    cell.iconImageView.image = nil;
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:avatarPathStr]];
    
    cell.classLabel.text = [NSString stringWithFormat:@"%@", dict[@"classify_name"]];
    cell.nameLabel.text = [NSString stringWithFormat:@"《%@》", dict[@"title"]];
    cell.detailLabel.text = [NSString stringWithFormat:@"%@", dict[@"introductions"]];
    cell.hotLabel.text = [NSString stringWithFormat:@"%@", dict[@"browse_num"]];
    
    NSString *creatTimeStr = [NSString stringWithFormat:@"%@", dict[@"created_at"]];
    NSString *hmStr = [creatTimeStr substringWithRange:NSMakeRange(0, 10)];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@ 上新", hmStr];
    
    [cell.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(28 * kScreenHeightProportion);
        cell.detailLabel.numberOfLines = 2;
        cell.detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"你点击了第%ld行", indexPath.row);
    
    // 跳转到资讯详情页面
    [self showTabBarView:NO];
    AudioPlayViewController *pushVC = [[AudioPlayViewController alloc] init];
    //pushVC.idStr = [NSString stringWithFormat:@"%ld", indexPath.row];
    [self.navigationController pushViewController:pushVC animated:YES];
    
}


// 历史标签
- (void) initLogTitleLabel:(UIView *)tempView andHistory:(NSMutableArray *)historyArray{
    [tempView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 历史记录标签view
    NSInteger lineNumber = 0;
    int width = (int)(tempView.width);
    int height = (int)(32 * kScreenHeightProportion);
    for (int i = 0; i < historyArray.count; i++) {
        NSDictionary *tempDict = historyArray[i];
        NSString *rendomStr = [[NSString alloc] init];
        UILabel *titleLabel = [[UILabel alloc] init];
        if (tempView == classTypeView) {
            rendomStr = [NSString stringWithFormat:@"%@", tempDict[@"course_name"]];
            titleLabel.tag = kTagStart + 10000 + [tempDict[@"id"] integerValue];
        } else {
            rendomStr = [NSString stringWithFormat:@"%@", tempDict[@"case_value"]];
            titleLabel.tag = kTagStart + 20000 + [tempDict[@"id"] integerValue];
        }
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = RGB(241.0, 241.0, 241.0);
        [titleLabel setBackgroundColor:RGB(241.0, 241.0, 241.0)];
        titleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        [titleLabel setUserInteractionEnabled:YES];
        int labelWidth = (int)[titleLabel getTitleTextWidth:rendomStr font:FONT(12 * kFontProportion)];
        [titleLabel setCornerRadius:2.0f * kScreenHeightProportion];
        labelWidth += (int)(10 * kScreenWidthProportion);
        if (labelWidth > width) {
            lineNumber ++;
            width = (int)(tempView.width);
        }
        titleLabel.text = rendomStr;
        titleLabel.font = FONT(12 * kFontProportion);
        titleLabel.frame = CGRectMake(tempView.width - width, (int)(lineNumber * height), labelWidth, (int)(24 * kScreenHeightProportion));
        [tempView addSubview:titleLabel];
        width = (int)(width - labelWidth - 10 * kScreenWidthProportion);
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            
            NSLog(@"%@ %ld", titleLabel.text, titleLabel.tag);
            
            // 搜索内容不为空 则搜索
            if (![titleLabel.text isEqualToString:@""]) {
                searchTextField.text = titleLabel.text;
                keyWordStr = titleLabel.text;
                //keyWordStr = [titleLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [self searchAudioAPI];
            }
            
        }];
        [titleLabel addGestureRecognizer:tap];
    }
    
    // 跟新高度
    lineNumber += 1;
    [tempView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(lineNumber * height);
    }];
    
}

- (void) searchBtnAction{
    NSLog(@"%@", searchTextField.text);
    // 收起键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    // 搜索内容不为空 则搜索
    if (![searchTextField.text isEqualToString:@""]) {
        // 开始请求
        keyWordStr = searchTextField.text;
//        keyWordStr = [searchTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self searchAudioAPI];
        
        
    } else {
        freshTableView.hidden = YES;
        
        [self initSearchDataAPI];
        
    }
}

#pragma mark - 获取历史记录
- (void) initSearchDataAPI{
    //拼接url
    NSString *url = [NSString stringWithFormat:@"%@", kAudioSearchURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    
    // 添加菊花
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    // 开始请求
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
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
                NSMutableArray *allCourse = [[NSMutableArray alloc] initWithArray:dataDic[@"all_course"]];
                NSMutableArray *hotSearch = [[NSMutableArray alloc] initWithArray:dataDic[@"hot_search"]];
                
                allCourseArray = [[NSMutableArray alloc] init];
                hotSearchArray = [[NSMutableArray alloc] init];
                
                if (allCourse.count == 0 && hotSearch.count == 0) {
                    // 隐藏历史记录view
                    historyView.hidden = YES;
                    freshTableView.hidden = YES;
                    
                } else {
                    // 显示历史记录view
                    historyView.hidden = NO;
                    freshTableView.hidden = YES;
                    
                    // 更新标签
                    if (allCourse.count > 0) {
                        [allCourseArray addObjectsFromArray:allCourse];
                        [self initLogTitleLabel:classTypeView andHistory:allCourseArray];
                    }
                    
                    if (hotSearch.count > 0) {
                        [hotSearchArray addObjectsFromArray:hotSearch];
                        [self initLogTitleLabel:hotTypeView andHistory:hotSearchArray];
                    }
                    
                }
                
            } else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

#pragma mark - 搜索API
- (void) searchAudioAPI{
    //目前不喜欢 点击则点赞
    NSString *url = [NSString stringWithFormat:@"%@", kSearchAudioURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    NSDictionary *parameter = @{
                                @"type":@"",
                                @"title":keyWordStr,
                                @"course_classify_id":@"",
                                @"course_id":@""
                                };
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:parameter withMethod:kPOST withBlock:^(NSDictionary *dict, NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        //判断有无数据
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            
            if ([errorCode isEqualToString:@"0"]) {
                NSDictionary *dataDic = dict[@"data"];
                //处理数据
                dataArray = [[NSMutableArray alloc] init];
                
                if ([dataDic[@"info"] isKindOfClass:[NSArray class]] || [dataDic[@"info"] count] > 0) {
                    [dataArray addObjectsFromArray:dataDic[@"info"]];
                    freshTableView.hidden = NO;
                    historyView.hidden = YES;
                    [freshTableView reloadData];
                } else {
                    freshTableView.hidden = YES;
                    historyView.hidden = NO;
                    [self initSearchDataAPI];
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
