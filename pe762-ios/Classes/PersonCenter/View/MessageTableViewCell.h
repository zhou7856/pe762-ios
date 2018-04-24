//
//  MessageTableViewCell.h
//  pe762-ios
//
//  Created by Future on 2018/4/24.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

// 头像
@property (nonatomic, strong) UIImageView *headImageView;
// 红点
@property (nonatomic, strong) UILabel *redlabel;
// 来源
@property (nonatomic, strong) UILabel *sourceLabel;
// 日期
@property (nonatomic, strong) UILabel *dateLabel;
// 主标题
@property (nonatomic, strong) UILabel *mainTitleLabel;
// 副标题
@property (nonatomic, strong) UILabel *subtitleLabel;

@end