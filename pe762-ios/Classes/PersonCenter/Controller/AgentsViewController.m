//
//  AgentsViewController.m
//  pe762-ios
//
//  Created by wsy on 2018/4/24.
//  Copyright © 2018年 zmit. All rights reserved.
//  代理商页面

#import "AgentsViewController.h"
#import "RegisteredUserTableViewCell.h" //注册用户cell

@interface AgentsViewController ()
{
    //0 注册用户 1 vip用户 2 已结算
    NSInteger type;
    
    UIView *userView; //注册用户下方页面
    UITableView *userListTableView;
    NSArray *userListArray;
    
    UIView *vipView; //vip用户下方页面
    UIView *settledView; //已结算下方页面
    
}
@end

@implementation AgentsViewController

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

- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)initNav {
    [self createNavigationTitle:@"代理商"];
    
    [self createEndBackView];
}

- (void)initUI {
    NSArray *titleArray = @[@"注册用户",@"VIP用户",@"已结算"];
    
    for (int i = 0; i < 3; i++) {
        UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(40 * kScreenWidthProportion + 80 * kScreenWidthProportion * i, 30 * kScreenWidthProportion + kHeaderHeight, 80 * kScreenWidthProportion, 30 * kScreenWidthProportion)];
        titleButton.tag = kTagStart + 10000 + i;
        [titleButton setTitle:titleArray[i] forState:0];
        [titleButton setTitleColor:kGrayLabelColor forState:0];
        titleButton.titleLabel.font = FONT(13 * kFontProportion);
        [self.view addSubview:titleButton];
        
        if (i != 2) {
            UIView *lineView = [UIView viewWithFrame:CGRectMake(titleButton.maxY, titleButton.minY + 9 * kScreenWidthProportion, 2, 12 * kScreenWidthProportion) backgroundColor:RGB(215, 215, 215)];
            [self.view addSubview:lineView];
        }
        
        [[titleButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            type = i;
            [self typeChangeAPI:i];
        }];
    }
    
    [self typeChangeAPI:0];
}

#pragma mark - 按钮点击
- (void)typeChangeAPI:(NSInteger) typeNumber {
    type = typeNumber;
    for (int i = 0; i < 3; i++)  {
        NSInteger tagNumber = i + kTagStart + 10000;
        UIButton *titleButton = [self.view viewWithTag:tagNumber];
        if (i == typeNumber) {
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
