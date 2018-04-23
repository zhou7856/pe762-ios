//
//  UIColor+Common.h
//
//  Created by Surfin Zhou on 15/8/8.
//  Copyright (c) 2015年 ZMIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Common)

/**
 *	@brief	封装16进制
 *
 *  @return UIColor对象
 */
+ (UIColor *)colorWithRGBHex:(UInt32)hex;

/**
 *	@brief	封装16进制和透明度
 *
 *  @return UIColor对象
 */
+ (UIColor *)colorWithRGBHex:(UInt32)hex alpha:(CGFloat)alpha;

/**
 *	@brief	封装RGB
 *
 *  @return UIColor对象
 */
+ (UIColor *)colorWithRGBRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

/**
 *	@brief	封装RGBA
 *
 *  @return UIColor对象
 */
+ (UIColor *)colorWithRGBARed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;



@end
