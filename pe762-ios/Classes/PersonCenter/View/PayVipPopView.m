//
//  PayVipPopView.m
//  pe762-ios
//
//  Created by Future on 2018/5/10.
//  Copyright © 2018年 zmit. All rights reserved.
//  开通会员弹窗

#import "PayVipPopView.h"

@implementation PayVipPopView

- (void)createViewWithBlock:(PayVipPopBlock) block andMoney:(NSString *)money{
    PayVipPopView *popView = [[PayVipPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    popView.block = block;
    popView.type = 1;
    [[UIApplication sharedApplication].keyWindow addSubview:popView];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    backButton.backgroundColor = RGBA(0, 0, 0, 0.6);
    [backButton addTarget:popView action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [popView addSubview:backButton];
    
    //中心view 160
    UIView *centerView = [UIView viewWithFrame:CGRectMake(0, kScreenHeight - 256 * kScreenWidthProportion, kScreenWidth, 256 * kScreenWidthProportion) backgroundColor:kWhiteColor];
    [centerView setCornerRadius:4];
    [popView addSubview:centerView];
    
    // 去支付
    UIButton *openBtn = [[UIButton alloc] init];
    openBtn.backgroundColor = RGB(122, 37, 188);
    [openBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [openBtn setTitle:[NSString stringWithFormat:@"使用支付宝支付 ¥ %@", money] forState:UIControlStateNormal];
    openBtn.titleLabel.font = FONT(13 * kFontProportion);
    [centerView addSubview:openBtn];
    [openBtn.titleLabel rangeTextStringFont:FONT(28 * kFontProportion) range:NSMakeRange(openBtn.titleLabel.text.length - money.length, money.length)];
    [openBtn addTarget:self action:@selector(goPayAction) forControlEvents:UIControlEventTouchUpInside];
    
    [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(centerView);
        make.height.mas_equalTo(66 * kScreenWidthProportion);
    }];
    
    
    
    // 微信
    UIButton *wcBtn = [[UIButton alloc] init];
    wcBtn.backgroundColor = kWhiteColor;
    wcBtn.tag = 2;
    wcBtn.selected = NO;
    [centerView addSubview:wcBtn];
    [wcBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(openBtn.mas_top);
        make.left.right.mas_equalTo(openBtn);
        make.height.mas_equalTo(69 * kScreenWidthProportion);
    }];
    
    // 图标
    UIImageView *wcImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 177"]];
    [wcBtn addSubview:wcImageView];
    [wcImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(wcBtn);
        make.left.mas_equalTo(openBtn).offset(26 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(38 * kScreenWidthProportion, 31 * kScreenWidthProportion));
    }];
    
    // 标题
    UILabel *wcTitleLabel = [[UILabel alloc] init];
    wcTitleLabel.text = @"微信支付";
    wcTitleLabel.textColor = kBlackLabelColor;
    wcTitleLabel.textAlignment = NSTextAlignmentLeft;
    wcTitleLabel.font = FONT(13 * kFontProportion);
    [wcBtn addSubview:wcTitleLabel];
    [wcTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(wcBtn);
        make.left.mas_equalTo(wcImageView.mas_right).offset(8 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(60 * kScreenWidthProportion, 23 * kScreenWidthProportion));
    }];
    
    // 全圈
    //UIImageView *selectedWCImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Ellipse 34"]];
    UIButton *selectedWCImageView = [[UIButton alloc] init];
    selectedWCImageView.tag = 2;
    selectedWCImageView.selected = NO;
    [selectedWCImageView setBackgroundImage:[UIImage imageNamed:@"Ellipse 34"] forState:UIControlStateNormal];
    [selectedWCImageView setBackgroundImage:[UIImage imageNamed:@"Path 215"] forState:UIControlStateSelected];
    [wcBtn addSubview:selectedWCImageView];
    [selectedWCImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(wcBtn);
        make.right.mas_equalTo(wcBtn).offset(-20 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(23 * kScreenWidthProportion, 23 * kScreenWidthProportion));
    }];
    
    // 分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = kLineGrayColor;
    [centerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(wcBtn.mas_top);
        make.left.right.mas_equalTo(wcBtn);
        make.height.mas_equalTo(1 * kScreenWidthProportion);
    }];
    
    // 支付宝
    UIButton *alipayBtn = [[UIButton alloc] init];
    alipayBtn.backgroundColor = kWhiteColor;
    [centerView addSubview:alipayBtn];
    [alipayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(lineView.mas_top);
        make.left.right.mas_equalTo(wcBtn);
        make.height.mas_equalTo(wcBtn);
    }];
    
    // 图标
    UIImageView *alipayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 180"]];
    [alipayBtn addSubview:alipayImageView];
    [alipayImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(alipayBtn);
        make.left.mas_equalTo(wcBtn).offset(26 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(38 * kScreenWidthProportion, 31 * kScreenWidthProportion));
    }];
    
    // 标题
    UILabel *alipayTitleLabel = [[UILabel alloc] init];
    alipayTitleLabel.text = @"支付宝支付";
    alipayTitleLabel.textColor = kBlackLabelColor;
    alipayTitleLabel.textAlignment = NSTextAlignmentLeft;
    alipayTitleLabel.font = FONT(13 * kFontProportion);
    [alipayBtn addSubview:alipayTitleLabel];
    [alipayTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(alipayBtn);
        make.left.mas_equalTo(alipayImageView.mas_right).offset(8 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(80 * kScreenWidthProportion, 23 * kScreenWidthProportion));
    }];
    
    // 全圈
    //UIImageView *selectedALImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Ellipse 34"]];
    UIButton *selectedALImageView = [[UIButton alloc] init];
    selectedALImageView.tag = 1;
    selectedALImageView.selected = YES;
    [selectedALImageView setBackgroundImage:[UIImage imageNamed:@"Ellipse 34"] forState:UIControlStateNormal];
    [selectedALImageView setBackgroundImage:[UIImage imageNamed:@"Path 215"] forState:UIControlStateSelected];
    [alipayBtn addSubview:selectedALImageView];
    [selectedALImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(alipayBtn);
        make.right.mas_equalTo(alipayBtn).offset(-20 * kScreenWidthProportion);
        make.size.mas_equalTo(CGSizeMake(23 * kScreenWidthProportion, 23 * kScreenWidthProportion));
    }];
    
    
    // 一级白色内容背景
    UIView *oneContenView = [[UIView alloc] init];
    oneContenView.backgroundColor = kWhiteColor;
    [centerView addSubview:oneContenView];
    
    [oneContenView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(alipayBtn.mas_top);
        make.left.right.mas_equalTo(alipayBtn);
        make.height.mas_equalTo(30 * kScreenHeightProportion);
    }];
    
    // 标题
    UILabel *vipTitleLabel = [[UILabel alloc] init];
    vipTitleLabel.text = @"一年期会员";
    vipTitleLabel.textColor = kBlackLabelColor;
    vipTitleLabel.textAlignment = NSTextAlignmentLeft;
    vipTitleLabel.font = FONT(13 * kFontProportion);
    [oneContenView addSubview:vipTitleLabel];
    
    UIImageView *vipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Group 129"]];
    [oneContenView addSubview:vipImageView];
    
    UILabel *vipMoneyLabel = [[UILabel alloc] init];
    vipMoneyLabel.text = [NSString stringWithFormat:@"%@元", money];
    vipMoneyLabel.textColor = kBlackLabelColor;
    vipMoneyLabel.textAlignment = NSTextAlignmentRight;
    vipMoneyLabel.font = FONT(13 * kFontProportion);
    [oneContenView addSubview:vipMoneyLabel];
    
    [vipTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(oneContenView);
        make.left.mas_equalTo(oneContenView).offset(26 * kScreenWidthProportion);
        make.width.mas_equalTo(70 * kScreenWidthProportion);
        make.height.mas_equalTo(19 * kScreenHeightProportion);
    }];
    
    [vipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(vipTitleLabel).offset(4);
        make.left.mas_equalTo(vipTitleLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(33 * kScreenWidthProportion, 12 * kScreenHeightProportion));
    }];
    
    [vipMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(oneContenView);
        make.right.mas_equalTo(oneContenView).offset(-20 * kScreenWidthProportion);
        make.width.mas_equalTo(78 * kScreenWidthProportion);
        make.height.mas_equalTo(19 * kScreenHeightProportion);
    }];
    
    
    [[selectedWCImageView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (selectedWCImageView.isSelected == YES) {
            selectedWCImageView.selected = NO;
            selectedALImageView.selected = YES;
            popView.type = 1;
        } else {
            selectedWCImageView.selected = YES;
            selectedALImageView.selected = NO;
            popView.type = 2;
        }
    }];
    
    [[selectedALImageView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (selectedALImageView.isSelected == YES) {
            selectedWCImageView.selected = YES;
            selectedALImageView.selected = NO;
            popView.type = 2;
        } else {
            selectedWCImageView.selected = NO;
            selectedALImageView.selected = YES;
            popView.type = 1;
        }
    }];
}

- (void)backButtonAction {
    [self removeFromSuperview];
}

- (void) goPayAction{
    if (self.block != nil) {
        self.block(self, self.type);
    }
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
