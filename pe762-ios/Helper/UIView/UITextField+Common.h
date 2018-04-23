//
//  UITextField+Common.h
//
//  Created by Surfin Zhou on 15/6/29.
//  Copyright (c) 2015年 ZMIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extensions)

- (void)setPaddingView:(CGRect)rect;

// 根据屏幕高度设置TextFieldCentenY
- (void)setTextFieldCentenY:(CGFloat)centenY;
@end
