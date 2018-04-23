//
//  UILabel+Common.h
//
//  Created by Surfin Zhou on 15/8/5.
//  Copyright (c) 2015年 ZMIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Common)

- (CGSize)contentSizeForWidth:(CGFloat)width;
- (CGSize)contentSize;
- (BOOL)isTruncated;


/**
 *	@brief 设置label属性
 */
- (void)setAttributeWithText:(NSString *)text withFont:(UIFont *)font withTextColor:(UIColor *)textColor withBackgroudColor:(UIColor *)backgroundColor;

/**
 *	@brief  设置行间距
 */
- (void)setLineSpacing:(CGFloat)lineSpacing;


/**
 *	@brief 设置不同label中在不同区间的字体颜色
 */
- (void)rangeTextStringColor:(UIColor *)color range:(NSRange)range;

/**
 *	@brief 设置不同label中在不同区间的字体大小和颜色
 */
- (void)rangeTextStringFont:(UIFont *)font range:(NSRange)range color:(UIColor *)color;

/**
 *    @brief 设置不同label中在不同区间的字体大小
 */
- (void)rangeTextStringFont:(UIFont *)font range:(NSRange)range;

/**
 *	@brief 设置不同label中在不同区间的字体大小和颜色
 */
- (void)rangeTextAttributeWithColor:(UIColor *)color withFont:(UIFont *)font range:(NSRange)range;

#pragma mark 获取label文字的宽度
- (CGFloat )getTitleTextWidth:(NSString *)title font:(UIFont *)font;

#pragma mark - 获取label文字的高度
- (void)contentFitHeight:(NSString *)text font:(UIFont *)font;

#pragma mark - 文本左右对齐
- (NSAttributedString*)getText:(NSString*)text font:(UIFont *)font;

#pragma mark -- 获取label的字体大小
- (void)fontForLabel:(CGFloat)number;

//  @brief 根据宽度自适应
//- (void)setLabelSizeToFitWidth:(int)width;

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font;

#pragma mark -- 获取类对象
+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font;

#pragma mark - 设置label属性
- (void)setLabelWithTextColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment font:(CGFloat)font;

#pragma mark -- 获取label的字体大小，根据高度
- (void)fontForLabelWithHeight:(CGFloat)number;

#pragma mark -- 根据区间获取宽度
- (CGFloat)widthFromRange:(NSRange)range;
@end
