//
//  UIImage+Common.h
//
//  Created by Surfin Zhou on 15/6/30.
//  Copyright (c) 2015年 ZMIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Common)

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

+ (UIImage*)imageFromImage:(UIImage*)image inRect:(CGRect)rect transform:(CGAffineTransform)transform;

@end
