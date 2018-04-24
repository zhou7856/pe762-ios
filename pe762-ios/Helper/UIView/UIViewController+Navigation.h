//
//  UIViewController+Navigation.h
//  pe762-ios
//
//  Created by wsy on 2018/4/23.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Navigation)


/**
 创建导航基于文本

 @param title 标题
 */
- (void)createNavigationTitle:(NSString *)title;

/**
 创建导航基于标题和左边按钮
 
 @param title 标题
 @param leftBtn 左边按钮（触发点击）
 @param typeLabel 选中的状态文本
 */
- (void)createNavigationFeatureAndTitle:(NSString *)title withLeftBtn:(UIButton *)leftBtn andTypeTitle:(UILabel *)typeLabel;

/**
 创建导航基于文本和功能

 @param title 标题
 @param leftBtn 左边按钮（触发点击）
 @param rightBtn 右边按钮（触发点击）
 @param typeLabel 选中的状态文本
 */
- (void)createNavigationFeatureAndTitle:(NSString *)title withLeftBtn:(UIButton *)leftBtn andRightBtn:(UIButton *)rightBtn andTypeTitle:(UILabel *)typeLabel;




/**
 创建底部的返回页面
 */
- (void)createEndBackView;
@end
