//
//  ReadViewController.m
//  pe762-ios
//
//  Created by wsy on 2018/4/20.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import "ReadViewController.h"
#import "informationTableViewCell.h"

@interface ReadViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *informationTabelView;
}
@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建页面
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 显示底部tabbar
    [self showTabBarView:YES];
    // 加在数据
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void) initUI{
#pragma mark - 头部
    self.navigationController.navigationBarHidden = YES;
    
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

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"你点击了第%ld行", indexPath.row);

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
