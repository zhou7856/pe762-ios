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
    NSMutableArray *listDataArray;
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
    [self initData];
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
    return listDataArray.count;
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
    
    NSDictionary *dictionary = listDataArray[indexPath.row];
    
    NSDictionary *infoDic = dictionary;
    cell.headImageView.image = nil;
    NSString *headImageUrl = [NSString stringWithFormat:@"%@", infoDic[@"audio_thumb_path"]];
    [cell.headImageView setImageWithURL:[NSURL URLWithString:headImageUrl]];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", infoDic[@"audio_title"]];
    cell.contentLabel.text = [NSString stringWithFormat:@"%@", infoDic[@"audio_introductions"]];
    
   
    [cell.collectBtn removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    if (_typeNumber == 0) {
        [cell.collectBtn setTitle:@"取消收藏" forState:0];
        cell.collectBtn.tag = kTagStart + 10000 + indexPath.row;
        
        [cell.collectBtn addTarget:self action:@selector(deleteFavoriteAudio:) forControlEvents:UIControlEventTouchUpInside];
    } else if (_typeNumber == 1) {
        [cell.collectBtn setTitle:@"删除播放记录" forState:0];
        cell.collectBtn.tag = kTagStart + 12000 + indexPath.row;
        [cell.collectBtn addTarget:self action:@selector(deletePlayRecording:) forControlEvents:UIControlEventTouchUpInside];
    } else if (_typeNumber == 2) {
        [cell.collectBtn setTitle:@"删除下载记录" forState:0];
        cell.collectBtn.tag = kTagStart + 11000 + indexPath.row;
        [cell.collectBtn addTarget:self action:@selector(deleteLocalAudio:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [cell.collectBtn setTitle:@"" forState:0];
        cell.collectBtn.tag = 0;
        [cell.collectBtn addTarget:self action:@selector(deleteFavoriteAudio:) forControlEvents:UIControlEventTouchUpInside];
    }

    
    cell.headImageView.backgroundColor = [UIColor greenColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AudioPlayViewController *apVC=[[AudioPlayViewController alloc] init];
    apVC.idStr=[listDataArray objectAtIndex:indexPath.row][@"audio_id"];
    apVC.titleStr=[listDataArray objectAtIndex:indexPath.row][@"audio_title"];
    [self.navigationController pushViewController:apVC animated:YES];
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
    _typeNumber = type;
    [self initData];
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

- (void)initData {
    if (_typeNumber == 0) {
        //我的收藏
        [self getFavoriteListAPI];
    } else if (_typeNumber == 1) {
        //我的播放记录
        [self getPlayRecordingAPI];
    } else if (_typeNumber == 2){
        //我的下载
        [self getDownloadRecordingAPI];
    }
}

#pragma mark - 获取收藏记录
- (void)getFavoriteListAPI {
    NSString *url = [NSString stringWithFormat:@"%@",kGetFavoriteListURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
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
                listDataArray = dataDic[@"info"];
                [listTableView reloadData];
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

#pragma mark - 取消收藏
- (void)deleteFavoriteAudio:(UIButton *)sender {
    NSInteger tagNumber = sender.tag - kTagStart - 10000;
    NSDictionary *dictionary = listDataArray[tagNumber];
    
    NSString *audioID = [NSString stringWithFormat:@"%@",dictionary[@"audio_id"]];
    
    NSString *url = [NSString stringWithFormat:@"%@",kDeleteFavoriteURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    NSDictionary *parameter = @{
                                @"id":audioID
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
                //                    NSDictionary *dataDic = dict[@"data"];
                //处理数据
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                [self initData];
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

#pragma mark - 获得播放记录
- (void)getPlayRecordingAPI {
    NSString *url = [NSString stringWithFormat:@"%@",kGetPlayRecordingURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
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
                listDataArray = dataDic[@"info"];
                [listTableView reloadData];
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

#pragma mark - 删除播放记录
- (void)deletePlayRecording:(UIButton *) sender {
    NSInteger tagNumber = sender.tag - kTagStart - 12000;
    NSDictionary *dictionary = listDataArray[tagNumber];
    NSString *audioID = [NSString stringWithFormat:@"%@",dictionary[@"id"]];
    
    NSString *url = [NSString stringWithFormat:@"%@",kDeletePlayRecordingURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    url=[NSString stringWithFormat:@"%@&id=%@",url,audioID];
//    NSDictionary *parameter = @{
//                                @"id":audioID,
//                                };
   // [listDataArray removeObjectAtIndex:tagNumber];
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
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
                //                    NSDictionary *dataDic = dict[@"data"];
                //处理数据
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                [self initData];
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
            //如果 errorCode == "-1" ??
//            if([errorCode isEqualToString:@"-1"]){
//                //数据已被删除
//            }
        }
    }];
}

#pragma mark - 获得下载记录
- (void)getDownloadRecordingAPI {
    NSString *url = [NSString stringWithFormat:@"%@",kGetDownloadRecordingURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
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
                listDataArray = dataDic[@"info"];
                [listTableView reloadData];
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

#pragma mark - 删除下载记录
- (void)deleteLocalAudio:(UIButton *)sender {
    NSInteger tagNumber = sender.tag - kTagStart - 11000;
    NSDictionary *dictionary = listDataArray[tagNumber];
    
    NSString *audioID = [NSString stringWithFormat:@"%@",dictionary[@"id"]];
    NSString *fileName = [NSString stringWithFormat:@"%@",dictionary[@"audio_name"]];
    NSString *url = [NSString stringWithFormat:@"%@",kDeleteDownloadRecordingURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    NSDictionary *parameter = @{
                                @"id":audioID
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
                //                    NSDictionary *dataDic = dict[@"data"];
                //处理数据
//                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                
                //删除本地文件
                [self deleteLocalFile:fileName];
                [self initData];
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

#pragma mark - 删除本地文件
- (void)deleteLocalFile:(NSString *)fileName {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    //获取到Document 目录
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsPath, fileName];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:filePath error:nil];
        if (blDele) {
            [self showHUDTextOnly:@"删除成功"];
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
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
