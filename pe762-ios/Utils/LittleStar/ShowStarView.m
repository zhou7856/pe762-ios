//
//  ShowStarView.m
//  pd563-yonghu-ios
//
//  Created by wsy on 2017/6/3.
//  Copyright © 2017年 yayuanzi. All rights reserved.
//  展示星星

#import "ShowStarView.h"

@implementation ShowStarView

- (instancetype)initWithFrame:(CGRect)frame{
    ShowStarView *view = [super initWithFrame:frame];
    
    width = view.width / 5;
    self.isInteger = YES;
    for (int i = 0; i < 5; i++) {
        //右边显示灰色星星
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(width * i, 0, width, view.height)];
        rightView.clipsToBounds = YES;
        rightView.tag = 1100 + i;
        [view addSubview:rightView];
        
        CGFloat size = width / 8;
        UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(size, 0, size * 6, size * 6)];
        rightImageView.image = [UIImage imageNamed:@"evaluate_icon_star_gray"];
        [rightView addSubview:rightImageView];
        
        //左边显示红色星星
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(width * i, 0, width, view.height)];
        leftView.width = 0;
        leftView.clipsToBounds = YES;
        leftView.tag = 1000 + i;
        [view addSubview:leftView];
        
        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(size, 0, size * 6, size * 6)];
        
        UIImage *starImage = [UIImage imageNamed:@"evaluate_icon_star_red"];
        leftImageView.image = starImage;
        [leftView addSubview:leftImageView];
    }
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureEvent:)];
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureEvent:)];
    
    [self addGestureRecognizer:tapGesture];
    [self addGestureRecognizer:panGesture];
    
    return view;
}

// 点击事件
- (void)tapGestureEvent:(UITapGestureRecognizer *) tapGesture {
    CGPoint point = [tapGesture locationInView:self];
    
//    NSLog(@"点击位置x = %.2f,y = %.2f",point.x,point.y);
//    CGFloat clickX = point.x - self.minX;
    if (self.isInteger) {
        NSInteger number = point.x / width * 10;
        if (number % 10 >= 5) {
            number = number / 10 * 2 + 2;
        } else {
            if (number / 10 ==  0) {
                UIView *leftView = [self viewWithTag:1000];
                if (leftView.width > 0) {
                    number = number / 10 * 2;
                } else {
                    number = number / 10 * 2 + 1;
                }
            } else {
                number = number / 10 * 2 + 1;
            }
        }
        //    NSLog(@"一共几分：%ld",number);
        [self setStarNumbers:number];
    } else {
        CGFloat number = point.x / width * 2;
        [self setStarNumbers:number];
    }
}

// 滑动事件
- (void)panGestureEvent:(UIPanGestureRecognizer *) panGesture {
    CGPoint point = [panGesture locationInView:self];
    
//    NSLog(@"点击位置x = %.2f,y = %.2f",point.x,point.y);
    if (self.isInteger) {
        NSInteger number = point.x / width * 10;
        if (number % 10 >= 5) {
            number = number / 10 * 2 + 2;
        } else {
            if (number / 10 ==  0) {
                if (number % 10 <= 2) {
                    number = number / 10 * 2;
                } else {
                    number = number / 10 * 2 + 1;
                }
            } else {
                number = number / 10 * 2 + 1;
            }
        }
        [self setStarNumbers:number];
    } else {
        CGFloat number = point.x / width * 2;
        [self setStarNumbers:number];
    }
}

// 设置星星个数
- (void)setStarNumbers:(CGFloat)number {
    NSInteger oneStarNumber = number / 2;
    
    if (self.isInteger) {
        for (int i = 0; i < 5; i++) {
            if (i < oneStarNumber) {
                UIView *leftView = [self viewWithTag:1000 + i];
                leftView.width = width;
            } else {
                UIView *leftView = [self viewWithTag:1000 + i];
                leftView.width = 0;
            }
        }
        
        if (oneStarNumber * 2 != number) {
            UIView *leftView = [self viewWithTag:1000 + oneStarNumber];
            leftView.width = width / 2.f;
        }
        
        if (self.showStarBlock != nil) {
            self.showStarBlock(number);
        }
    } else {
        for (int i = 0; i < 5; i++) {
            if (i < oneStarNumber) {
                UIView *leftView = [self viewWithTag:1000 + i];
                leftView.width = width;
            } else {
                UIView *leftView = [self viewWithTag:1000 + i];
                leftView.width = 0;
            }
        }
        
        if (number > 0) {
            UIView *leftView = [self viewWithTag:1000 + oneStarNumber];
            NSLog(@"%f",width * (number / 2 - oneStarNumber));
            CGFloat size = width / 8;
            leftView.width = size + size * 6 * (number - oneStarNumber * 2) / 2;
 
        }

        if (self.showStarBlock != nil) {
            self.showStarBlock(number);
        }
    }
}

@end
