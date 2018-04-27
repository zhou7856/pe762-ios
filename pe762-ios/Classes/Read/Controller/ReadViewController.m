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


@interface ReadViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *informationTabelView;
    UIButton *searchBtn;
    Boolean isLogin;
}
@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建页面
    [self initUI];
    isLogin = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 显示底部tabbar
    [self showTabBarView:YES];
    // 加在数据
//    if (isLogin == NO) {
//        [self showTabBarView:NO];
//        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
//        isLogin = YES;
//    }
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
    
    UIImageView *searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(298 * kScreenWidthProportion, kStatusHeight + 16, 12, 12)];
    searchImageView.image = [UIImage imageNamed:@"Layer_-1"];
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

#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
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
    
    cell.mainTitleLabel.text = @"如何让你了解孩子的大学生活？";
    cell.subTitleLabel.text = @"愿我们岁月安稳，细水长流";
    cell.contentImageView.backgroundColor = kRedColor;
    cell.sourceAndTimeLabel.text = @"知识超市 10:00";
    cell.zanNumberLabel.text = @"999999999999";
    cell.authorLabel.text = @"作者:如何让你了解孩子的大学生活";

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

    // 跳转到资讯详情页面
    [self showTabBarView:NO];
    InformationDetailViewController *pushVC = [[InformationDetailViewController alloc] init];
    pushVC.idStr = [NSString stringWithFormat:@"%ld", indexPath.row];
    [self.navigationController pushViewController:pushVC animated:YES];
    
}

#pragma mark - 搜索
- (void) searchBtnAction{
    NSLog(@"搜索");
    //[self showTabBarView:NO];
    //[self.navigationController pushViewController:[MessageViewController new] animated:YES];
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
