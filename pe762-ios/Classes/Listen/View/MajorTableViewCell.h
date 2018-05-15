//
//  MajorTableViewCell.h
//  pe762-ios
//
//  Created by Future on 2018/5/15.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MajorTableViewCell : UITableViewCell

// 标题
@property (nonatomic, strong) UILabel *titleLabel;

// 图标
@property (nonatomic, strong) UIImageView *moreImageView;

// 内容
@property (nonatomic, strong) UIView *typeView;

// 下划线
@property (nonatomic, strong) UIView *lineView;

@end
