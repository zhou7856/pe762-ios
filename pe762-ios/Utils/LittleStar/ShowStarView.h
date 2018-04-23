//
//  ShowStarView.h
//  pd563-yonghu-ios
//
//  Created by wsy on 2017/6/3.
//  Copyright © 2017年 yayuanzi. All rights reserved.
//

#import <UIKit/UIKit.h>

//返回星星的个数
typedef void(^ShowStarBlock) (NSInteger starNumber);

@interface ShowStarView : UIView
{
    //星星页面的宽度
    CGFloat width;
}

@property (nonatomic, strong) ShowStarBlock showStarBlock;

//是否为整数分数 yes 是，no 不是 默认是
@property (nonatomic, assign) BOOL isInteger;

////星星的颜色
//@property (nonatomic, strong) UIColor *bgColor;

- (instancetype)initWithFrame:(CGRect)frame;

//设置几颗星星 (整数颗)
- (void)setStarNumbers:(CGFloat)number;



@end
