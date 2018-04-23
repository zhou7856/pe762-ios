//
//  UITextField+Common.m
//
//  Created by Surfin Zhou on 15/6/29.
//  Copyright (c) 2015年 ZMIT. All rights reserved.
//

#import "UITextField+Common.h"

@implementation UITextField (Extensions)

- (void)setPaddingView:(CGRect)rect
{
    UIView *paddingView = [[UIView alloc] initWithFrame:rect];
    self.leftView = paddingView;
    self.leftViewMode  = UITextFieldViewModeAlways;
}

- (void)setTextFieldCentenY:(CGFloat)centenY {
    NSLog(@"%f",kScreenHeight);
    if (kScreenHeight == 812){//iPhoneX
        self.centerY = centenY + 1 * kScreenHeightProportion;
        
    } else if (kScreenHeight == 736){//iPhone Plus
        self.centerY = centenY + 0.5 * kScreenHeightProportion;
        
    } else if (kScreenHeight == 667){//iPhone 6 7 8
        self.centerY = centenY + 1.3 * kScreenHeightProportion;
        
    } else{//iPhone 5 568
        self.centerY = centenY;
    }
}
@end
