//
//  MessageViewController.m
//  pe762-ios
//
//  Created by Future on 2018/4/24.
//  Copyright © 2018年 zmit. All rights reserved.
//  消息页面

#import "MessageViewController.h"
#import "MessageTableViewCell.h"//消息cell
#import "ProblemTableViewCell.h"//常见问题cell
#import "ProblemDetailViewController.h"//常见问题详情

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *majorBtn;//专业
    UILabel *typeLabel;//页面标题
    
    UITableView *messageTabelView;//消息列表
}
@end

@implementation MessageViewController

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
    typeLabel = [[UILabel alloc] init];
    [self createNavigationFeatureAndTitle:@"常见问题" withLeftBtn:majorBtn andTypeTitle:typeLabel];
    
    [majorBtn addTarget:self action:@selector(majorBtnAction) forControlEvents:UIControlEventTouchUpInside];
    typeLabel.text = @"专业";
    
    [self createEndBackView];
    
#pragma mark - 内容
    messageTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, kScreenWidth, kScreenHeight - kHeaderHeight - kEndBackViewHeight) style:UITableViewStylePlain];
    messageTabelView.backgroundColor = kWhiteColor;
    messageTabelView.delegate = self;
    messageTabelView.dataSource = self;
    messageTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    messageTabelView.estimatedRowHeight = 0;
    messageTabelView.estimatedSectionHeaderHeight = 0;
    messageTabelView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:messageTabelView];
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
    
    // 跳转到详情页面
    ProblemDetailViewController *pushVC = [[ProblemDetailViewController alloc] init];
    pushVC.idStr = [NSString stringWithFormat:@"%ld", indexPath.row];
    [self.navigationController pushViewController:pushVC animated:YES];
    
}

#pragma mark - 按钮点击方法
// 专业
- (void) majorBtnAction{
    NSLog(@"专业");
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
