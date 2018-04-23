//
//  UIImageView+Common.m
//  zhonghuaxun-chuanzhu-ios
//
//  Created by zmit on 16/3/17.
//  Copyright © 2016年 zmit. All rights reserved.
//

#import "UIImageView+Common.h"

@implementation UIImageView (Common)

#pragma mark -- 获取类对象
+ (UIImageView *)imageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}

@end
