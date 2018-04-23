//
//  TabBarController.m
//  od681-yonghu-ios
//
//  Created by wsy on 2018/3/26.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController (){
    UIScrollView *myGuidePageScrollView;
}

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViewController];
    [self initTabBarView];
    //获取所有省市区
//    [self getAllAreaAPI];
    //获取服务数据
//    [self getServerDataAPI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController setHidesBottomBarWhenPushed:YES];
    [self.tabBar setHidden:YES];
    
    //    [self initGuidePage];
}

-(void)initViewController
{
    //    NSArray *classNameArray = @[@"NewHomeViewController",@"PositionManagementViewController",@"PracticeHomeViewController",@"MessageViewController",@"CompanyCenterViewController"];
    NSArray *classNameArray = @[@"ReadViewController",@"ListenViewController",@"PersonCenterViewController"];
    
    NSMutableArray *tabArray = [NSMutableArray arrayWithCapacity:classNameArray.count];
    
    //初始化导航控制器
    for (int i = 0; i < classNameArray.count; i++) {
        UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:[NSClassFromString(classNameArray[i]) new]];
        [tabArray addObject:navCtrl];
    }
    //将导航控制器给标签控制器
    self.viewControllers = tabArray;
}

-(void)initTabBarView
{
    if (kScreenHeight == 812) {
        NSLog(@"this is iPhone X");
        self.tabBarView =[[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 83, kScreenWidth, 83)];
        self.tabBarView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.tabBarView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        lineView.backgroundColor = RGB(231.0, 231.0, 231.0);
        [self.tabBarView addSubview:lineView];
        
        //    NSArray *imgageArray = @[@"icon_home",@"icon_work",@"icon_internship",@"icon_msg",@"icon_my"];
        //    NSArray *selectedImageArray = @[@"icon_home_color",@"icon_work_color",@"icon_internship_color",@"icon_msg_color1",@"icon_my_color"];
    
        NSArray *imgageArray = @[@"Group 83",@"Group 82",@"Group 50"];
        NSArray *selectedImageArray = @[@"Group 32",@"Group 51",@"Group 81"];
        for (int i = 0; i<imgageArray.count; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:imgageArray[i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:selectedImageArray[i]] forState:UIControlStateSelected];
            button.frame  = CGRectMake(kScreenWidth / 3 * i, 5, kScreenWidth / 3, 49);
            button.tag = kTagStart+i;
            [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.tabBarView addSubview:button];
    
            
            if (i == 0)
            {
                button.selected = YES;
            }
        }
    } else {
        self.tabBarView =[[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49)];
        self.tabBarView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.tabBarView];
        
        //    UIView *lineView = [UIView viewWithFrame:CGRectMake(0, 0, kScreenWidth, 1) backgroundColor:RGB(187, 187, 188)];
        //    [self.tabBarView addSubview:lineView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        lineView.backgroundColor = RGB(219.0, 219.0, 219.0);
        [self.tabBarView addSubview:lineView];
    
        NSArray *imgageArray = @[@"Group 83",@"Group 82",@"Group 50"];
        NSArray *selectedImageArray = @[@"Group 32",@"Group 51",@"Group 81"];
        for (int i = 0; i<imgageArray.count; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:imgageArray[i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:selectedImageArray[i]] forState:UIControlStateSelected];
            button.frame  = CGRectMake(kScreenWidth / 3 * i, 10, kScreenWidth / 3, 39);
            button.tag = kTagStart+i;
            [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.tabBarView addSubview:button];
            
            if (i == 0)
            {
                button.selected = YES;
            }
        }
    }
    
}

//自定义tabbar点击事件
-(void)btnAction:(UIButton *)sender
{
//    if (sender.tag - kTagStart == 2) {
//        
//        ToolkitViewController *pushVC = [[ToolkitViewController alloc] init];
//        pushVC.type = @"2";
//        [self.navigationController pushViewController:pushVC animated:YES];
//        
//        return;
//    } else if (sender.tag - kTagStart == 3) {
//        
//        [self showTabBar:NO];
//        [self.navigationController pushViewController:[DecorationCaseViewController new] animated:YES];
//        
//        return;
//    }
    
    //    self.selectedIndex = sender.tag - kTagStart;
    //    sender.selected  = YES;
    //
    //    for (UIButton *btn in sender.superview.subviews)
    //    {
    //        if ([btn isKindOfClass:[UIButton class]])
    //        {
    //            if (btn != sender) {
    //                btn.selected = NO;
    //            }
    //        }
    //    }
    
    self.selectedIndex = sender.tag - kTagStart;
    sender.selected = YES;
    
    for (UIButton *btn in sender.superview.subviews)
    {
        if ([btn isKindOfClass:[UIButton class]])
        {
            if (btn != sender) {
                btn.selected = NO;
            }
        }
    }
}

#pragma mark -- 初始化引导页
-(void)initGuidePage
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isFirstLaunch"])
    {
        //获取省市区数据
//        [self initAllAreaData];
        NSLog(@"第一次启动APP");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFirstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM-dd"];
        NSString *dateStr = [formatter stringFromDate:date];
        
#pragma mark - 上架处理
        if ([dateStr isEqualToString:@"10-12"] || [dateStr isEqualToString:@"10-13"] || [dateStr isEqualToString:@"10-14"] || [dateStr isEqualToString:@"10-15"] ||[dateStr isEqualToString:@"10-16"]) {
            //            myGuidePageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            //            myGuidePageScrollView.pagingEnabled = YES;
            //            myGuidePageScrollView.showsHorizontalScrollIndicator = NO;
            //            myGuidePageScrollView.contentSize = CGSizeMake(kScreenWidth * 1, kScreenHeight);
            //            myGuidePageScrollView.bounces = NO;
            //            [self.view addSubview:myGuidePageScrollView];
            //            for (int i = 0; i < 1; i++) {
            //
            //                int number = i;
            //                if (i == 1) {
            //                    number++;
            //                }
            //                UIImageView *myGuidePageImageView = [UIImageView imageViewWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight) imageName:[NSString stringWithFormat:@"guide_page%d",number + 1]];
            //                [myGuidePageScrollView addSubview:myGuidePageImageView];
            //            }
            //
            //            UIButton *startButton = [UIButton buttonWithFrame:CGRectMake((kScreenWidth - 132 * kScreenWidthProportion) / 2, kScreenHeight - 74 * kScreenHeightProportion, 132 * kScreenWidthProportion, 36 * kScreenHeightProportion) type:UIButtonTypeCustom title:@"立即体验" titleColor:RGB(243,137,0) imageName:nil action:@selector(startButtonAction) target:self];
            //            [startButton setCornerRadius:(36 * kScreenHeightProportion / 2.0)];
            //            startButton.titleLabel.font = FONT(14);
            //            startButton.backgroundColor = RGB(255,217,1);
            //            [myGuidePageScrollView addSubview:startButton];
            return;
        } else {
            myGuidePageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            myGuidePageScrollView.pagingEnabled = YES;
            myGuidePageScrollView.showsHorizontalScrollIndicator = NO;
            myGuidePageScrollView.contentSize = CGSizeMake(kScreenWidth * 3, kScreenHeight);
            myGuidePageScrollView.bounces = NO;
            [self.view addSubview:myGuidePageScrollView];
            for (int i = 0; i < 3; i++) {
                UIImageView *myGuidePageImageView = [UIImageView imageViewWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight) imageName:[NSString stringWithFormat:@"page_guide_%d",i + 1]];
                [myGuidePageScrollView addSubview:myGuidePageImageView];
            }
            
            UIButton *startButton = [UIButton buttonWithFrame:CGRectMake(kScreenWidth * 2 + (kScreenWidth - 132 * kScreenWidthProportion) / 2, kScreenHeight - 60 * kScreenHeightProportion, 132 * kScreenWidthProportion, 36 * kScreenHeightProportion) type:UIButtonTypeCustom title:@"立即体验" titleColor:RGB(243,137,0) imageName:nil action:@selector(startButtonAction) target:self];
            [startButton setCornerRadius:(36 * kScreenHeightProportion / 2.0)];
            startButton.titleLabel.font = FONT(14);
            startButton.backgroundColor = RGB(255,217,1);
            [myGuidePageScrollView addSubview:startButton];
        }
    }
}

- (void)startButtonAction
{
    myGuidePageScrollView.hidden = YES;
}

-(void)showTabBar:(BOOL)show
{
    CGRect frame = self.tabBarView.frame;
    if (show){
        if (kScreenHeight == 812) {
            frame.origin.y = kScreenHeight - 83;
        } else {
            frame.origin.y = kScreenHeight - 49;
        }
    }else
    {
        frame.origin.y = kScreenHeight;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.tabBarView.frame = frame;
    }];
}

-(void)setSelect:(NSInteger)selectIndex
{
    self.selectedIndex = selectIndex;
    
    for (id obj in self.tabBarView.subviews)  {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton* theButton = (UIButton*)obj;
            theButton.selected = NO;
            if (theButton.tag == selectIndex + kTagStart) {
                theButton.selected = YES;
            }
        }
    }
}

#pragma mark - 获取所有省市区数据
- (void)getAllAreaAPI {
    NSString *url = [NSString stringWithFormat:@"%@",kAllAreaURL];
    //    NSString *token = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    
    //字条串是否包含有某字符串
    if ([url rangeOfString:@"?"].location == NSNotFound) {
        NSLog(@"string 不存在 ?");
        url = [NSString stringWithFormat:@"%@%@%@",url,kTokenVersion,@""];
    } else {
        NSLog(@"string 包含 ?");
        url = [NSString stringWithFormat:@"%@%@%@",url,kTokenVersions,@""];
    }
    
    url = [NSString stringWithFormat:@"%@&is_hierarchy=1",url];
   
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
        
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
                //处理数据
                if ([dataDic[@"info"] isKindOfClass:[NSArray class]]) {
                    NSArray *areaArray = dataDic[@"info"];
                    if (areaArray.count > 0) {
                        [[NSUserDefaults standardUserDefaults] setObject:areaArray forKey:@"area"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                }
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
}

#pragma mark - 获取所有省市区数据
- (void)getServerDataAPI {
    NSString *url = [NSString stringWithFormat:@"%@", kServerDataURL];
    
    //字条串是否包含有某字符串
    if ([url rangeOfString:@"?"].location == NSNotFound) {
        NSLog(@"string 不存在 ?");
        url = [NSString stringWithFormat:@"%@%@%@",url,kTokenVersion,@""];
    } else {
        NSLog(@"string 包含 ?");
        url = [NSString stringWithFormat:@"%@%@%@",url,kTokenVersions,@""];
    }
    
    url = [NSString stringWithFormat:@"%@&is_hierarchy=1",url];
    
    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
        
        //判断有无数据
        if ([[dict allKeys] containsObject:@"errorCode"]) {
            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
            if ([errorCode isEqualToString:@"-1"]){
                //未登陆
                return;
            }
            
            if ([errorCode isEqualToString:@"0"]) {
                NSDictionary *dataDic = dict[@"data"];
                
                NSDictionary *decorationService = dataDic[@"decoration_service"];
                NSDictionary *welfare = dataDic[@"welfare"];
                NSDictionary *degree = dataDic[@"degree"];
                NSDictionary *workHours = dataDic[@"work_hours"];
                NSDictionary *position = dataDic[@"position"];
                NSDictionary *sort = dataDic[@"sort"];
                
                //处理数据
                [[NSUserDefaults standardUserDefaults] setObject:decorationService forKey:@"decorationService"];
                [[NSUserDefaults standardUserDefaults] setObject:welfare forKey:@"welfare"];
                [[NSUserDefaults standardUserDefaults] setObject:degree forKey:@"degree"];
                [[NSUserDefaults standardUserDefaults] setObject:workHours forKey:@"workHours"];
                [[NSUserDefaults standardUserDefaults] setObject:position forKey:@"position"];
                [[NSUserDefaults standardUserDefaults] setObject:sort forKey:@"sort"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }else {
                [self showHUDTextOnly:[dict[kMessage] objectForKey:kMessage]];
                return;
            }
        }
    }];
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
