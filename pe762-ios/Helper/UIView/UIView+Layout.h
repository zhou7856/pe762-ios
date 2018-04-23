//
//  UIView+Layout.h
//
//  Created by Surfin Zhou on 15/8/5.
//  Copyright (c) 2015年 ZMIT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int, UIViewLayout) {
    UIViewLayoutAbove                   = 1,
    UIViewLayoutBelow                   = 1<<1,
    UIViewLayoutAlignBottom             = 1<<2,
    UIViewLayoutAlignTop                = 1<<3,
    UIViewLayoutAlignLeft               = 1<<4,
    UIViewLayoutAlignRight              = 1<<5,
    UIViewLayoutCenterVertical          = 1<<6,
    UIViewLayoutCenterHorizontal        = 1<<7,
    UIViewLayoutRightOf                 = 1<<8,
    UIViewLayoutLeftOf                  = 1<<9,
    
    // about super view
    UIViewLayoutAlignSuperviewBottom    = 1<<10,
    UIViewLayoutAlignSuperviewTop       = 1<<11,
    UIViewLayoutAlignSuperviewLeft      = 1<<12,
    UIViewLayoutAlignSuperviewRight     = 1<<13,
    UIViewLayoutCenterVerticalInSuperview   = 1<<14,
    UIViewLayoutCenterHorizontalInSuperview = 1<<15,
};

@interface UIView (Layout)

@property (nonatomic) CGFloat minX;
@property (nonatomic) CGFloat maxX;
@property (nonatomic) CGFloat minY;
@property (nonatomic) CGFloat maxY;

#pragma mark - Frame

/**
 *	@brief	获取/设置左上角横坐标
 *
 *	@return	坐标值
 */
@property (nonatomic, assign) CGFloat left;

/**
 *	@brief	获取/设置左上角纵坐标
 *
 *	@return	坐标值
 */
@property (nonatomic, assign) CGFloat top;

/**
 *	@brief	获取/设置视图距离父视图的右边距
 *
 *	@return	坐标值
 */
@property (nonatomic, assign) CGFloat right;

/**
 *	@brief	获取/设置视图距离父视图的底部边距
 *
 *	@return	坐标值
 */

@property (nonatomic, assign) CGFloat bottom;

/**
 *	@brief	获取/设置视图宽度
 *
 *	@return	宽度值（像素）
 */
@property (nonatomic, assign) CGFloat width;

/**
 *	@brief	获取/设置视图高度
 *
 *	@return	高度值（像素）
 */
@property (nonatomic, assign) CGFloat height;

/**
 *	@brief	获取/设置视图尺寸Size
 *
 *	@return	CGSize值
 */
@property (nonatomic, assign) CGSize size;

/**
 *	@brief	获取/设置视图坐标Position
 *
 *	@return	CGPoint值
 */
@property (nonatomic, assign) CGPoint position;

/**
 *	@brief	获取/设置视图坐标centerX
 *
 *	@return CGFloat值
 */
@property (nonatomic, assign) CGFloat centerX;

/**
 *	@brief	获取/设置视图坐标centerY
 *
 *	@return	CGFloat值
 */
@property (nonatomic, assign) CGFloat centerY;

// You must add to the superview and set the size first, then layout the view.
// Make sure the relative view and self get the same superview.
// Otherwise, there will be some error
- (void)layoutRelativeOptions:(UIViewLayout)options withView:(UIView *)view;
- (void)layoutRelativeOptions:(UIViewLayout)options withView:(UIView *)view padding:(UIEdgeInsets)padding;

- (void)layoutRelativeOptions:(UIViewLayout)options withRect:(CGRect)rect;
- (void)layoutRelativeOptions:(UIViewLayout)options withRect:(CGRect)rect padding:(UIEdgeInsets)padding;

@end