//
//  NewestTableViewCell.m
//  pe762-ios
//
//  Created by Future on 2018/4/24.
//  Copyright © 2018年 zmit. All rights reserved.
//  上新cell

#import "NewestTableViewCell.h"

@implementation NewestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 阴影
        UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(10 * kScreenWidthProportion, 5 * kScreenHeightProportion, kScreenWidth - 20 * kScreenWidthProportion, 115 * kScreenHeightProportion)];
        shadowView.backgroundColor = RGBA(220, 220, 220, 0.8);
        [shadowView setCornerRadius:4.0f];
        [self.contentView addSubview:shadowView];
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(1 * kScreenWidthProportion, 0, shadowView.width - 2 * kScreenWidthProportion, shadowView.height - 1 * kScreenWidthProportion)];
        baseView.backgroundColor = kWhiteColor;
        [baseView setCornerRadius:4.0f];
        [shadowView addSubview:baseView];
        
        // 图片
        self.iconImageView = [[UIImageView alloc] init];
        [shadowView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(baseView).offset(6 * kScreenWidthProportion);
            make.top.mas_equalTo(baseView).offset(5 * kScreenHeightProportion);
            make.bottom.mas_equalTo(baseView).offset(-5 * kScreenHeightProportion);
            make.width.mas_equalTo(71 * kScreenWidthProportion);
        }];
        
        // 类型
        self.classLabel = [[UILabel alloc] init];
        self.classLabel.textColor = kBlackLabelColor;
        self.classLabel.font = FONT(10 * kFontProportion);
        self.classLabel.textAlignment = NSTextAlignmentCenter;
        [self.classLabel setCornerRadius:2.0f];
        self.classLabel.backgroundColor = RGB(165, 165, 165);
        [baseView addSubview:self.classLabel];
        [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImageView.mas_right).offset(12 * kScreenWidthProportion);
            make.top.mas_equalTo(self.iconImageView).offset(9 * kScreenHeightProportion);
            make.size.mas_equalTo(CGSizeMake(50 * kScreenWidthProportion, 13 * kScreenHeightProportion));
        }];
        
        // 名称
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = kBlackLabelColor;
        self.nameLabel.font = FONT(15 * kFontProportion);
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        [baseView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.classLabel);
            make.top.mas_equalTo(self.classLabel.mas_bottom).offset(10 * kScreenHeightProportion);
            make.size.mas_equalTo(CGSizeMake(180 * kScreenWidthProportion, 17 * kScreenHeightProportion));
        }];
        
        // 详情
        self.detailLabel = [[UILabel alloc] init];
        self.detailLabel.textColor = kTextFieldColor;
        self.detailLabel.font = FONT(11 * kFontProportion);
        self.detailLabel.textAlignment = NSTextAlignmentLeft;
        [baseView addSubview:self.detailLabel];
        [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(2 * kScreenHeightProportion);
            make.size.mas_equalTo(CGSizeMake(146 * kScreenWidthProportion, 12 * kScreenHeightProportion));
        }];
        
        // 热度图标
        UIImageView *hotImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Path 116"]];
        [self.contentView addSubview:hotImageView];
        [hotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImageView.mas_right).offset(12 * kScreenWidthProportion);
            make.bottom.mas_equalTo(self.iconImageView).offset(-5 * kScreenHeightProportion);
            make.size.mas_equalTo(CGSizeMake(8 * kScreenWidthProportion, 11 * kScreenHeightProportion));
        }];
        
        // 热度
        self.hotLabel = [[UILabel alloc] init];
        self.hotLabel.textColor = kTextFieldColor;
        self.hotLabel.font = FONT(10 * kFontProportion);
        self.hotLabel.textAlignment = NSTextAlignmentLeft;
        [baseView addSubview:self.hotLabel];
        [self.hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(hotImageView.mas_right).offset(4 * kScreenWidthProportion);
            make.bottom.mas_equalTo(hotImageView);
            make.size.mas_equalTo(CGSizeMake(100 * kScreenWidthProportion, 11 * kScreenHeightProportion));
        }];
        
        // 日期
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.textColor = kTextFieldColor;
        self.dateLabel.font = FONT(10 * kFontProportion);
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        [baseView addSubview:self.dateLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(baseView).offset(-11 * kScreenWidthProportion);
            make.bottom.mas_equalTo(baseView).offset(-10 * kScreenHeightProportion);
            make.size.mas_equalTo(CGSizeMake(140 * kScreenWidthProportion, 11 * kScreenHeightProportion));
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
