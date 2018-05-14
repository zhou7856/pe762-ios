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
    UITableView *problemTabelView;//问题列表
    NSMutableArray *dataArray;
    
    // 分页
    NSInteger page;
    NSInteger rows;
}
@end

@implementation CommonProblemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 创建页面
    [self initUI];
    [self updataAction];
    
    page = 1;
    rows = 10;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 加在数据
    [self initSysActListAPI];
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
    
    [self createNavigationTitle:@"常见问题"];
    
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
    
    NSDictionary *dict = dataArray[indexPath.row];
    
    cell.contentLabel.text = [NSString stringWithFormat:@"%@", dict[@"title"]];
    
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

#pragma mark - 通知消息列表API
- (void) initSysActListAPI{
    page = 1;
    
    NSString *url = [NSString stringWithFormat:@"%@", kListURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    url = [NSString stringWithFormat:@"%@&page=%ld&rows=%ld", url, page, rows];
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        //判断有无数据
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            
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
                
                [problemTabelView reloadData];
                
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

- (void) updataAction{
    // 下拉刷新
    problemTabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //重置page
        page = 1;
        
        //拼接url
        NSString *url = [NSString stringWithFormat:@"%@", kListURL];
        url = [self stitchingTokenAndPlatformForURL:url];
        url = [NSString stringWithFormat:@"%@&page=%ld&rows=%ld", url, page, rows];
        
        // 添加菊花
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
        // 开始请求
        [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
            // 隐藏菊花
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            [problemTabelView.mj_header endRefreshing];
            
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
                    
                    [problemTabelView reloadData];
                    
                } else {
                    [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                    return;
                }
            }
        }];
        
    }];
    
    //上啦加载
    problemTabelView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (page == 1) {
            [problemTabelView.mj_footer endRefreshing];
            return;
        }
        
        //拼接url
        NSString *url = [NSString stringWithFormat:@"%@", kListURL];
        url = [self stitchingTokenAndPlatformForURL:url];
        url = [NSString stringWithFormat:@"%@&page=%ld&rows=%ld", url, page, rows];
        
        // 添加菊花
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
        // 开始请求
        [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
            // 隐藏菊花
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            [problemTabelView.mj_footer endRefreshing];
            
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
                    
                    [problemTabelView reloadData];
                    
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
