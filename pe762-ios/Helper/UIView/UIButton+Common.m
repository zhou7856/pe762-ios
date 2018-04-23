//
//  UIButton+common.m
//  kuaixiu-vendor
//
//  Created by Surfin Zhou on 15/8/20.
//  Copyright (c) 2015年 ZMIT. All rights reserved.
//

#import "UIButton+Common.h"

@implementation UIButton (common)

- (void)setTitle:(NSString *)title withFont:(UIFont *)font withColor:(UIColor *)color withBackgroundColor:(UIColor *)backgroundColor padding:(UIEdgeInsets)padding withHorizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment forState:(UIControlState)controlState
{
    // 设置字体大小
    self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    // 设置背景色
    self.backgroundColor = backgroundColor;
    
    // 设置水平方位
    self.contentHorizontalAlignment = horizontalAlignment;
    
    // 设置标题边距
    self.titleEdgeInsets = padding;
    
    // 设置标题
    [self setTitle:title forState:controlState];
    
    // 设置标题颜色
    [self setTitleColor:color forState:controlState];
}

#pragma mark -- 获取类对象
+ (UIButton *)buttonWithFrame:(CGRect)frame type:(UIButtonType)type title:(NSString *)title titleColor:(UIColor *)titleColor imageName:(NSString *)imageName action:(SEL)sel target:(id)target
{
    UIButton *button = [UIButton buttonWithType:type];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    if (imageName != nil) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)buttonWithTitle:(NSString *)title Font:(CGFloat)font Color:(UIColor *)color BackgroundColor:(UIColor *)backgroundColor{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateNormal];
    self.titleLabel.font = FONT(font * kFontProportion);
    self.backgroundColor = backgroundColor;
}

- (void)buttonWithTitle:(NSString *)title withFont:(CGFloat)font withColor:(UIColor *)color withBackgroundColor:(UIColor *)backgroundColor{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateNormal];
    self.titleLabel.font = FONT(font * kFontProportion);
    self.backgroundColor = backgroundColor;
}


@end
