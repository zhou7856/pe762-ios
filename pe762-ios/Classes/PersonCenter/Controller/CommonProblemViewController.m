//
//  CommonProblemViewController.m
//  pe762-ios
//
//  Created by Future on 2018/4/23.
//  Copyright © 2018年 zmit. All rights reserved.
//  常见问题页面

#import "CommonProblemViewController.h"
#import "ProblemTableViewCell.h"//常见问题cell
#import "ProblemDetailViewController.h"//常见问题详情

@interface CommonProblemViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *majorBtn;//专业
    UILabel *typeLabel;//页面标题
    UIButton *noticeBtn;//消息通知
    
    UITableView *problemTabelView;//问题列表
    NSMutableArray *dataArray;
}
@end

@implementation CommonProblemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建页面
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 加在数据
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void) initUI{
#pragma mark - 头部、底部
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = kWhiteColor;
    
    majorBtn = [[UIButton alloc] init];
    noticeBtn = [[UIButton alloc] init];
    typeLabel = [[UILabel alloc] init];
    [self createNavigationFeatureAndTitle:@"常见问题" withLeftBtn:majorBtn andRightBtn:noticeBtn andTypeTitle:typeLabel];
    
    [majorBtn addTarget:self action:@selector(majorBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [noticeBtn addTarget:self action:@selector(noticeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    typeLabel.text = @"专业";
    
    [self createEndBackView];
    
#pragma mark - 内容
    problemTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, kScreenWidth, kScreenHeight - kHeaderHeight - kEndBackViewHeight) style:UITableViewStylePlain];
    problemTabelView.backgroundColor = kWhiteColor;
    problemTabelView.delegate = self;
    problemTabelView.dataSource = self;
    problemTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    problemTabelView.estimatedRowHeight = 0;
    problemTabelView.estimatedSectionHeaderHeight = 0;
    problemTabelView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:problemTabelView];
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
    
    return 37 * kScreenHeightProportion;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"ProblemTableViewCell";
    ProblemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ProblemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    // 取消点击cell的效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.contentLabel.text = @"取消点击cell的效果取消点击cell的效果取消点击cell的效果";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"你点击了第%ld行", indexPath.row);
    
    // 取数据
    NSDictionary *dict = dataArray[indexPath.row];
    NSString *idStr = [NSString stringWithFormat:@"%@", dict[@"id"]];
    
    // 跳转到详情页面
    ProblemDetailViewController *pushVC = [[ProblemDetailViewController alloc] init];
    pushVC.idStr = idStr;
    pushVC.type = @"2";
    [self.navigationController pushViewController:pushVC animated:YES];
    
}

#pragma mark - 按钮点击方法
// 专业
- (void) majorBtnAction{
    NSLog(@"专业");
    [self showTabBarView:NO];
    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
}

// 消息通知
- (void) noticeBtnAction{
    NSLog(@"消息通知");
    [self showTabBarView:NO];
    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
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
