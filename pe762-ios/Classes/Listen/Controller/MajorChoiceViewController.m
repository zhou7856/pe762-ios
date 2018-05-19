//
//  MajorChoiceViewController.m
//  pe762-ios
//
//  Created by Future on 2018/5/15.
//  Copyright © 2018年 zmit. All rights reserved.
//  专业选择页面

#import "MajorChoiceViewController.h"
#import "MajorTableViewCell.h"
#import "MajorSearchListViewController.h"

@interface MajorChoiceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *majorBtn;//专业
    UILabel *typeLabel;//页面标题
    UIButton *noticeBtn;//消息通知
    
    // 专业列表
    UITableView *majorTableView;
    // 数据
    NSMutableArray *dataArray;
}
@end

@implementation MajorChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dataArray = [[NSMutableArray alloc] init];
    
    [self getProfessionListAPI];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initUI
- (void) initUI{
#pragma mark - 头部
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = kWhiteColor;
    
    majorBtn = [[UIButton alloc] init];
    typeLabel = [[UILabel alloc] init];
    [self createNavigationFeatureAndTitle:@"专业" withLeftBtn:majorBtn andTypeTitle:typeLabel];
    typeLabel.text = @"专业";
    
    //[self createNavigationTitle:@"专业"];
    
    [self createEndBackView];
    
#pragma mark - 列表
    majorTableView = [[UITableView alloc] init];
    majorTableView.backgroundColor = kWhiteColor;
    majorTableView.delegate = self;
    majorTableView.dataSource = self;
    majorTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    majorTableView.estimatedRowHeight = 0;
    majorTableView.estimatedSectionHeaderHeight = 0;
    majorTableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:majorTableView];
    [majorTableView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    NSDictionary *dataDic = dataArray[indexPath.row];
    NSString *clickType = [NSString stringWithFormat:@"%@", dataDic[@"clickType"]];
    
    
    if ([clickType isEqualToString:@"YES"]) {
        
        NSDictionary *course = dataDic[@"course"];
        
        NSMutableDictionary *heightDic = [self cellHeightWithData:course];
        
        return [heightDic[@"countHeight"] floatValue];
        
    } else {
        return 40 * kScreenHeightProportion;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"MajorTableViewCell";
    MajorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MajorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    // 取消点击cell的效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 获取数据
    NSDictionary *dict = dataArray[indexPath.row];
    NSDictionary *course = dict[@"course"];
    
    // 计算高度
    NSMutableDictionary *heightDic = [self cellHeightWithData:course];
    
    // 类名
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", course[@"course_name"]];
    
    // 点击效果
    NSString *clickType = [NSString stringWithFormat:@"%@", dict[@"clickType"]];
    
    if ([clickType isEqualToString:@"YES"]) {
        
        cell.typeView.hidden = NO;
        cell.moreImageView.hidden = YES;
        
        [cell.typeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [self initLogTitleLabel:cell.typeView andHistory:course[@"course_classify"] andIndexPath:indexPath.row];
        
        NSInteger typeHeight = [heightDic[@"lableHeight"] integerValue];
        
        [cell.typeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(typeHeight);
        }];
        
        
    } else {
        
        cell.typeView.hidden = YES;
        cell.moreImageView.hidden = NO;
        
        [cell.typeView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [cell.typeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"你点击了第%ld行", indexPath.row);
    
    // 获取数据
    NSDictionary *dict = dataArray[indexPath.row];
    NSDictionary *course = dict[@"course"];
    
    // 如果标签数组大于零，才可以点击
    if ([course[@"course_classify"] isKindOfClass:[NSArray class]] && [course[@"course_classify"] count] > 0) {
        NSString *type = [dict objectForKey:@"clickType"];
        if ([type isEqualToString:@"NO"]) {
            [dataArray[indexPath.row] setObject:@"YES" forKey:@"clickType"];
        } else {
            [dataArray[indexPath.row] setObject:@"NO" forKey:@"clickType"];
        }
        
        // 刷新
        NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]; //刷新第0段第2行
        [tableView reloadRowsAtIndexPaths:@[indexPathA] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        [self showHUDTextOnly:@"该专业没有标签"];
    }
    
}

// 历史标签
- (void) initLogTitleLabel:(UIView *)tempView andHistory:(NSMutableArray *)historyArray andIndexPath:(NSInteger)indexPath{
    //[tempView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    // 历史记录标签view
    NSInteger lineNumber = 0;
    int width = (int)(kScreenWidth - 20 * kScreenWidthProportion);
    int height = (int)(24 * kScreenHeightProportion);
    for (int i = 0; i < historyArray.count; i++) {
        NSDictionary *tempDict = historyArray[i];
        NSString *rendomStr = [[NSString alloc] init];
        UILabel *titleLabel = [[UILabel alloc] init];
        
        rendomStr = [NSString stringWithFormat:@"%@", tempDict[@"cour_classify_name"]];
        titleLabel.tag = kTagStart + [tempDict[@"id"] integerValue];
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = RGB(241.0, 241.0, 241.0);
        [titleLabel setBackgroundColor:RGB(241.0, 241.0, 241.0)];
        titleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        [titleLabel setUserInteractionEnabled:YES];
        int labelWidth = (int)[titleLabel getTitleTextWidth:rendomStr font:FONT(12 * kFontProportion)];
        [titleLabel setCornerRadius:2.0f * kScreenHeightProportion];
        labelWidth += (int)(10 * kScreenWidthProportion);
        if (labelWidth > width) {
            lineNumber ++;
            width = (int)(tempView.width);
        }
        titleLabel.text = rendomStr;
        titleLabel.font = FONT(12 * kFontProportion);
        titleLabel.frame = CGRectMake(kScreenWidth - 20 * kScreenWidthProportion - width, (int)(lineNumber * height), labelWidth, (int)(18 * kScreenHeightProportion));
        [tempView addSubview:titleLabel];
        width = (int)(width - labelWidth - 10 * kScreenWidthProportion);
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            
            NSLog(@"%@ %ld", titleLabel.text, titleLabel.tag);
            
            // 获取数据
            NSDictionary *dict = dataArray[indexPath];
            NSDictionary *course = dict[@"course"];
            
            NSString *courseClassifyIdStr = [NSString stringWithFormat:@"%ld", (titleLabel.tag - kTagStart)];
            MajorSearchListViewController *pushVC = [[MajorSearchListViewController alloc] init];
            pushVC.viewTitleStr = titleLabel.text;
            pushVC.courseClassifyIdStr = courseClassifyIdStr;
            pushVC.courseIdStr = [self stringForNull:course[@"id"]];
            pushVC.typeStr = @"1";
            [self.navigationController pushViewController:pushVC animated:YES];
            
        }];
        [titleLabel addGestureRecognizer:tap];
    }
}

- (NSMutableDictionary *)cellHeightWithData :(NSDictionary *)dic {
    NSMutableDictionary *heightDic = [[NSMutableDictionary alloc] init];
    
    // 标签数组
    NSArray *course_classify = [[NSArray alloc] initWithArray:dic[@"course_classify"]];
    
    UIView *tempView = [[UIView alloc] init];
    tempView.width = kScreenWidth - 20 * kScreenWidthProportion;
    [tempView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 标签view
    NSInteger lineNumber = 0;
    int width = (int)(tempView.width);
    int height = (int)(24 * kScreenHeightProportion);
    for (int i = 0; i < course_classify.count; i++) {
        NSDictionary *tempDict = course_classify[i];
        NSString *rendomStr = [[NSString alloc] init];
        UILabel *titleLabel = [[UILabel alloc] init];
        rendomStr = [NSString stringWithFormat:@"%@", tempDict[@"cour_classify_name"]];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = RGB(241.0, 241.0, 241.0);
        [titleLabel setBackgroundColor:RGB(241.0, 241.0, 241.0)];
        titleLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        [titleLabel setUserInteractionEnabled:YES];
        int labelWidth = (int)[titleLabel getTitleTextWidth:rendomStr font:FONT(12 * kFontProportion)];
        [titleLabel setCornerRadius:2.0f * kScreenHeightProportion];
        labelWidth += (int)(10 * kScreenWidthProportion);
        if (labelWidth > width) {
            lineNumber ++;
            width = (int)(tempView.width);
        }
        titleLabel.text = rendomStr;
        titleLabel.font = FONT(12 * kFontProportion);
        titleLabel.frame = CGRectMake(tempView.width - width, (int)(lineNumber * height), labelWidth, (int)(18 * kScreenHeightProportion));
        [tempView addSubview:titleLabel];
        width = (int)(width - labelWidth - 10 * kScreenWidthProportion);
    }
    
    // 标签view的高度
    if (course_classify.count > 0) {
        lineNumber += 1;
    }
    NSInteger lableHeight = lineNumber * height;
    
    [heightDic setObject:[NSString stringWithFormat:@"%ld", lableHeight] forKey:@"lableHeight"];
    
    //总高度 = 标签view的高度 + 固定高度
    CGFloat countHeight = lableHeight + 40 * kScreenHeightProportion;
    
    [heightDic setObject:[NSString stringWithFormat:@"%f", countHeight] forKey:@"countHeight"];
    
    return heightDic;
}

#pragma mark - 获取专业
- (void)getProfessionListAPI {
    NSString *url = [NSString stringWithFormat:@"%@",kGetProfessionListURL];
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
                dataArray = [[NSMutableArray alloc] init];
                NSMutableArray *infoArray = [[NSMutableArray alloc] init];
                if ([dataDic[@"info"] isKindOfClass:[NSArray class]] && [dataDic[@"info"] count] > 0) {
                    [infoArray addObjectsFromArray:dataDic[@"info"]];
                    
                    for (int i = 0; i < infoArray.count; i++) {
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:infoArray[i]];
                        [dict setObject:@"NO" forKey:@"clickType"];
                        [dataArray addObject:dict];
                    }
                }
                
                
                [majorTableView reloadData];
                
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
