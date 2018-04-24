//
//  ProblemTableViewCell.m
//  pe762-ios
//
//  Created by Future on 2018/4/23.
//  Copyright © 2018年 zmit. All rights reserved.
//  常见问题cell

#import "ProblemTableViewCell.h"

@implementation ProblemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        // 内容
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.textColor = kBlackLabelColor;
        self.contentLabel.font = FONT(11 * kFontProportion);
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10 * kScreenWidthProportion);
            make.top.mas_equalTo(16 * kScreenHeightProportion);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth - 30 * kScreenWidthProportion, 12 * kScreenHeightProportion));
        }];
        
        // 更多
        UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Path 185"]];
        [self.contentView addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentLabel.mas_right).offset(2 * kScreenWidthProportion);
            make.top.mas_equalTo(self.contentLabel.mas_top).offset(1.5 * kScreenHeightProportion);
            make.size.mas_equalTo(CGSizeMake(6 * kScreenWidthProportion, 9 * kScreenHeightProportion));
        }];
        
        // 下划线
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = kLineGrayColor;
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentLabel.mas_left);
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(9 * kScreenHeightProportion - 1);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth - 20 * kScreenWidthProportion, 1));
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
