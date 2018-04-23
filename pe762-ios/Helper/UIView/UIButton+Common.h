//
//  UIButton+common.h
//  kuaixiu-vendor
//
//  Created by Surfin Zhou on 15/8/20.
//  Copyright (c) 2015年 ZMIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Common)

/**
 *	@brief 封装Button属性
 */
- (void)setTitle:(NSString *)title withFont:(UIFont *)font withColor:(UIColor *)color withBackgroundColor:(UIColor *)backgroundColor padding:(UIEdgeInsets)padding withHorizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment forState:(UIControlState)controlState;

#pragma mark -- 获取类对象
+ (UIButton *)buttonWithFrame:(CGRect)frame type:(UIButtonType)type title:(NSString *)title titleColor:(UIColor *)titleColor imageName:(NSString *)imageName action:(SEL)sel target:(id)target;

- (void)buttonWithTitle:(NSString *)title Font:(CGFloat)font Color:(UIColor *)color BackgroundColor:(UIColor *)backgroundColor;

- (void)buttonWithTitle:(NSString *)title withFont:(CGFloat)font withColor:(UIColor *)color withBackgroundColor:(UIColor *)backgroundColor;




@end
