//
//  ProblemDetailViewController.h
//  pe762-ios
//
//  Created by Future on 2018/4/24.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProblemDetailViewController : UIViewController

//问题id
@property (nonatomic, copy) NSString *idStr;

//跳转的来源 type 1 消息列表 2 问题列表
@property (nonatomic, copy) NSString *type;

@end
