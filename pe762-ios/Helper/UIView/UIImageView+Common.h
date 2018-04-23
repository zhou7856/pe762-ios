//
//  UIImageView+Common.h
//  zhonghuaxun-chuanzhu-ios
//
//  Created by zmit on 16/3/17.
//  Copyright © 2016年 zmit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Common)

#pragma mark -- 获取类对象
+ (UIImageView *)imageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName;

@end
