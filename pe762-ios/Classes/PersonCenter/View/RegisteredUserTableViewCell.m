//
//  RegisteredUserTableViewCell.m
//  pe762-ios
//
//  Created by wsy on 2018/4/24.
//  Copyright © 2018年 zmit. All rights reserved.
//  注册用户cell

#import "RegisteredUserTableViewCell.h"

@implementation RegisteredUserTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *centerView = [UIView viewWithFrame:CGRectMake(10 * kScreenWidthProportion, 5 * kScreenWidthProportion, 300 * kScreenWidthProportion, 65 * kScreenWidthProportion) backgroundColor:kWhiteColor];
        [self.contentView addSubview:centerView];
        
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12 * kScreenWidthProportion, 10 * kScreenWidthProportion, 45 * kScreenWidthProportion, 45 * kScreenWidthProportion)];
        [centerView addSubview:self.headImageView];
        [self.headImageView setCornerRadius:45 / 2 * kScreenWidthProportion];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70 * kScreenWidthProportion, 10 * kScreenWidthProportion, 110 * kScreenWidthProportion, 20 * kScreenWidthProportion)];
        [self.nameLabel setLabelWithTextColor:kBlackColor textAlignment:NSTextAlignmentLeft font:14];
        self.nameLabel.font = FONT_BOLD(14);
        [centerView addSubview:self.nameLabel];
        
        self.phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.minX, self.nameLabel.maxY + 5 * kScreenWidthProportion, self.nameLabel.width, 15 * kScreenWidthProportion)];
        [self.phoneLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentLeft font:13];
        [centerView addSubview:self.phoneLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(180 * kScreenWidthProportion, 25 * kScreenWidthProportion, 110 * kScreenWidthProportion, 15 * kScreenWidthProportion)];
        [self.timeLabel setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentLeft font:10];
        [centerView addSubview:self.timeLabel];
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
