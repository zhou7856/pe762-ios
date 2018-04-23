//
//  ConditionFilterPopView.h
//  pf435-company-ios
//
//  Created by wsy on 2017/11/20.
//  Copyright © 2017年 zmit. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^FilterPopBlock) (UIView *popView, NSString *chooseStr);
@interface ConditionFilterPopView : UIView<UITableViewDelegate,UITableViewDataSource>

//需要筛选的条件
@property (nonatomic, copy) NSArray *conditionArray;

@property (nonatomic, copy) FilterPopBlock block;


/**
 构造方法

 @param array 条件数组
 @param block 回调方法
 @return 对象
 */
+ (instancetype)initWithconDitionArray:(NSArray *)array block:(FilterPopBlock)block titleStr:(NSString *)titleStr;

@end
