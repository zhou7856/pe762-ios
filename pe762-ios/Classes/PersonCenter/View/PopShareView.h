//
//  PopShareView.h
//  pe762-ios
//
//  Created by Future on 2018/5/10.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import <UIKit/UIKit.h>

//1 微博 2微信 3 QQ 4 朋友圈
typedef void (^PopShareBlock) (UIView *popView, NSString *typeID);
@interface PopShareView : UIView

@property (nonatomic, strong) PopShareBlock block;

//创建
- (void)createViewWithBlock:(PopShareBlock) block;

@end
