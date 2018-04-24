//
//  CollectionTableViewCell.m
//  pe762-ios
//
//  Created by wsy on 2018/4/23.
//  Copyright © 2018年 zmit. All rights reserved.
//  我的收藏夹cell

#import "CollectionTableViewCell.h"

@implementation CollectionTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *centerView = [UIView viewWithFrame:CGRectMake(10 * kScreenWidthProportion, 5 * kScreenWidthProportion, 300 * kScreenWidthProportion, 75 * kScreenWidthProportion) backgroundColor:kWhiteColor];
        [self.contentView addSubview:centerView];
        
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12 * kScreenWidthProportion, 15 * kScreenWidthProportion, 45 * kScreenWidthProportion, 45 * kScreenWidthProportion)];
        [centerView addSubview:self.headImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70 * kScreenWidthProportion, 12 * kScreenWidthProportion, 210 * kScreenWidthProportion, 20 * kScreenWidthProportion)];
        [self.titleLabel setLabelWithTextColor:kBlackLabelColor textAlignment:NSTextAlignmentLeft font:16];
        self.titleLabel.font = FONT_BOLD(15);
        [centerView addSubview:self.titleLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.minX, self.titleLabel.maxY, self.titleLabel.width, 15 * kScreenWidthProportion)];
        [self.contentLabel setLabelWithTextColor:kGrayLabelColor textAlignment:NSTextAlignmentLeft font:12];
        [centerView addSubview:self.contentLabel];
        
        UIImageView *listenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.titleLabel.minX, 0, 17 * kScreenWidthProportion, 11 * kScreenWidthProportion)];
        listenImageView.image = [UIImage imageNamed:@"Path 141"];
        [centerView addSubview:listenImageView];
        
        self.collectBtn = [[UIButton alloc] initWithFrame:CGRectMake(listenImageView.maxX + 5 * kScreenWidthProportion, self.contentLabel.maxY + 1 * kScreenWidthProportion, 80 * kScreenWidthProportion, 20 * kScreenWidthProportion)];
        [self.collectBtn setTitle:@"取消收藏" forState:0];
        [self.collectBtn setTitleColor:kGrayLabelColor forState:0];
        self.collectBtn.titleLabel.font = FONT(11 * kFontProportion);
        [centerView addSubview:self.collectBtn];
        
        listenImageView.centerY = self.collectBtn.centerY;
        
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
