//
//  PayVipPopView.h
//  pe762-ios
//
//  Created by Future on 2018/5/10.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import <UIKit/UIKit.h>

// 1支付宝 2微信
typedef void (^PayVipPopBlock) (UIView *popView, NSInteger payType);

@interface PayVipPopView : UIView

@property (nonatomic, strong) PayVipPopBlock block;

@property (nonatomic, assign) NSInteger type;

//创建
- (void)createViewWithBlock:(PayVipPopBlock)block andMoney:(NSString *)money;

@end
