//
//  NewestTableViewCell.h
//  pe762-ios
//
//  Created by Future on 2018/4/24.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewestTableViewCell : UITableViewCell

// 图片
@property (nonatomic, strong) UIImageView *iconImageView;
// 类型
@property (nonatomic, strong) UILabel *classLabel;
// 名称
@property (nonatomic, strong) UILabel *nameLabel;
// 详情
@property (nonatomic, strong) UILabel *detailLabel;
// 热度
@property (nonatomic, strong) UILabel *hotLabel;
// 日期
@property (nonatomic, strong) UILabel *dateLabel;

@end
