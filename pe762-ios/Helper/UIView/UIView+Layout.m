//
//  UIView+Layout.m
//
//  Created by Surfin Zhou on 15/8/5.
//  Copyright (c) 2015年 ZMIT. All rights reserved.
//

#import "UIView+Layout.h"

@implementation UIView (Layout)

- (CGFloat)minX
{
    return CGRectGetMinX(self.frame);
}

- (void)setMinX:(CGFloat)minX
{
    CGRect frame = self.frame;
    frame.origin.x = minX;
    self.frame = frame;
}

- (CGFloat)maxX
{
    return CGRectGetMaxX(self.frame);
}

- (void)setMaxX:(CGFloat)maxX
{
    CGRect frame = self.frame;
    frame.origin.x = maxX - CGRectGetWidth(frame);
    self.frame = frame;
}

- (CGFloat)minY
{
    return CGRectGetMinY(self.frame);
}

- (void)setMinY:(CGFloat)minY
{
    CGRect frame = self.frame;
    frame.origin.y = minY;
    self.frame = frame;
}

- (CGFloat)maxY
{
    return CGRectGetMaxY(self.frame);
}

- (void)setMaxY:(CGFloat)maxY
{
    CGRect frame = self.frame;
    frame.origin.y = maxY - CGRectGetHeight(frame);
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frameRect = self.frame;
    frameRect.size.width = width;
    self.frame = frameRect;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frameRect = self.frame;
    frameRect.size.height = height;
    self.frame = frameRect;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect frameRect = self.frame;
    frameRect.origin.y = top;
    self.frame = frameRect;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    CGRect frameRect = self.frame;
    frameRect.origin.x = left;
    self.frame = frameRect;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frameRect = self.frame;
    frameRect.origin.x = self.superview.frame.size.width - self.frame.size.width - right;
    self.frame = frameRect;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frameRect = self.frame;
    frameRect.origin.y = self.superview.frame.size.height - self.frame.size.height - bottom;
    self.frame = frameRect;
}

- (CGPoint)position
{
    return self.frame.origin;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (void)setPosition:(CGPoint)position
{
    CGRect frame = {
        .origin = position,
        .size = self.frame.size
    };
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = {
        .origin = self.frame.origin,
        .size = size,
    };
    self.frame = frame;
}

- (void)layoutRelativeOptions:(UIViewLayout)options withView:(UIView *)view
{
    [self layoutRelativeOptions:options withView:view padding:UIEdgeInsetsZero];
}

- (void)layoutRelativeOptions:(UIViewLayout)options withView:(UIView *)view padding:(UIEdgeInsets)padding
{
    [self layoutRelativeOptions:options withRect:view.frame padding:padding];
}

- (void)layoutRelativeOptions:(UIViewLayout)options withRect:(CGRect)rect
{
    [self layoutRelativeOptions:options withRect:rect padding:UIEdgeInsetsZero];
}

- (void)layoutRelativeOptions:(UIViewLayout)options withRect:(CGRect)rect padding:(UIEdgeInsets)padding
{
    CGRect frame = self.frame;
    CGRect superFrame = self.superview.frame;
    
    CGFloat minX = NAN;
    CGFloat maxX = NAN;
    if (options & UIViewLayoutRightOf) {
        minX = CGRectGetMaxX(rect) + padding.left;
    }
    else if (options & UIViewLayoutAlignLeft) {
        minX = CGRectGetMinX(rect) + padding.left;
    }
    else if (options & UIViewLayoutAlignSuperviewLeft) {
        minX = 0 + padding.left;
    }
    
    if (options & UIViewLayoutLeftOf) {
        maxX = CGRectGetMinX(rect) - padding.right;
    }
    else if (options & UIViewLayoutAlignRight) {
        maxX = CGRectGetMaxX(rect) - padding.right;
    }
    else if (options & UIViewLayoutAlignSuperviewRight) {
        maxX = CGRectGetWidth(superFrame) - padding.right;
    }
    
    if (!isnan(minX) && !isnan(maxX)) {
        frame.size.width = maxX - minX;
        frame.origin.x = minX;
    }
    else if (!isnan(minX)) {
        frame.origin.x = minX;
    }
    else if (!isnan(maxX)) {
        frame.origin.x = maxX - CGRectGetWidth(frame);
    }
    
    CGFloat minY = NAN;
    CGFloat maxY = NAN;
    if (options & UIViewLayoutBelow) {
        minY = CGRectGetMaxY(rect) + padding.top;
    }
    else if (options & UIViewLayoutAlignTop) {
        minY = CGRectGetMinY(rect) + padding.top;
    }
    else if (options & UIViewLayoutAlignSuperviewTop) {
        minY = 0 + padding.top;
    }
    
    if (options & UIViewLayoutAbove) {
        maxY = CGRectGetMinY(rect) - padding.bottom;
    }
    else if (options & UIViewLayoutAlignBottom) {
        maxY = CGRectGetMaxY(rect) - padding.bottom;
    }
    else if (options & UIViewLayoutAlignSuperviewBottom) {
        maxY = CGRectGetHeight(superFrame) - padding.bottom;
        
    }
    
    if (!isnan(minY) && !isnan(maxY)) {
        frame.size.height = maxY - minY;
        frame.origin.y = minY;
    }
    else if (!isnan(minY)) {
        frame.origin.y = minY;
    }
    else if (!isnan(maxY)) {
        frame.origin.y = maxY - CGRectGetHeight(frame);
    }
    
    if (options & UIViewLayoutCenterHorizontal) {
        frame.origin.x = CGRectGetMinX(rect) + CGRectGetWidth(rect)/2 - CGRectGetWidth(frame)/2 + padding.left - padding.right;
    }
    else if (options & UIViewLayoutCenterHorizontalInSuperview) {
        frame.origin.x = 0 + CGRectGetWidth(superFrame)/2 - CGRectGetWidth(frame)/2 + padding.left - padding.right;
    }
    if (options & UIViewLayoutCenterVertical) {
        frame.origin.y = CGRectGetMinY(rect) + CGRectGetHeight(rect)/2 - CGRectGetHeight(frame)/2 + padding.top - padding.bottom;
    }
    else if (options & UIViewLayoutCenterVerticalInSuperview) {
        frame.origin.y = 0 + CGRectGetHeight(superFrame)/2 - CGRectGetHeight(frame)/2 + padding.top - padding.bottom;
    }
    
    self.frame = frame;
}

@end