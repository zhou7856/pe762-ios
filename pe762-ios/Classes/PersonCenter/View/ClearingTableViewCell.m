//
//  ClearingTableViewCell.m
//  pe762-ios
//
//  Created by wsy on 2018/4/24.
//  Copyright © 2018年 zmit. All rights reserved.
//  结算cell

#import "ClearingTableViewCell.h"

@implementation ClearingTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *centerView = [UIView viewWithFrame:CGRectMake(10 * kScreenWidthProportion, 5 * kScreenWidthProportion, 300 * kScreenWidthProportion, 55 * kScreenWidthProportion) backgroundColor:kWhiteColor];
        [self.contentView addSubview:centerView];
        
        {
            UILabel *titleLabel = [[UILabel alloc] init];
            [titleLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentLeft font:12];
            titleLabel.text = @"结算金额 :";
            [centerView addSubview:titleLabel];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15 * kScreenWidthProportion);
                make.top.mas_equalTo(10 * kScreenWidthProportion);
                make.height.mas_equalTo(16 * kScreenWidthProportion);
            }];
            
            self.priceLabel = [[UILabel alloc] init];
            [self.priceLabel setLabelWithTextColor:kBlackColor textAlignment:NSTextAlignmentCenter font:13];
            [centerView addSubview:self.priceLabel];
//            self.priceLabel.text = @"100";
            
            [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(titleLabel);
                make.left.mas_equalTo(titleLabel.mas_right);
            }];
            
            UILabel *unitLabel = [[UILabel alloc] init];
            [unitLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentRight font:12];
            unitLabel.text = @" 元";
            [centerView addSubview:unitLabel];
            
            [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(titleLabel);
                make.left.mas_equalTo(self.priceLabel.mas_right);
            }];
        }
        
        {
            
//            UILabel *unitLabel = [[UILabel alloc] init];
//            [unitLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentRight font:12];
//            unitLabel.text = @" 元";
//            [clearingView addSubview:unitLabel];
//
//            [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.mas_equalTo(clearingView).offset(-15 * kScreenWidthProportion);
//                make.centerY.mas_equalTo(numberLabel);
//                make.height.mas_equalTo(numberLabel);
//            }];
            
            self.timeLabel = [[UILabel alloc] init];
            [self.timeLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentCenter font:13];
            [centerView addSubview:self.timeLabel];
            self.timeLabel.text = @"1500";
            
            [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(centerView).offset(-20 * kScreenWidthProportion);
                make.centerY.mas_equalTo(self.priceLabel);
                make.height.mas_equalTo(self.priceLabel);
            }];
            
            UILabel *titleLabel = [[UILabel alloc] init];
            [titleLabel setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentLeft font:12];
            titleLabel.text = @"结算时间 :";
            [centerView addSubview:titleLabel];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.timeLabel.mas_left);
                make.centerY.mas_equalTo(self.timeLabel);
                make.height.mas_equalTo(self.timeLabel);
            }];
        }
        
        {
            UILabel *titleLabel = [[UILabel alloc] init];
            [titleLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentLeft font:12];
            titleLabel.text = @"人     数 :";
            [centerView addSubview:titleLabel];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(15 * kScreenWidthProportion);
                make.top.mas_equalTo(30 * kScreenWidthProportion);
                make.height.mas_equalTo(16 * kScreenWidthProportion);
            }];
            
            self.numberLabel = [[UILabel alloc] init];
            [self.numberLabel setLabelWithTextColor:kBlackColor textAlignment:NSTextAlignmentLeft font:13];
            [centerView addSubview:self.numberLabel];
            //            self.priceLabel.text = @"100";
            
            [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(titleLabel);
                make.left.mas_equalTo(titleLabel.mas_right);
            }];
            
            UILabel *unitLabel = [[UILabel alloc] init];
            [unitLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentRight font:12];
            unitLabel.text = @" 人";
            [centerView addSubview:unitLabel];
            
            [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(titleLabel);
                make.left.mas_equalTo(self.numberLabel.mas_right);
            }];
        }
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Path 185"]];
        [centerView addSubview:iconImageView];
        
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(6 * kScreenWidthProportion, 9 * kScreenWidthProportion));
            make.centerY.mas_equalTo(self.numberLabel);
            make.right.mas_equalTo(centerView).offset(-20 * kScreenWidthProportion);
        }];
        
        self.typeLabel = [[UILabel alloc] init];
        [self.typeLabel setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentRight font:13];
        self.typeLabel.text = @"已完成";
        [centerView addSubview:self.typeLabel];
        
        [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(iconImageView.mas_left).offset(-5 * kScreenWidthProportion);
            make.centerY.mas_equalTo(iconImageView);
            make.height.mas_equalTo(16 * kScreenWidthProportion);
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
