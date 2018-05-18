//
//  MajorSearchListViewController.h
//  pe762-ios
//
//  Created by Future on 2018/5/15.
//  Copyright © 2018年 zmit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MajorSearchListViewController : UIViewController

// 专业id course_classify_id
@property (nonatomic, copy) NSString *courseClassifyIdStr;
// 专业title
@property (nonatomic, copy) NSString *titleStr;
// course_id
@property (nonatomic, copy) NSString *courseIdStr;
// type
@property (nonatomic, copy) NSString *typeStr;
// 标题
@property (nonatomic, copy) NSString *viewTitleStr;

@end
