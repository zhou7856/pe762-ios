//
//  CourseTableViewCell.h
//  pe762-ios
//
//  Created by Future on 2018/4/24.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseTableViewCell : UITableViewCell

// 标题
@property (nonatomic, strong) UILabel *titleLabel;
// 内容
@property (nonatomic, strong) UICollectionView *courseCollectionView;
// 上层页面
@property (nonatomic, strong) UIViewController *superVC;
// 数据
@property (nonatomic, strong) NSMutableArray *dataArray;

@end
