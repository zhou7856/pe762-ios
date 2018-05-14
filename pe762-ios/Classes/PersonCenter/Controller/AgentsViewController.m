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
    NSString *typeStr;
    
    UIView *clearingView; //结算页面
    UILabel *numberLabel;
    UILabel *priceLabel;
    
    UITableView *listTableView;
    NSArray *listDataArray;
    
    // 数据
    NSMutableArray *dataArray;
    // 是否第一次创建页面
    NSInteger isNew;
    
    
}
@end

@implementation AgentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    [self initUI];
    
    typeStr = @"1";
    type = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showTabBarView:NO];
    
    [self typeChangeAPI:type];
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
        numberLabel.text = @"";
        
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
        priceLabel.text = @"";

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
    
    //[self typeChangeAPI:0];
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return listDataArray.count;
    return dataArray.count;
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
        
        
        NSDictionary *dict = dataArray[indexPath.row];
        
        NSString *user_avatar_path = [NSString stringWithFormat:@"%@", dict[@"user_avatar_path"]];
        cell.headImageView.image = nil;
        [cell.headImageView setImageWithURL:[NSURL URLWithString:user_avatar_path]];
        cell.headImageView.backgroundColor = [UIColor greenColor];

        cell.nameLabel.text = [NSString stringWithFormat:@"%@", dict[@"user_name"]];
        cell.phoneLabel.text = [NSString stringWithFormat:@"%@", dict[@"phone"]];
        
        NSString *created_at = [NSString stringWithFormat:@"%@", dict[@"created_at"]];
        NSString *date = [created_at substringToIndex:10];
        cell.timeLabel.text = [NSString stringWithFormat:@"注册时间：%@", date];

        return cell;
    }
    
    static NSString *cellID = @"ClearingTableViewCell";
    ClearingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ClearingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = self.view.backgroundColor;
    
    NSDictionary *dict = dataArray[indexPath.row];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@", dict[@"money"]];
    cell.numberLabel.text = [NSString stringWithFormat:@"%@", dict[@"peo_number"]];
    NSString *created_at = [NSString stringWithFormat:@"%@", dict[@"created_at"]];
    NSString *date = [created_at substringToIndex:10];
    cell.timeLabel.text = date;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (type == 2) {
        NSDictionary *dict = dataArray[indexPath.row];
        NSString *idStr = [NSString stringWithFormat:@"%@", dict[@"id"]];
        ClearingDetailsViewController *pushVC = [[ClearingDetailsViewController alloc] init];
        pushVC.idStr = idStr;
        [self.navigationController pushViewController:pushVC animated:YES];
    }
}

#pragma mark - 按钮点击
- (void)typeChangeAPI:(NSInteger) typeNumber {
    type = typeNumber;
    if (type == 1) {
        clearingView.hidden = NO;
        [clearingView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(75 * kScreenWidthProportion);
        }];
        
        typeStr = @"2";
        
        [self initProxyTeamAPI];
        
    } else {
        clearingView.hidden = YES;
        [clearingView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        
        
        
        if (type == 0) {

            typeStr = @"1";
            [self initProxyTeamAPI];
        } else {
            
            [self initProxyFlowAPI];
        }
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
    
    //[listTableView reloadData];
}

#pragma mark - 代理商API数据
- (void) initProxyTeamAPI{
    NSString *url = [NSString stringWithFormat:@"%@", kProxyTeamURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    NSDictionary *parameter = @{
                                @"type":typeStr
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
                dataArray = [[NSMutableArray alloc] init];
                if ([dataDic[@"info"] isKindOfClass:[NSArray class]] && [dataDic[@"info"] count] > 0) {
                    [dataArray addObjectsFromArray:dataDic[@"info"]];
                }
                
                [listTableView reloadData];
                
                NSString *proxy_money = [NSString stringWithFormat:@"%@", dataDic[@"proxy_money"]];
                numberLabel.text = [NSString stringWithFormat:@"%ld", dataArray.count];
                priceLabel.text = proxy_money;
                
            } else {
                
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];

}

#pragma mark - 结算列表API
- (void) initProxyFlowAPI{
    NSString *url = [NSString stringWithFormat:@"%@", kProxyFlowURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        //判断有无数据
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            
            if ([errorCode isEqualToString:@"0"]) {
                NSDictionary *dataDict = dict[@"data"];
                //处理数据
                dataArray = [[NSMutableArray alloc] init];
                if ([dataDict[@"info"] isKindOfClass:[NSArray class]] && [dataDict[@"info"] count] > 0) {
                    [dataArray addObjectsFromArray:dataDict[@"info"]];
                }
                
                [listTableView reloadData];
                
                
                
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
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
