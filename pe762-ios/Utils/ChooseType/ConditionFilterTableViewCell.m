//
//  ConditionFilterTableViewCell.m
//  pf435-company-ios
//
//  Created by wsy on 2017/11/20.
//  Copyright © 2017年 zmit. All rights reserved.
//  条件cell

#import "ConditionFilterTableViewCell.h"

@implementation ConditionFilterTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40 * kScreenHeightProportion)];
        [self.titleLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentCenter font:13];
        [self.contentView addSubview:self.titleLabel];
        
        UIView *endLine = [UIView viewWithFrame:CGRectMake(40 * kScreenWidthProportion, 40 * kScreenHeightProportion - 1, 240 * kScreenWidthProportion, 1) backgroundColor:kLineGrayColor];
        [self.contentView addSubview:endLine];
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
