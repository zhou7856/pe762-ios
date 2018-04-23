//
//  UIView+Common.m
//
//  Created by Surfin Zhou on 15/6/23.
//  Copyright (c) 2015年 ZMIT. All rights reserved.
//

#import "UIView+Common.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Common)


#pragma mark - Corner radius

-(void)roundCorners:(UIRectCorner)corners radius:(CGFloat)radius
{
    CGRect bounds = self.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
    
    CAShapeLayer*   frameLayer = [CAShapeLayer layer];
    frameLayer.frame = bounds;
    frameLayer.path = maskPath.CGPath;
//    frameLayer.strokeColor = [UIColor redColor].CGColor;
    frameLayer.fillColor = nil;
    
    [self.layer addSublayer:frameLayer];
}

-(void)roundTopCornersRadius:(CGFloat)radius
{
    [self roundCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) radius:radius];
}

-(void)roundBottomCornersRadius:(CGFloat)radius
{
    [self roundCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) radius:radius];
}

- (void)setCornerRadius:(CGFloat)size
{
    self.layer.cornerRadius = size;
    self.clipsToBounds = YES;
}

- (void)setCornerRadiusHalfHeight
{
    CGFloat height = self.frame.size.height;
    [self setCornerRadius:height/2];
}



#pragma mark - Border

- (void)setBorder:(CGFloat)width color:(UIColor *)color
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}



#pragma mark - shadow

- (void)setShadow:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity
{
    self.layer.shadowOffset = offset;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
}

-(void)setCAGradientLayerForView:(UIView *)view cornerRadius:(CGFloat)cornerRadius
{
    CAGradientLayer *gradientLayer;
    
    //初始化渐变层
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    gradientLayer.cornerRadius = cornerRadius;
    [view.layer addSublayer:gradientLayer];
    
    //设置渐变颜色方向
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设定颜色组
    gradientLayer.colors = @[(__bridge id)RGB(28, 166, 236).CGColor,
                             (__bridge id)RGB(21, 137, 228).CGColor];
    
    //设定颜色分割点
    gradientLayer.locations = @[@(0.5f) ,@(1.0f)];
}

#pragma mark - separator line

- (UIView *)generateSeparatorLine:(CGRect)rect WithBackgroundColor:(UIColor *)backgroundColor
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = backgroundColor;
    
    return view;
}

- (void)addSeparatorLineWithRect:(CGRect)rect withBackgroundColor:(UIColor *)backgroundColor
{
    UIView *view = [self generateSeparatorLine:rect WithBackgroundColor:backgroundColor];
    [self addSubview:view];
}

- (void)addSeparatorLine:(Direction)direction withBorderWidth:(CGFloat)borderWidth withBackgroundColor:(UIColor *)backgroundColor
{
    CGRect rect;
    if ( direction == DirectionTop ) {
        rect = CGRectMake(0, 0, self.frame.size.width, borderWidth);
    } else if ( direction == DirectionBottom ) {
        rect = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width, borderWidth);
    } else if ( direction == DirectionBottom ) {
        rect = CGRectMake(0, 0, borderWidth, self.frame.size.height);
    } else if ( direction == DirectionRight ) {
        rect = CGRectMake(0, self.frame.size.width - borderWidth, borderWidth, self.frame.size.height);
    } else {
        return;
    }
    
    UIView *view = [self generateSeparatorLine:rect WithBackgroundColor:backgroundColor];
    [self addSubview:view];
}


#pragma mark -- 获取类对象
+ (UIView *)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = backgroundColor;
    return view;
}

- (void)showHUDTextOnly:(NSString *)message
{
    if (message.length == 0 || message == nil || [message isKindOfClass:[NSNull class]]) {
        return;
    }
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.progressHUD = [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.margin = 10.f;
    // Configure for text only and offset down
    self.progressHUD.yOffset =  kScreenHeight/2 - 100.f;
    self.progressHUD.cornerRadius = 5.f;
    self.progressHUD.labelText = message;
    self.progressHUD.labelFont = [UIFont systemFontOfSize:13.0f];
    self.progressHUD.color = [UIColor colorWithRed:83/255.0f green:83/255.0f blue:83/255.0f alpha:1.0f];
    
    self.progressHUD.removeFromSuperViewOnHide = YES;
    [self.progressHUD hide:YES afterDelay:1.5f];
}


@end
