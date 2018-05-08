//
//  informationTableViewCell.h
//  pe762-ios
//
//  Created by Future on 2018/4/23.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface informationTableViewCell : UITableViewCell

//主标题
@property (nonatomic, strong) UILabel *mainTitleLabel;
//副标题
@property (nonatomic, strong) UILabel *subTitleLabel;
//图片
@property (nonatomic, strong) UIImageView *contentImageView;
//内容来源与时间
@property (nonatomic, strong) UILabel *sourceAndTimeLabel;
//消息数量
@property (nonatomic, strong) UILabel *messageNumberLabel;
//点赞数量
@property (nonatomic, strong) UILabel *zanNumberLabel;
//头像
@property (nonatomic, strong) UIImageView *headImageView;
//作者
@property (nonatomic, strong) UILabel *authorLabel;
//点赞
@property (nonatomic, strong) UIButton *likeBtn;

@end
