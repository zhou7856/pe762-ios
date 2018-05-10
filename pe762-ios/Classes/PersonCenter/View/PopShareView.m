//
//  PopShareView.m
//  pe762-ios
//
//  Created by Future on 2018/5/10.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import "PopShareView.h"

@implementation PopShareView

//创建
- (void)createViewWithBlock:(PopShareBlock) block {
    PopShareView *popView = [[PopShareView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    popView.block = block;
    [[UIApplication sharedApplication].keyWindow addSubview:popView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backButton.backgroundColor = RGBA(0, 0, 0, 0.6);
    [backButton addTarget:popView action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [popView addSubview:backButton];
    
    //中心view 160
    UIView *centerView = [UIView viewWithFrame:CGRectMake(0, kScreenHeight - 67 * kScreenWidthProportion, kScreenWidth, 67 * kScreenWidthProportion) backgroundColor:kBackgroundWhiteColor];
    [popView addSubview:centerView];
    
    NSArray *titleArray = @[@"新浪微博",@"微信",@"QQ",@"朋友圈"];
    NSArray *iconImageArray = @[@"Group 159",@"Group 160",@"Group 161",@"Group 162"];
    
    CGFloat width = kScreenWidth / 4;
    UIView *endView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 67 * kScreenWidthProportion)];
    [centerView addSubview:endView];
    //    UIView *lastClickView;
    for (int i = 0; i < 4; i++) {
        UIView *clickView = [[UIView alloc] init];
        [endView addSubview:clickView];
        
        [clickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(width * i);
            make.width.mas_equalTo(width);
            make.top.bottom.mas_equalTo(endView);
        }];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconImageArray[i]]];
        [clickView addSubview:iconImageView];
        
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(36 * kScreenWidthProportion, 36 * kScreenWidthProportion));
            make.centerX.mas_equalTo(clickView);
            make.top.mas_equalTo(7 * kScreenWidthProportion);
        }];
        
        UILabel *typeTitleLabel = [[UILabel alloc] init];
        [typeTitleLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentCenter font:11];
        typeTitleLabel.text = titleArray[i];
        [clickView addSubview:typeTitleLabel];
        
        [typeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(clickView);
            make.top.mas_equalTo(iconImageView.mas_bottom).offset(3 * kScreenWidthProportion);
            make.height.mas_equalTo(13 * kScreenWidthProportion);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [[tap rac_gestureSignal] subscribeNext:^(id x) {
            [popView chooseTypeAction:(i + 1)];
        }];
        [clickView addGestureRecognizer:tap];
        
    }
    
}

- (void)backButtonAction {
    [self removeFromSuperview];
}

- (void)chooseTypeAction:(NSInteger)type {
    if (self.block != nil) {
        self.block(self, [NSString stringWithFormat:@"%ld",type]);
    }
    [self removeFromSuperview];
}



@end
