//
//  MajorTableViewCell.m
//  pe762-ios
//
//  Created by Future on 2018/5/15.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import "MajorTableViewCell.h"

@implementation MajorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        
        // 标题
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = kBlackLabelColor;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = FONT(13 * kFontProportion);
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(14 * kScreenHeightProportion);
            make.left.mas_equalTo(self.contentView).offset(10 * kScreenWidthProportion);
            make.size.mas_equalTo(CGSizeMake(200 * kScreenWidthProportion, 16 * kScreenHeightProportion));
        }];
        
        // 图标
        self.moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Path 185"]];
        [self.contentView addSubview:self.moreImageView];
        [self.moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel).offset(3.5 * kScreenHeightProportion);
            make.right.mas_equalTo(self.contentView).offset(-10 * kScreenWidthProportion);
            make.size.mas_equalTo(CGSizeMake(6 * kScreenWidthProportion, 9 * kScreenHeightProportion));
        }];
        
        // 标签view
        self.typeView = [[UIView alloc] init];
        self.typeView.backgroundColor = kWhiteColor;
        [self.contentView addSubview:self.typeView];
        [self.typeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8 * kScreenHeightProportion);
            make.left.mas_equalTo(self.contentView).offset(10 * kScreenWidthProportion);
            make.right.mas_equalTo(self.contentView).offset(-10 * kScreenWidthProportion);
            make.height.mas_equalTo(0);
        }];
        
        // 下划线
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = kLineGrayColor;
        [self.contentView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.typeView.mas_bottom).offset(2 * kScreenHeightProportion - 1);
            make.left.mas_equalTo(self.contentView).offset(10 * kScreenWidthProportion);
            make.right.mas_equalTo(self.contentView).offset(-10 * kScreenWidthProportion);
            make.height.mas_equalTo(1);
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
