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
