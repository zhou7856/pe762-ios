//
//  UIViewController+Navigation.m
//  pe762-ios
//
//  Created by wsy on 2018/4/23.
//  Copyright © 2018年 zmit. All rights reserved.
//  导航分类

#import "UIViewController+Navigation.h"

@implementation UIViewController (Navigation)

//创建基于标题的导航
- (void)createNavigationTitle:(NSString *)title {
    if (kScreenHeight == 812) {
        NSLog(@"this is iPhone X");
        self.navigationController.navigationBarHidden = YES;
        UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        statusView.backgroundColor = kWhiteColor;
        [self.view addSubview:statusView];
        
        UIView *view = [UIView viewWithFrame:CGRectMake(0, 44, kScreenWidth, 44) backgroundColor:kWhiteColor];
        [self.view addSubview:view];
        
        UILabel *label = [UILabel labelWithFrame:CGRectMake(0, -12, 200, 56) text:title textAlignment:NSTextAlignmentCenter font:FONT(16)];
        label.centerX = kScreenWidth/2.0;
        label.textColor = kBlackLabelColor;
        //        label.backgroundColor = [UIColor redColor];
        [view addSubview:label];
        
        UIView *lineView = [UIView viewWithFrame:CGRectMake(0, 43, kScreenWidth, 1) backgroundColor:kLineGrayColor];
        [view addSubview:lineView];
    } else {
        self.navigationController.navigationBarHidden = YES;
        
        UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        statusView.backgroundColor = kWhiteColor;
        [self.view addSubview:statusView];
        
        UIView *view = [UIView viewWithFrame:CGRectMake(0, 20, kScreenWidth, 44) backgroundColor:[UIColor whiteColor]];
        [self.view addSubview:view];
        
        UILabel *label = [UILabel labelWithFrame:CGRectMake(0, 0, 200 * kScreenWidthProportion, 44) text:title textAlignment:NSTextAlignmentCenter font:FONT(16)];
        label.centerX = kScreenWidth/2.0;
        label.textColor = kBlackLabelColor;
        [view addSubview:label];
        
        UIView *lineView = [UIView viewWithFrame:CGRectMake(0, 43, kScreenWidth, 1) backgroundColor:kLineGrayColor];
        [view addSubview:lineView];
    }
}

//文本和功能的导航
- (void)createNavigationFeatureAndTitle:(NSString *)title withLeftBtn:(UIButton *)leftBtn andRightBtn:(UIButton *)rightBtn andTypeTitle:(UILabel *)typeLabel{
    if (kScreenHeight == 812) {
        NSLog(@"this is iPhone X");
        self.navigationController.navigationBarHidden = YES;
        UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        statusView.backgroundColor = kWhiteColor;
        [self.view addSubview:statusView];
        
        UIView *view = [UIView viewWithFrame:CGRectMake(0, 44, kScreenWidth, 44) backgroundColor:kWhiteColor];
        [self.view addSubview:view];
        
        UILabel *label = [UILabel labelWithFrame:CGRectMake(0, -12, 200, 56) text:title textAlignment:NSTextAlignmentCenter font:FONT(16)];
        label.centerX = kScreenWidth/2.0;
        label.textColor = kBlackLabelColor;
        [view addSubview:label];
        
        leftBtn.frame = CGRectMake(0, 0, 100 * kScreenWidthProportion, view.height);
        [view addSubview:leftBtn];
        
        //        typeLabel = [[UILabel alloc] init];
        [typeLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentRight font:13];
        [view addSubview:typeLabel];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 60"]];
        iconImageView.tag = kTagStart + 10001;
        iconImageView.userInteractionEnabled = YES;
        [view addSubview:iconImageView];
        
        UIView *typeView = [[UIView alloc] init];
        //        typeView.backgroundColor = kRedColor;
        [view addSubview:typeView];
        
        [typeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(leftBtn);
            make.centerX.mas_equalTo(leftBtn);
            make.left.mas_equalTo(typeLabel);
            make.right.mas_equalTo(iconImageView);
            make.width.mas_lessThanOrEqualTo(leftBtn.mas_width);
        }];
        
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(typeView);
            make.right.mas_equalTo(iconImageView.mas_left).offset(-10);
            make.height.mas_equalTo(20);
        }];
        
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(typeView);
            make.left.mas_equalTo(typeLabel.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(8 * kScreenWidthProportion, 7 * kScreenWidthProportion));
        }];
        
        [view bringSubviewToFront:leftBtn];
        
        UIImageView *rightIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 33 * kScreenWidthProportion, 0, 18 * kScreenWidthProportion, 20 * kScreenWidthProportion)];
        rightIconImageView.centerY = leftBtn.centerY;
        rightIconImageView.image = [UIImage imageNamed:@"Layer_1_1_"];
        [view addSubview:rightIconImageView];
        
        rightBtn.frame = CGRectMake(270 * kScreenWidthProportion, leftBtn.minY, 50 * kScreenWidthProportion, leftBtn.height);
        [view addSubview:rightBtn];
        
        UIView *lineView = [UIView viewWithFrame:CGRectMake(0, 43, kScreenWidth, 1) backgroundColor:kLineGrayColor];
        [view addSubview:lineView];
    } else {
        self.navigationController.navigationBarHidden = YES;
        
        UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        statusView.backgroundColor = kWhiteColor;
        [self.view addSubview:statusView];
        
        UIView *view = [UIView viewWithFrame:CGRectMake(0, 20, kScreenWidth, 44) backgroundColor:[UIColor whiteColor]];
        [self.view addSubview:view];
        
        UILabel *label = [UILabel labelWithFrame:CGRectMake(0, 0, 200 * kScreenWidthProportion, 44) text:title textAlignment:NSTextAlignmentCenter font:FONT(16)];
        label.centerX = kScreenWidth/2.0;
        label.textColor = kBlackLabelColor;
        [view addSubview:label];
        
        leftBtn.frame = CGRectMake(0, 0, 100 * kScreenWidthProportion, view.height);
        [view addSubview:leftBtn];
        
//        typeLabel = [[UILabel alloc] init];
        [typeLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentRight font:13];
        [view addSubview:typeLabel];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 60"]];
        iconImageView.tag = kTagStart + 10001;
        iconImageView.userInteractionEnabled = YES;
        [view addSubview:iconImageView];
        
        UIView *typeView = [[UIView alloc] init];
        //        typeView.backgroundColor = kRedColor;
        [view addSubview:typeView];
        
        [typeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(leftBtn);
            make.centerX.mas_equalTo(leftBtn);
            make.left.mas_equalTo(typeLabel);
            make.right.mas_equalTo(iconImageView);
            make.width.mas_lessThanOrEqualTo(leftBtn.mas_width);
        }];
        
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(typeView);
            make.right.mas_equalTo(iconImageView.mas_left).offset(-10);
            make.height.mas_equalTo(20);
        }];
        
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(typeView);
            make.left.mas_equalTo(typeLabel.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(8 * kScreenWidthProportion, 7 * kScreenWidthProportion));
        }];
        
        [view bringSubviewToFront:leftBtn];
        
        UIImageView *rightIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth - 33 * kScreenWidthProportion, 0, 18 * kScreenWidthProportion, 20 * kScreenWidthProportion)];
        rightIconImageView.centerY = leftBtn.centerY;
        rightIconImageView.image = [UIImage imageNamed:@"Layer_1_1_"];
        [view addSubview:rightIconImageView];
        
        rightBtn.frame = CGRectMake(270 * kScreenWidthProportion, leftBtn.minY, 50 * kScreenWidthProportion, leftBtn.height);
        [view addSubview:rightBtn];
        
        UIView *lineView = [UIView viewWithFrame:CGRectMake(0, 43, kScreenWidth, 1) backgroundColor:kLineGrayColor];
        [view addSubview:lineView];

    }
}


//创建底部返回
- (void)createEndBackView {
    if (kScreenHeight == 812) {
        NSLog(@"this is iPhone X");
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kEndBackViewHeight, kScreenWidth, kEndBackViewHeight)];
        backView.backgroundColor = RGB(239, 239, 239);
        [self.view addSubview:backView];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 * kScreenWidthProportion, 9 * kScreenWidthProportion, 15 * kScreenWidthProportion, 22 * kScreenWidthProportion)];
        iconImageView.image = [UIImage imageNamed:@"Path 164"];
        [backView addSubview:iconImageView];
        
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50 * kScreenWidthProportion, 40 * kScreenWidthProportion)];
        [backView addSubview:backBtn];
        [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    } else {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kEndBackViewHeight, kScreenWidth, kEndBackViewHeight)];
        backView.backgroundColor = RGB(239, 239, 239);
        [self.view addSubview:backView];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 * kScreenWidthProportion, 9 * kScreenWidthProportion, 15 * kScreenWidthProportion, 22 * kScreenWidthProportion)];
        iconImageView.image = [UIImage imageNamed:@"Path 164"];
        [backView addSubview:iconImageView];
        
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50 * kScreenWidthProportion, 40 * kScreenWidthProportion)];
        [backView addSubview:backBtn];
        [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)backBtnAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
