//
//  XCallSystemCameraAlertView.h
//  shanhu
//
//  Created by X on 16/2/18.
//  Copyright © 2016年 ZMIT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XCallSystemCameraAlertViewDelegate <NSObject>
@optional
- (void)didFinishPickingImage:(UIImage *)image;

- (void)hideView;
@end
@interface XCallSystemCameraAlertView : UIView
/**
 *   移除本控件
 */
-(void)remove;
/**
 *  显示本控件
 */
-(void)show;

@property (nonatomic, weak)id<XCallSystemCameraAlertViewDelegate> delegete;
@end
