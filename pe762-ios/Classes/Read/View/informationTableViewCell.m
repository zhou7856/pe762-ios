//
//  informationTableViewCell.m
//  pe762-ios
//
//  Created by Future on 2018/4/23.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import "informationTableViewCell.h"

@implementation informationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = kBackgroundWhiteColor;
        
        UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(10 * kScreenWidthProportion, 13 * kScreenHeightProportion, kScreenWidth - 20 * kScreenWidthProportion, 179 * kScreenHeightProportion)];
        shadowView.backgroundColor = RGBA(220, 220, 220, 0.8);
        [shadowView setCornerRadius:4.0f];
        [self.contentView addSubview:shadowView];
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(1 * kScreenWidthProportion, 0, shadowView.width - 2 * kScreenWidthProportion, shadowView.height - 1 * kScreenWidthProportion)];
        baseView.backgroundColor = kWhiteColor;
        [baseView setCornerRadius:4.0f];
        [shadowView addSubview:baseView];
        
        // 主标题
        self.mainTitleLabel = [[UILabel alloc] init];
//        self.mainTitleLabel.backgroundColor = kWhiteColor;
        self.mainTitleLabel.textColor = kBlackLabelColor;
        self.mainTitleLabel.font = FONT(14 * kFontProportion);
        self.mainTitleLabel.textAlignment = NSTextAlignmentCenter;
        [baseView addSubview:self.mainTitleLabel];
        [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(9 * kScreenHeightProportion);
            make.size.mas_equalTo(CGSizeMake(baseView.width, 15 * kScreenHeightProportion));
        }];
        
        // 副标题
        self.subTitleLabel = [[UILabel alloc] init];
//        self.subTitleLabel.backgroundColor = kWhiteColor;
        self.subTitleLabel.textColor = kLightGreyColor;
        self.subTitleLabel.font = FONT(10 * kFontProportion);
        self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [baseView addSubview:self.subTitleLabel];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(self.mainTitleLabel.mas_bottom).offset(3 * kScreenHeightProportion);
            make.size.mas_equalTo(CGSizeMake(baseView.width, 11 * kScreenHeightProportion));
        }];
        
        // 图片
        self.contentImageView = [[UIImageView alloc] init];
        [baseView addSubview:self.contentImageView];
        [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(self.subTitleLabel.mas_bottom).offset(5 * kScreenHeightProportion);
            make.size.mas_equalTo(CGSizeMake(baseView.width, 97 * kScreenHeightProportion));
        }];
        
        float height = baseView.maxY - 135 * kScreenHeightProportion;
        
        // 来源与时间
        self.sourceAndTimeLabel = [[UILabel alloc] init];
//        self.sourceAndTimeLabel.backgroundColor = kWhiteColor;
        self.sourceAndTimeLabel.textColor = kLightGreyColor;
        self.sourceAndTimeLabel.font = FONT(9 * kFontProportion);
        self.sourceAndTimeLabel.textAlignment = NSTextAlignmentLeft;
        [baseView addSubview:self.sourceAndTimeLabel];
        [self.sourceAndTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            float minH = (height - 11 * kScreenHeightProportion)/2.0;
            make.left.mas_equalTo(18 * kScreenWidthProportion);
            make.top.mas_equalTo(self.contentImageView.mas_bottom).offset(minH);
            make.size.mas_equalTo(CGSizeMake(110 * kScreenWidthProportion, 11 * kScreenHeightProportion));
        }];
        
        // 头像
        self.headImageView = [[UIImageView alloc] init];
        [baseView addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentImageView.right).offset(-30 * kScreenWidthProportion);
            make.top.mas_equalTo(self.sourceAndTimeLabel.mas_top).offset(-8 * kScreenHeightProportion);
            make.size.mas_equalTo(CGSizeMake(22 * kScreenWidthProportion, 22 * kScreenWidthProportion));
            [self.headImageView setCornerRadius:11 * kScreenWidthProportion];
        }];
        
        // 点赞
        self.zanNumberLabel = [[UILabel alloc] init];
//        self.zanNumberLabel.backgroundColor = kRedColor;
        self.zanNumberLabel.textColor = kLightGreyColor;
        self.zanNumberLabel.font = FONT(9 * kFontProportion);
        self.zanNumberLabel.textAlignment = NSTextAlignmentLeft;
        [baseView addSubview:self.zanNumberLabel];
        [self.zanNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.headImageView.mas_left).offset(-5 * kScreenWidthProportion);
            make.top.mas_equalTo(self.sourceAndTimeLabel.mas_top);
            make.size.mas_equalTo(CGSizeMake(20 * kScreenWidthProportion, 11 * kScreenHeightProportion));
        }];
        
        // 赞图片
        UIImageView *zanImageView = [[UIImageView alloc] init];
        zanImageView.image = [UIImage imageNamed:@"Path 105"];
        [baseView addSubview:zanImageView];
        [zanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.zanNumberLabel.mas_left).offset(-2 * kScreenWidthProportion);
            make.top.mas_equalTo(self.sourceAndTimeLabel.mas_top);
            make.size.mas_equalTo(CGSizeMake(11 * kScreenWidthProportion, 11 * kScreenWidthProportion));
        }];
        
        // 消息
        self.messageNumberLabel = [[UILabel alloc] init];
//        self.messageNumberLabel.backgroundColor = kRedColor;
        self.messageNumberLabel.textColor = kLightGreyColor;
        self.messageNumberLabel.font = FONT(9 * kFontProportion);
        self.messageNumberLabel.textAlignment = NSTextAlignmentLeft;
        [baseView addSubview:self.messageNumberLabel];
        [self.messageNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(zanImageView.mas_left).offset(-2 * kScreenWidthProportion);
            make.top.mas_equalTo(self.sourceAndTimeLabel.mas_top);
            make.size.mas_equalTo(CGSizeMake(10 * kScreenWidthProportion, 11 * kScreenHeightProportion));
        }];
        
        // 消息图片
        UIImageView *meaassgeImageView = [[UIImageView alloc] init];
        meaassgeImageView.image = [UIImage imageNamed:@"Group 25"];
        [baseView addSubview:meaassgeImageView];
        [meaassgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.messageNumberLabel.mas_left).offset(-2 * kScreenWidthProportion);
            make.top.mas_equalTo(self.sourceAndTimeLabel.mas_top);
            make.size.mas_equalTo(CGSizeMake(9.5 * kScreenWidthProportion, 10 * kScreenWidthProportion));
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
