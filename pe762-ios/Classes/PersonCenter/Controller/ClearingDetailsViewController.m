//
//  ClearingDetailsViewController.m
//  pe762-ios
//
//  Created by wsy on 2018/4/24.
//  Copyright © 2018年 zmit. All rights reserved.
//  结算详情页面

#import "ClearingDetailsViewController.h"
#import "ClearingDetailsTableViewCell.h"

@interface ClearingDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *listTableView;
    NSArray *listDataArray;
    
    UILabel *priceLabel;
    UILabel *numberLabel;
}
@end

@implementation ClearingDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTabBarView:NO];
}

- (void)initNav {
    self.view.backgroundColor = RGB(243, 243, 243);
    [self createNavigationTitle:@"结算详情"];
    
    [self createEndBackView];
}

- (void)initUI {
    
    UIView *clearingView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * kScreenWidthProportion + kHeaderHeight, kScreenWidth, 30 * kScreenWidthProportion)];
    [self.view addSubview:clearingView];
    
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentLeft font:12];
        titleLabel.text = @"金额 :";
        [clearingView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18 * kScreenWidthProportion);
            make.top.mas_equalTo(5 * kScreenWidthProportion);
            make.height.mas_equalTo(20 * kScreenWidthProportion);
        }];
        
        numberLabel = [[UILabel alloc] init];
        [numberLabel setLabelWithTextColor:RGB(130, 34, 194) textAlignment:NSTextAlignmentCenter font:13];
        [clearingView addSubview:numberLabel];
        numberLabel.text = @"1500";
        
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(titleLabel);
            make.left.mas_equalTo(titleLabel.mas_right);
        }];
        
        UILabel *unitLabel = [[UILabel alloc] init];
        [unitLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentRight font:12];
        unitLabel.text = @" 元";
        [clearingView addSubview:unitLabel];
        
        [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(titleLabel);
            make.left.mas_equalTo(numberLabel.mas_right);
        }];
        
    }
    
    {
        
        UILabel *unitLabel = [[UILabel alloc] init];
        [unitLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentRight font:12];
        unitLabel.text = @" 人";
        [clearingView addSubview:unitLabel];
        
        [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(clearingView).offset(-15 * kScreenWidthProportion);
            make.centerY.mas_equalTo(numberLabel);
            make.height.mas_equalTo(numberLabel);
        }];
        
        priceLabel = [[UILabel alloc] init];
        [priceLabel setLabelWithTextColor:RGB(130, 34, 194) textAlignment:NSTextAlignmentCenter font:13];
        [clearingView addSubview:priceLabel];
        priceLabel.text = @"10";
        
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(unitLabel.mas_left);
            make.centerY.mas_equalTo(numberLabel);
            make.height.mas_equalTo(numberLabel);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentLeft font:12];
        titleLabel.text = @"人数 :";
        [clearingView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(priceLabel.mas_left);
            make.centerY.mas_equalTo(numberLabel);
            make.height.mas_equalTo(numberLabel);
        }];
    }
    
    listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, clearingView.maxY, kScreenWidth, kScreenHeight - clearingView.maxY - kEndBackViewHeight)];
    listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listTableView.delegate = self;
    listTableView.dataSource = self;
    //    listTableView.scrollEnabled =NO; //设置tableview 不能滚动
    [self.view addSubview:listTableView];
    listTableView.backgroundColor = self.view.backgroundColor;
    
    if (@available(iOS 11.0, *)) {
        listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        listTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        listTableView.scrollIndicatorInsets = listTableView.contentInset;
        listTableView.estimatedRowHeight =0;
        listTableView.estimatedSectionHeaderHeight =0;
        listTableView.estimatedSectionFooterHeight =0;
    }
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50 * kScreenWidthProportion;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"ClearingDetailsTableViewCell";
    ClearingDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ClearingDetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = self.view.backgroundColor;
    
    cell.headImgeView.backgroundColor = [UIColor greenColor];
    
    cell.nameLabel.text = @"Anny01";
    
    cell.phoneLabel.text = @"15055301588";
    
    cell.timeLabel.text = @"2018-03-11";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
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
