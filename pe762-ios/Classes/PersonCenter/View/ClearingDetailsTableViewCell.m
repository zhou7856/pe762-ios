//
//  ClearingDetailsTableViewCell.m
//  pe762-ios
//
//  Created by wsy on 2018/4/24.
//  Copyright © 2018年 zmit. All rights reserved.
//  结算详情cell

#import "ClearingDetailsTableViewCell.h"

@implementation ClearingDetailsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *centerView = [UIView viewWithFrame:CGRectMake(10 * kScreenWidthProportion, 5 * kScreenWidthProportion, 300 * kScreenWidthProportion, 40 * kScreenWidthProportion) backgroundColor:kWhiteColor];
        [self.contentView addSubview:centerView];
        
        self.headImgeView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * kScreenWidthProportion, 7 * kScreenWidthProportion, 26 * kScreenWidthProportion, 26 * kScreenWidthProportion)];
        [self.headImgeView setCornerRadius:13 * kScreenWidthProportion];
        [centerView addSubview:self.headImgeView];
        
        self.nameLabel = [[UILabel alloc] init];
        [self.nameLabel setLabelWithTextColor:kBlackColor textAlignment:NSTextAlignmentLeft font:14];
        self.nameLabel.font = FONT_BOLD(14);
        [centerView addSubview:self.nameLabel];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40 * kScreenWidthProportion);
            make.top.bottom.mas_equalTo(centerView);
            make.width.mas_equalTo(36 * kScreenWidthProportion);
        }];
        
        self.phoneLabel = [[UILabel alloc] init];
        [self.phoneLabel setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentLeft font:13];
        [centerView addSubview:self.phoneLabel];
        
        [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_right).offset(5 * kScreenWidthProportion);
            make.top.bottom.mas_equalTo(centerView);
        }];
        
        self.timeLabel = [[UILabel alloc] init];
        [self.timeLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentRight font:11];
        [centerView addSubview:self.timeLabel];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10 * kScreenWidthProportion);
            make.top.bottom.mas_equalTo(self.nameLabel);
        }];
        
        UILabel *timeTitleLabel = [[UILabel alloc] init];
        [timeTitleLabel setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentRight font:11];
        timeTitleLabel.text = @"注册时间 : ";
        [centerView addSubview:timeTitleLabel];
        
        [timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.timeLabel.mas_left);
            make.top.bottom.mas_equalTo(self.nameLabel);
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
