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
    NSMutableArray *selectCellArray; //选中的cell
    UIButton *delSelectInfo;  //删除选定信息
    UIButton *delAndFinBtn; //删除和完成按钮
    NSInteger page;
    NSInteger rows;
    BOOL stopTouch; //防止button连续触发
}
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    stopTouch = NO;
    // 初始化分页数据
    rows = 10;
    page = 1;
    selectCellArray = [[NSMutableArray alloc] init];
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
    
    //majorBtn = [[UIButton alloc] init];
    //typeLabel = [[UILabel alloc] init];
    //[self createNavigationFeatureAndTitle:@"消息通知" withLeftBtn:majorBtn andTypeTitle:typeLabel];
    
    [self createNavigationTitle:@"消息通知"];
    
    self.view.backgroundColor = kBackgroundWhiteColor;
    //typeLabel.text = @"专业";
    
    [self createEndBackView];
#pragma mark - 删除
    
    delAndFinBtn = [[UIButton alloc] initWithFrame: CGRectMake(270 * kScreenWidthProportion, kStatusHeight, 50 * kScreenWidthProportion, kNavigationBarHeight)];
    //delAndFinBtn.backgroundColor = kProgressColor;
//    label.textColor = kBlackLabelColor;

    [delAndFinBtn setTitle:@"编辑" forState:UIControlStateNormal];
    delAndFinBtn.font = FONT(16);
    [delAndFinBtn setTitleColor:kBlackLabelColor forState:UIControlStateNormal];
    [[delAndFinBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if([delAndFinBtn.titleLabel.text isEqualToString: @"编辑"]){
            [delAndFinBtn setTitle:@"完成" forState:UIControlStateNormal];
            delSelectInfo.height = kNavigationBarHeight;
            [delSelectInfo setTitle:@"删除" forState:UIControlStateNormal];
            messageTabelView.minY = delSelectInfo.maxY;
            
            
        }else if([delAndFinBtn.titleLabel.text isEqualToString: @"完成"]){
            [delAndFinBtn setTitle:@"编辑" forState:UIControlStateNormal];
            delSelectInfo.height = 0;
            [delSelectInfo setTitle:@"" forState:UIControlStateNormal];
            messageTabelView.minY = delSelectInfo.maxY;
        }
        [messageTabelView reloadData];
    }];
    [self.view addSubview:delAndFinBtn];
//删除选中cell 对象
    delSelectInfo = [[UIButton alloc] initWithFrame:CGRectMake( 270 * kScreenWidthProportion, kHeaderHeight, 50 * kScreenWidthProportion,0)];
    //[delSelectInfo setTitle:@"删除所有信息" forState:UIControlStateNormal];
    delSelectInfo.font = FONT(16);
    [delSelectInfo setTitleColor:kBlackLabelColor forState:UIControlStateNormal];
    [[delSelectInfo rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(id x) {
        NSLog(@"删除成功");
        //首先获取所有被选择的cell对象
//        selectCellArray
        NSString *idStr ; //idStr=1，2，3，4，5
        if(selectCellArray.count == 0){
            [self showHUDTextOnly:@"请先选择消息"];
            return ;
        }
        if(selectCellArray.count > 0)
        idStr = [NSString stringWithFormat:@"%@",[selectCellArray objectAtIndex:0][@"id"]];
        for(int selecti = 1; selecti < selectCellArray.count; selecti++){
//            NSDictionary *dataDic = dataArray[]
            NSDictionary *dict = [selectCellArray objectAtIndex:selecti];
//            for(int datai = 0; datai < dataArray.count; datai++){
//                NSDictionary *dataDic = [dataArray objectAtIndex:datai];
//                if([dataDic[@"id"] isEqualToString: dict[@"id"]]){
//                    [dataArray removeObjectAtIndex:datai];
//                    break;
//                }
//            }
            idStr = [NSString stringWithFormat:@"%@,%@",idStr,[selectCellArray objectAtIndex:selecti][@"id"]];
           // [self delNoticeInfoURL:dict[@"id"]];
            
        }
        [self delNoticeInfoURL:idStr];
        //更新api
        [self initNoticeListAPI];
        //所有都删除后初始化数组
        selectCellArray = [[NSMutableArray alloc] init];
        [messageTabelView reloadData];
    }];
    [self.view addSubview:delSelectInfo];
    
#pragma mark - 内容
    messageTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, delSelectInfo.maxY, kScreenWidth, kScreenHeight - kHeaderHeight - kEndBackViewHeight) style:UITableViewStylePlain];
    messageTabelView.backgroundColor = kBackgroundWhiteColor;
    messageTabelView.delegate = self;
    messageTabelView.dataSource = self;
    messageTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    messageTabelView.estimatedRowHeight = 0;
    messageTabelView.estimatedSectionHeaderHeight = 0;
    messageTabelView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:messageTabelView];
}
#pragma mark -通过id删除消息对象
- (void) delNoticeInfoURL:(NSString *)idStr {
    NSString * url = [NSString stringWithFormat:@"%@",kDelNoticeInfoURL];
    url = [self stitchingTokenAndPlatformForURL:url];
    url = [NSString stringWithFormat:@"%@&ids=%@",url,idStr];
    
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
        
        //判断有无数据
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            
            if ([errorCode isEqualToString:@"0"]) {
                NSDictionary *msg = dict[@"message"];
                [self showHUDTextOnly:@"删除成功"];
                NSLog(@"msg -- 》%@",msg);
                
            }
        }
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
    
    NSString *idStr = [NSString stringWithFormat:@"%@",dict[@"id"]];
    
    //每次重读需要刷新cell,所以更新cell数组,判断cell 是不是在selectCellArray
    {
        int i = 0;
        for (i = 0; i < selectCellArray.count; i++){
            NSDictionary *selectDic = [selectCellArray objectAtIndex:i];
            if([selectDic[@"id"] isEqualToString:idStr]){
                cell.selectZone.tag = 1;
                [cell.selectZone setImage:[UIImage imageNamed:@"icon_yes"] forState:UIControlStateNormal];
                
            }
        }
        if( i == selectCellArray.count){ //没有找到这种情况
            cell.selectZone.tag = 0;
            [cell.selectZone setImage:[UIImage imageNamed:@"icon_no"] forState:UIControlStateNormal];
        }
    }
    

    //更改selectCell 的约束
    if([delAndFinBtn.titleLabel.text isEqualToString: @"编辑"]){
        cell.pageContent.minX = 0;
        
    }else if([delAndFinBtn.titleLabel.text isEqualToString: @"完成"]){
        cell.pageContent.minX = 30 * kScreenWidthProportion;
    }
    [[cell.selectZone rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(id x) {
        if(!stopTouch){
            [self selectObjZone:cell];
            stopTouch = YES;
            //防止按钮重复触发
            [self performSelector:@selector(upDataStopTouchState) withObject:self afterDelay:0.1];
        }

    }];
//    [cell.selectZone addTarget:self action:@selector(selectZoneAction:) forControlEvents:UIControlEventTouchDown];
    
    
    cell.tag = [idStr integerValue];
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
-(void)upDataStopTouchState{
    stopTouch = NO;
}
#pragma mark -选中区域事件
-(void)selectObjZone:(MessageTableViewCell *)cell{
    if(cell.selectZone.tag == 0){  //未选中
        cell.selectZone.tag = 1;
        [cell.selectZone setImage:[UIImage imageNamed:@"icon_yes"] forState:UIControlStateNormal];
     //   cell.tag = 1;
        //选中就加对象
        NSString *idstr = [NSString stringWithFormat:@"%d",cell.tag]; // cell.tag放上每个cell的对象的id
        NSString *type = @"1";  //表示已经选中
        NSDictionary *dict = @{
                               @"id":idstr,
                              // @"type":type
                               };
        [selectCellArray addObject:dict];
        NSLog(@"selectCellArray --> %@",selectCellArray);
        
    }else if(cell.selectZone.tag == 1){
        cell.selectZone.tag = 0;
        [cell.selectZone setImage:[UIImage imageNamed:@"icon_no"] forState:UIControlStateNormal];
     //   cell.tag = 0;
        //去掉就去对象
        for (int i = 0; i < selectCellArray.count ; i++){
            NSDictionary *dict = [selectCellArray objectAtIndex:i]; //一般找到就可以跳出循环
            if([dict[@"id"] integerValue] == cell.tag){
                [selectCellArray removeObjectAtIndex:i];
                break;
            }
        }
        NSLog(@"selectCellArray --> %@",selectCellArray);

        
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"你点击了第%ld行", indexPath.row);
    if([delAndFinBtn.titleLabel.text isEqualToString: @"完成"]){
        //获取选中的cell对象
        MessageTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self selectObjZone:cell];
            }else {
        // 取数据
        NSDictionary *dict = dataArray[indexPath.row];
        NSString *idStr = [NSString stringWithFormat:@"%@", dict[@"id"]];
        
        // 跳转到详情页面
        ProblemDetailViewController *pushVC = [[ProblemDetailViewController alloc] init];
        pushVC.idStr = idStr;
        pushVC.type = @"1";
        [self.navigationController pushViewController:pushVC animated:YES];

    }
}

#pragma mark - 按钮点击方法

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
                
            }else {
                //[self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
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
                    //[self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
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
                    //[self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
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
