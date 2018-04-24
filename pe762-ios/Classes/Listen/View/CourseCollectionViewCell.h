//
//  CourseCollectionViewCell.h
//  pe762-ios
//
//  Created by Future on 2018/4/24.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseCollectionViewCell : UICollectionViewCell

//课程图片
@property (nonatomic, strong) UIImageView *iconImageView;
//课程名称
@property (nonatomic, strong) UILabel *nameLabel;
//课程老师
@property (nonatomic, strong) UILabel *teacherLabel;

@end
