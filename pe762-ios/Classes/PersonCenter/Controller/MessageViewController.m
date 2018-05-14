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
    NSMutableArray *dataArray; //数据
    
    NSInteger page;
    NSInteger rows;
}
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化分页数据
    rows = 10;
    page = 1;
    
    // 创建页面
    [self initUI];
    // 刷新数据
    [self updataAction];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 加在数据
    [self showTabBarView:NO];
    [self initNoticeListAPI];
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
    [self createNavigationFeatureAndTitle:@"消息通知" withLeftBtn:majorBtn andTypeTitle:typeLabel];
    
    [majorBtn addTarget:self action:@selector(majorBtnAction) forControlEvents:UIControlEventTouchUpInside];
    typeLabel.text = @"专业";
    
    [self createEndBackView];
    
#pragma mark - 内容
    messageTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, kHeaderHeight, kScreenWidth, kScreenHeight - kHeaderHeight - kEndBackViewHeight) style:UITableViewStylePlain];
    messageTabelView.backgroundColor = kBackgroundWhiteColor;
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
    
    return 84 * kScreenWidthProportion;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"MessageTableViewCell";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    // 取消点击cell的效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 取数据
    NSDictionary *dict = dataArray[indexPath.row];

    // 赋值
    NSString *creatTimeStr = [NSString stringWithFormat:@"%@", dict[@"created_at"]];
    NSString *hmStr = [creatTimeStr substringWithRange:NSMakeRange(0, 10)];
    NSString *classifyNameStr = [NSString stringWithFormat:@"%@", dict[@"name"]];

    cell.headImageView.image = nil;
    NSString *thumbPathStr = [NSString stringWithFormat:@"%@", dict[@"avath_path"]];
    [cell.headImageView setImageWithURL:[NSURL URLWithString:thumbPathStr]];

    cell.sourceLabel.text = classifyNameStr;
    cell.dateLabel.text = hmStr;
    cell.mainTitleLabel.text = [NSString stringWithFormat:@"%@", dict[@"push_title"]];
    //cell.subtitleLabel.text = [NSString stringWithFormat:@"%@", dict[@"push_content"]];
    NSAttributedString *detailsAttrStr = [[NSAttributedString alloc] initWithData:[dict[@"push_content"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    cell.subtitleLabel.attributedText = detailsAttrStr;
    //[cell.subtitleLabel setLineSpacing:5.0f];
    cell.subtitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSString *isRead = [NSString stringWithFormat:@"%@", dict[@"is_read"]];
    if ([isRead isEqualToString:@"0"]) {
        cell.redlabel.hidden = NO;
    } else {
        cell.redlabel.hidden = YES;
    }
    
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
    pushVC.type = @"1";
    [self.navigationController pushViewController:pushVC animated:YES];
    
}

#pragma mark - 按钮点击方法
// 专业
- (void) majorBtnAction{
    NSLog(@"专业");
    [self showTabBarView:NO];
    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
}

#pragma mark - 通知消息列表API
- (void) initNoticeListAPI{
    page = 1;
    
    NSString *url = [NSString stringWithFormat:@"%@", kNoticeListURL];
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
                
                [messageTabelView reloadData];
                
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

- (void) updataAction{
    // 下拉刷新
    messageTabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        //重置page
        page = 1;
        
        //拼接url
        NSString *url = [NSString stringWithFormat:@"%@", kNoticeListURL];
        url = [self stitchingTokenAndPlatformForURL:url];
        url = [NSString stringWithFormat:@"%@&page=%ld&rows=%ld", url, page, rows];
        
        // 添加菊花
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
        // 开始请求
        [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
            // 隐藏菊花
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            [messageTabelView.mj_header endRefreshing];
            
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
                    
                    [messageTabelView reloadData];
                    
                } else {
                    [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                    return;
                }
            }
        }];
        
    }];
    
    //上啦加载
    messageTabelView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (page == 1) {
            [messageTabelView.mj_footer endRefreshing];
            return;
        }
        
        //拼接url
        NSString *url = [NSString stringWithFormat:@"%@", kNoticeListURL];
        url = [self stitchingTokenAndPlatformForURL:url];
        url = [NSString stringWithFormat:@"%@&page=%ld&rows=%ld", url, page, rows];
        
        // 添加菊花
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        
        // 开始请求
        [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
            // 隐藏菊花
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            [messageTabelView.mj_footer endRefreshing];
            
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
                    
                    [messageTabelView reloadData];
                    
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
