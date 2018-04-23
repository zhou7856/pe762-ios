//
//  ConditionFilterPopView.m
//  pf435-company-ios
//
//  Created by wsy on 2017/11/20.
//  Copyright © 2017年 zmit. All rights reserved.
//  条件筛选弹窗

#import "ConditionFilterPopView.h"
#import "ConditionFilterTableViewCell.h" //条件cell

@implementation ConditionFilterPopView

+ (instancetype)initWithconDitionArray:(NSArray *)array block:(FilterPopBlock)block titleStr:(NSString *)titleStr{
    ConditionFilterPopView *popView = [[ConditionFilterPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    popView.block = block;
    popView.conditionArray = array;
    [[UIApplication sharedApplication].keyWindow addSubview:popView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backButton.backgroundColor = RGBA(0, 0, 0, 0.6);
    [backButton addTarget:popView action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [popView addSubview:backButton];
    
    CGFloat tableViewCount = (array.count > 10)?10:array.count;
    CGFloat tableViewHeight = tableViewCount * 40 * kScreenHeightProportion;
    
    CGFloat iphoneX = 0;
    if (kScreenHeight == 812) {
        iphoneX = 34;
    }
    
    //中心view
    UIView *centerView = [UIView viewWithFrame:CGRectMake(0, kScreenHeight - tableViewHeight - 75 * kScreenHeightProportion - iphoneX, kScreenWidth, tableViewHeight + 75 * kScreenHeightProportion) backgroundColor:kWhiteColor];
    [popView addSubview:centerView];
    
    //上部标题
    UIView *topView = [UIView viewWithFrame:CGRectMake(0, 0, kScreenWidth, 40 * kScreenHeightProportion) backgroundColor:kWhiteColor];
    [centerView addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45 * kScreenWidthProportion, 0, 230 * kScreenWidthProportion, 40 * kScreenHeightProportion)];
    [titleLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentCenter font:13];
    titleLabel.text = titleStr;
    [topView addSubview:titleLabel];
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 45 * kScreenWidthProportion, 0, 45 * kScreenWidthProportion, 40 * kScreenHeightProportion)];
    [deleteButton setImage:[UIImage imageNamed:@"icon_job_cancel"] forState:0];
    [topView addSubview:deleteButton];
    [deleteButton addTarget:popView action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *topLine = [UIView viewWithFrame:CGRectMake(0, topView.height - 1, kScreenWidth, 1) backgroundColor:kLineGrayColor];
    [topView addSubview:topLine];
    
    UITableView *dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topView.maxY, kScreenWidth, tableViewHeight)];
    dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    dataTableView.delegate = popView;
    dataTableView.dataSource = popView;
    [centerView addSubview:dataTableView];
    
    UIButton *endButton = [[UIButton alloc] initWithFrame:CGRectMake(0, dataTableView.maxY, kScreenWidth, 35 * kScreenHeightProportion)];
//    [endButton buttonWithTitle:@"取消" withFont:13 withColor:kWhiteColor withBackgroundColor:kDefaultColor];
    [endButton setTitle:@"取消" forState:UIControlStateNormal];
    endButton.titleLabel.font = FONT(13 * kFontProportion);
    [endButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    endButton.backgroundColor = RGB(244, 69, 37);
    [centerView addSubview:endButton];
    [endButton addTarget:popView action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    return popView;

}

#pragma mark - 返回
- (void)backButtonAction {
    [self removeFromSuperview];
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.conditionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40 * kScreenHeightProportion;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"ConditionFilterTableViewCell";
    ConditionFilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ConditionFilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *typeStr = self.conditionArray[indexPath.row];
    cell.titleLabel.text = typeStr;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *typeStr = self.conditionArray[indexPath.row];
    
    if (self.block != nil) {
        self.block(self, typeStr);
    }
}


@end
