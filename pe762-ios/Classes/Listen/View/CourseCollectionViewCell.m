//
//  CourseCollectionViewCell.m
//  pe762-ios
//
//  Created by Future on 2018/4/24.
//  Copyright © 2018年 zmit. All rights reserved.
//  课程cell - 九宫格

#import "CourseCollectionViewCell.h"

@implementation CourseCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self =  [super initWithFrame:frame];
    if (self) {
        // 课程图片
        self.iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.left.mas_equalTo(self.contentView).offset(1 * kScreenWidthProportion);
            make.size.mas_equalTo(CGSizeMake(92 * kScreenWidthProportion, 134 * kScreenHeightProportion));
        }];
        
        //课程名称
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = kBlackLabelColor;
        self.nameLabel.font = FONT(13 * kFontProportion);
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImageView).offset(-1 * kScreenWidthProportion);
            make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(8 * kScreenHeightProportion);
            make.size.mas_equalTo(CGSizeMake(self.contentView.width, 15 * kScreenHeightProportion));
        }];
        
        //课程老师
        self.teacherLabel = [[UILabel alloc] init];
        self.teacherLabel.textColor = kBlackLabelColor;
        self.teacherLabel.font = FONT(12 * kFontProportion);
        self.teacherLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.teacherLabel];
        [self.teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(1 * kScreenHeightProportion);
            make.size.mas_equalTo(CGSizeMake(self.contentView.width, 14 * kScreenHeightProportion));
        }];
    }
    
    return self;
}


@end
