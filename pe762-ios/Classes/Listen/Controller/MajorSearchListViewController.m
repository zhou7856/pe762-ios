//
//  MajorSearchListViewController.m
//  pe762-ios
//
//  Created by Future on 2018/5/15.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import "MajorSearchListViewController.h"
#import "NewestTableViewCell.h"//上新-列表

@interface MajorSearchListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *majorBtn;//专业
    UILabel *typeLabel;//页面标题
    UIButton *noticeBtn;//消息通知
    
    // 音频列表
    UITableView *freshTableView;
    // 音频列表数据
    NSMutableArray *dataArray;
}
@end

@implementation MajorSearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void)initUI {
#pragma mark - 头部、底部
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = kWhiteColor;
    
    majorBtn = [[UIButton alloc] init];
    typeLabel = [[UILabel alloc] init];
    [self createNavigationFeatureAndTitle:self.titleStr withLeftBtn:majorBtn andTypeTitle:typeLabel];

    typeLabel.text = @"专业";
    
    //[self createNavigationTitle:self.titleStr];
    
    // 底部
    [self createEndBackView];
    
#pragma mark - 列表
    freshTableView = [[UITableView alloc] init];
    freshTableView.backgroundColor = kWhiteColor;
    freshTableView.delegate = self;
    freshTableView.dataSource = self;
    freshTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    freshTableView.estimatedRowHeight = 0;
    freshTableView.estimatedSectionHeaderHeight = 0;
    freshTableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:freshTableView];
    [freshTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(kHeaderHeight);
        make.bottom.mas_equalTo(self.view).offset(-kEndBackViewHeight);
    }];
    
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
    
    return 120 * kScreenHeightProportion;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"NewestTableViewCell";
    NewestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NewestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    // 取消点击cell的效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 获取数据
    NSDictionary *dict = dataArray[indexPath.row];
    
    NSString *avatarPathStr = [NSString stringWithFormat:@"%@%@", kHostURL ,dict[@"thumb"]];
    cell.iconImageView.image = nil;
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:avatarPathStr]];
    
    cell.classLabel.text = [NSString stringWithFormat:@"%@", dict[@"classify_name"]];
    cell.nameLabel.text = [NSString stringWithFormat:@"《%@》", dict[@"title"]];
    cell.detailLabel.text = [NSString stringWithFormat:@"%@", dict[@"introductions"]];
    cell.hotLabel.text = [NSString stringWithFormat:@"%@", dict[@"browse_num"]];
    
    NSString *creatTimeStr = [NSString stringWithFormat:@"%@", dict[@"created_at"]];
    NSString *hmStr = [creatTimeStr substringWithRange:NSMakeRange(0, 10)];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@ 上新", hmStr];
    
    [cell.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(28 * kScreenHeightProportion);
        cell.detailLabel.numberOfLines = 2;
        cell.detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"你点击了第%ld行", indexPath.row);
    
    // 跳转到资讯详情页面
    NSDictionary *dict = dataArray[indexPath.row];
    NSString *idStr = [NSString stringWithFormat:@"%@", dict[@"id"]];
    NSString *title = [NSString stringWithFormat:@"%@", dict[@"title"]];
    // 跳转到资讯详情页面
    [self showTabBarView:NO];
    AudioPlayViewController *pushVC = [[AudioPlayViewController alloc] init];
    pushVC.idStr = idStr;
    pushVC.titleStr = title;
    [self.navigationController pushViewController:pushVC animated:YES];
    
}

- (void)initData {
    NSString *url = [NSString stringWithFormat:@"%@",kSearchAudioURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    
    self.typeStr = (self.typeStr.length <= 0) ? @"" : self.typeStr;
    self.titleStr = (self.titleStr.length <= 0) ? @"" : self.titleStr;
    self.courseIdStr = (self.courseIdStr.length <= 0) ? @"" : self.courseIdStr;
    self.idStr = (self.idStr.length <= 0) ? @"" : self.idStr;
    
    
    NSDictionary *parameter = @{
                                @"type":self.typeStr,
                                @"title":self.titleStr,
                                @"course_classify_id":self.idStr,
                                @"course_id":self.courseIdStr
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
                if ([dataDic[@"info"] isKindOfClass:[NSArray class]] || [dataDic[@"info"] count] > 0) {
                    [dataArray addObjectsFromArray:dataDic[@"info"]];
                }
                
                [freshTableView reloadData];
                
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
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
