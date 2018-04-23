//
//  UIView+Common.h
//
//  Created by Surfin Zhou on 15/6/23.
//  Copyright (c) 2015年 ZMIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface UIView (Common)

/**
 *	@brief	方向结构体
 *
 */
typedef NS_ENUM(NSInteger, Direction) {
    DirectionLeft,
    DirectionRight,
    DirectionBottom,
    DirectionTop
};

@property (nonatomic, retain) MBProgressHUD *progressHUD;

#pragma mark - Corner radius

/**
 *	@brief 设置不同方位的圆角
 */
- (void)roundCorners:(UIRectCorner)corners radius:(CGFloat)radius;

/**
 *	@brief 设置上边（左上和右上）方位的圆角
 *
 */
- (void)roundTopCornersRadius:(CGFloat)radius;

/**
 *	@brief 设置下边（左下和右下）方位的圆角
 */
- (void)roundBottomCornersRadius:(CGFloat)radius;

/**
 *	@brief 设置4个拐角的圆角
 */
- (void)setCornerRadius:(CGFloat)size;

/**
 *	@brief 设置圆角 默认宽度为UIView高度的一半
 */
- (void)setCornerRadiusHalfHeight;




#pragma mark - Border

/**
 *	@brief 设置边框
 */
- (void)setBorder:(CGFloat)width color:(UIColor *)color;




#pragma mark - Shadow

/**
 *	@brief 设置设置阴影
 */
- (void)setShadow:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity;

//给View设置渐变色
-(void)setCAGradientLayerForView:(UIView *)view cornerRadius:(CGFloat)cornerRadius;

#pragma mark - Add line

- (UIView *)generateSeparatorLine:(CGRect)rect WithBackgroundColor:(UIColor *)backgroundColor;

- (void)addSeparatorLineWithRect:(CGRect)rect withBackgroundColor:(UIColor *)backgroundColor;

- (void)addSeparatorLine:(Direction)direction withBorderWidth:(CGFloat)borderWidth withBackgroundColor:(UIColor *)backgroundColor;

#pragma mark -- 获取类对象
+ (UIView *)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor;

- (void)showHUDTextOnly: (NSString *)message;
@end
