//
//  ChangeInfoViewController.h
//  pe762-ios
//
//  Created by wsy on 2018/4/23.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeInfoViewController : UIViewController

//1 修改昵称 2修改邮箱 
@property (nonatomic, strong) NSString *typeStr;

@property (nonatomic,strong) NSString *userInfo;
@end
