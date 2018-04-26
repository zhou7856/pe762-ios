//
//  MyRecordingViewController.m
//  pe762-ios
//
//  Created by wsy on 2018/4/23.
//  Copyright © 2018年 zmit. All rights reserved.
//  我的收藏夹页面 （播放记录、下载页面）

#import "MyRecordingViewController.h"
#import "CollectionTableViewCell.h" //我的收藏夹cell
#import "AudioPlayViewController.h" //音频播放
#import "FSAudioStream.h" 

@interface MyRecordingViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UILabel *viewTitleLabel;
    //1 我的收藏 2 播放记录 3 我的下载
    NSInteger type;
    
    UITableView *listTableView;
    NSArray *listDataArray;
}
@end

@implementation MyRecordingViewController

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

- (void)initNav {
    self.view.backgroundColor = RGB(243, 243, 243);
//    [self createNavigationTitle:@"用户中心"];
    
    NSArray *titleArray = @[@"我的收藏夹",@"播放记录",@"我的下载"];
    if (kScreenHeight == 812) {
        NSLog(@"this is iPhone X");
        self.navigationController.navigationBarHidden = YES;
        UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        statusView.backgroundColor = kWhiteColor;
        [self.view addSubview:statusView];
        
        UIView *view = [UIView viewWithFrame:CGRectMake(0, 44, kScreenWidth, 44) backgroundColor:kWhiteColor];
        [self.view addSubview:view];
        
        viewTitleLabel = [UILabel labelWithFrame:CGRectMake(0, -12, 200, 56) text:titleArray[_typeNumber] textAlignment:NSTextAlignmentCenter font:FONT(16)];
        viewTitleLabel.centerX = kScreenWidth/2.0;
        viewTitleLabel.textColor = kBlackLabelColor;
        //        label.backgroundColor = [UIColor redColor];
        [view addSubview:viewTitleLabel];
        
        UIView *lineView = [UIView viewWithFrame:CGRectMake(0, 43, kScreenWidth, 1) backgroundColor:RGB(223, 223, 223)];
        [view addSubview:lineView];
    } else {
        self.navigationController.navigationBarHidden = YES;
        
        UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        statusView.backgroundColor = kWhiteColor;
        [self.view addSubview:statusView];
        
        UIView *view = [UIView viewWithFrame:CGRectMake(0, 20, kScreenWidth, 44) backgroundColor:[UIColor whiteColor]];
        [self.view addSubview:view];
        
        viewTitleLabel = [UILabel labelWithFrame:CGRectMake(0, 0, 200 * kScreenWidthProportion, 44) text:titleArray[_typeNumber] textAlignment:NSTextAlignmentCenter font:FONT(16)];
        viewTitleLabel.centerX = kScreenWidth/2.0;
        viewTitleLabel.textColor = kBlackLabelColor;
        [view addSubview:viewTitleLabel];
        
        UIView *lineView = [UIView viewWithFrame:CGRectMake(0, 43, kScreenWidth, 1) backgroundColor:RGB(223, 223, 223)];
        [view addSubview:lineView];
    }
    
    [self createEndBackView];
    
}

- (void)initUI {
    NSArray *titleArray = @[@"我的收藏",@"播放记录",@"我的下载"];
    
    for (int i = 0; i < 3; i++) {
        UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(40 * kScreenWidthProportion + 80 * kScreenWidthProportion * i, 30 * kScreenWidthProportion + kHeaderHeight, 80 * kScreenWidthProportion, 30 * kScreenWidthProportion)];
        titleButton.tag = kTagStart + 10000 + i;
        [titleButton setTitle:titleArray[i] forState:0];
        [titleButton setTitleColor:kGrayLabelColor forState:0];
        titleButton.titleLabel.font = FONT(13 * kFontProportion);
        [self.view addSubview:titleButton];
        
        if (i != 2) {
            UIView *lineView = [UIView viewWithFrame:CGRectMake(titleButton.maxX - 2, titleButton.minY + 9 * kScreenWidthProportion, 2, 12 * kScreenWidthProportion) backgroundColor:RGB(215, 215, 215)];
            [self.view addSubview:lineView];
        }
        
        [[titleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            type = i;
            [self typeChangeAPI:i];
        }];
    }
    
    [self typeChangeAPI:_typeNumber];
    
    listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 75 * kScreenWidthProportion + kHeaderHeight, kScreenWidth, kScreenHeight - 75 * kScreenWidthProportion - kHeaderHeight - kEndBackViewHeight)];
    listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listTableView.delegate = self;
    listTableView.backgroundColor = self.view.backgroundColor;
    listTableView.dataSource = self;
//    listTableView.scrollEnabled =NO; //设置tableview 不能滚动
    [self.view addSubview:listTableView];
    
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
//    return listDataArray.count;
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85 * kScreenWidthProportion;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"CollectionTableViewCell";
    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[CollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.backgroundColor = RGB(243, 243, 243);
    
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"《大学教育熊视》";
        cell.contentLabel.text = @"面对大学教育熊丙奇博士给予不同的分析";
    }
    
    if (indexPath.row == 1) {
        cell.titleLabel.text = @"《步入大学》";
        cell.contentLabel.text = @"彭子飞老师带您进入大学生活";
    }
    
    if (indexPath.row == 2) {
        cell.titleLabel.text = @"《走出一个时代的教育困惑》";
        cell.contentLabel.text = @"面对时代教育我们自有对策";
    }
    
    cell.headImageView.backgroundColor = [UIColor greenColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController pushViewController:[AudioPlayViewController new] animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

#pragma makr - 设置点击
- (void)setingBtnAction {
    [self.navigationController pushViewController:[SettingViewController new] animated:YES];
}

#pragma makr - 消息点击
- (void)messageBtnAction {
    
}

#pragma mark - 按钮点击
- (void)typeChangeAPI:(NSInteger) type {
    NSArray *titleArray = @[@"我的收藏夹",@"播放记录",@"我的下载"];
    viewTitleLabel.text = titleArray[type];
    for (int i = 0; i < 3; i++)  {
        NSInteger tagNumber = i + kTagStart + 10000;
        UIButton *titleButton = [self.view viewWithTag:tagNumber];
        if (i == type) {
            [titleButton setTitleColor:RGB(130, 34, 194) forState:0];
        } else {
            [titleButton setTitleColor:kGrayLabelColor forState:0];
        }
    }
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
