//
//  TabBarController.h
//  od681-yonghu-ios
//
//  Created by wsy on 2018/3/26.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarController : UITabBarController

@property (nonatomic,strong) UIView *tabBarView;
@property (assign, nonatomic) NSUInteger mySelectIndex;

- (void)showTabBar:(BOOL)show;
- (void)setSelect:(NSInteger)selectIndex;

#pragma mark - 获取全部的省市区数据
- (void)getAllAreaAPI;

@end
