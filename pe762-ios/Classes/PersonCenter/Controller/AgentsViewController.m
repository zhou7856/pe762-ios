//
//  AgentsViewController.m
//  pe762-ios
//
//  Created by wsy on 2018/4/24.
//  Copyright © 2018年 zmit. All rights reserved.
//  代理商页面

#import "AgentsViewController.h"
#import "RegisteredUserTableViewCell.h" //注册用户cell
#import "ClearingTableViewCell.h" //结算cell
#import "ClearingDetailsViewController.h" //结算详情

@interface AgentsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    //0 注册用户 1 vip用户 2 已结算
    NSInteger type;
    
    UIView *clearingView; //结算页面
    UILabel *numberLabel;
    UILabel *priceLabel;
    
    UITableView *listTableView;
    NSArray *listDataArray;
    
}
@end

@implementation AgentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTabBarView:NO];
}

- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)initNav {
    self.view.backgroundColor = RGB(243, 243, 243);
    [self createNavigationTitle:@"代理商"];
    
    [self createEndBackView];
}

- (void)initUI {
    NSArray *titleArray = @[@"注册用户",@"VIP用户",@"已结算"];
    
    for (int i = 0; i < 3; i++) {
        UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(40 * kScreenWidthProportion + 80 * kScreenWidthProportion * i, 30 * kScreenWidthProportion + kHeaderHeight, 80 * kScreenWidthProportion, 30 * kScreenWidthProportion)];
        titleButton.tag = kTagStart + 10000 + i;
        [titleButton setTitle:titleArray[i] forState:0];
        [titleButton setTitleColor:kGrayLabelColor forState:0];
        titleButton.titleLabel.font = FONT(13 * kFontProportion);
        [self.view addSubview:titleButton];
        
        if (i != 2) {
            UIView *lineView = [UIView viewWithFrame:CGRectMake(titleButton.maxY, titleButton.minY + 9 * kScreenWidthProportion, 2, 12 * kScreenWidthProportion) backgroundColor:RGB(215, 215, 215)];
            [self.view addSubview:lineView];
        }
        
        [[titleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            type = i;
            [self typeChangeAPI:i];
        }];
    }
    
    clearingView = [[UIView alloc] init];
    [self.view addSubview:clearingView];
    
    [clearingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(kHeaderHeight + 70 * kScreenWidthProportion);
        make.height.mas_equalTo(75 * kScreenWidthProportion);
    }];
    
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentLeft font:12];
        titleLabel.text = @"注册会员 :";
        [clearingView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18 * kScreenWidthProportion);
            make.top.mas_equalTo(5 * kScreenWidthProportion);
            make.height.mas_equalTo(20 * kScreenWidthProportion);
        }];
        
        numberLabel = [[UILabel alloc] init];
        [numberLabel setLabelWithTextColor:RGB(130, 34, 194) textAlignment:NSTextAlignmentCenter font:13];
        [clearingView addSubview:numberLabel];
        numberLabel.text = @"100";
        
        [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(titleLabel);
            make.left.mas_equalTo(titleLabel.mas_right);
        }];
        
        UILabel *unitLabel = [[UILabel alloc] init];
        [unitLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentRight font:12];
        unitLabel.text = @" 人";
        [clearingView addSubview:unitLabel];
        
        [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(titleLabel);
            make.left.mas_equalTo(numberLabel.mas_right);
        }];
        
    }
    
    {

        UILabel *unitLabel = [[UILabel alloc] init];
        [unitLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentRight font:12];
        unitLabel.text = @" 元";
        [clearingView addSubview:unitLabel];

        [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(clearingView).offset(-15 * kScreenWidthProportion);
            make.centerY.mas_equalTo(numberLabel);
            make.height.mas_equalTo(numberLabel);
        }];

        priceLabel = [[UILabel alloc] init];
        [priceLabel setLabelWithTextColor:RGB(130, 34, 194) textAlignment:NSTextAlignmentCenter font:13];
        [clearingView addSubview:priceLabel];
        priceLabel.text = @"1500";

        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(unitLabel.mas_left);
            make.centerY.mas_equalTo(numberLabel);
            make.height.mas_equalTo(numberLabel);
        }];

        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentLeft font:12];
        titleLabel.text = @"可结算金额 :";
        [clearingView addSubview:titleLabel];

        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(priceLabel.mas_left);
            make.centerY.mas_equalTo(numberLabel);
            make.height.mas_equalTo(numberLabel);
        }];
    }
    
    UIButton *applyBtn = [[UIButton alloc] initWithFrame:CGRectMake(15 * kScreenWidthProportion, 35 * kScreenWidthProportion, 290 * kScreenWidthProportion, 30 * kScreenWidthProportion)];
    [applyBtn setTitle:@"申请结算" forState:0];
    [applyBtn setTitleColor:kWhiteColor forState:0];
    applyBtn.titleLabel.font = FONT(15 * kFontProportion);
    applyBtn.backgroundColor = RGB(130, 34, 194);
    [applyBtn setCornerRadius:15 * kScreenWidthProportion];
    [clearingView addSubview:applyBtn];
    
    listTableView = [[UITableView alloc] init];
    listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listTableView.delegate = self;
    listTableView.dataSource = self;
//    listTableView.scrollEnabled =NO; //设置tableview 不能滚动
    [self.view addSubview:listTableView];
    listTableView.backgroundColor = self.view.backgroundColor;
    
    [listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(clearingView.mas_bottom);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-kEndBackViewHeight);
    }];
    clearingView.hidden = YES;
    
    if (@available(iOS 11.0, *)) {
        listTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        listTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        listTableView.scrollIndicatorInsets = listTableView.contentInset;
        listTableView.estimatedRowHeight =0;
        listTableView.estimatedSectionHeaderHeight =0;
        listTableView.estimatedSectionFooterHeight =0;
    }
    
    [self typeChangeAPI:0];
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return listDataArray.count;
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (type == 0 || type == 1) {
        return 75 * kScreenWidthProportion;
    }
    
    return 65 * kScreenWidthProportion;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (type == 0 || type == 1) {
        static NSString *cellID = @"RegisteredUserTableViewCell";
        RegisteredUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[RegisteredUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.backgroundColor = self.view.backgroundColor;

        cell.headImageView.backgroundColor = [UIColor greenColor];

        cell.nameLabel.text = @"Anny02";
        cell.phoneLabel.text = @"1524385897";
        cell.timeLabel.text = @"注册时间：2018-03-11";

        return cell;
    }
    
    static NSString *cellID = @"ClearingTableViewCell";
    ClearingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ClearingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = self.view.backgroundColor;
    
    cell.priceLabel.text = @"1500";
    cell.numberLabel.text = @"10";
    cell.timeLabel.text = @"2018-03-11";

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController pushViewController:[ClearingDetailsViewController new] animated:YES];
}

#pragma mark - 按钮点击
- (void)typeChangeAPI:(NSInteger) typeNumber {
    type = typeNumber;
    if (type == 1) {
        clearingView.hidden = NO;
        [clearingView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(75 * kScreenWidthProportion);
        }];
    } else {
        clearingView.hidden = YES;
        [clearingView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    
    for (int i = 0; i < 3; i++)  {
        NSInteger tagNumber = i + kTagStart + 10000;
        UIButton *titleButton = [self.view viewWithTag:tagNumber];
        if (i == typeNumber) {
            [titleButton setTitleColor:RGB(130, 34, 194) forState:0];
        } else {
            [titleButton setTitleColor:kGrayLabelColor forState:0];
        }
    }
    
    [listTableView reloadData];
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
