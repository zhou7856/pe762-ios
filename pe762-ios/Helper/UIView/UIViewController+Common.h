//
//  UIViewController+Common.h
//
//  Created by Surfin Zhou on 15/5/13.
//  Copyright (c) 2015年 zmit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "Reachability.h" //网络判断

@interface UIViewController (Common)

@property (nonatomic, retain) MBProgressHUD *progressHUD;


#pragma mark - Naviagtion

- (void)customNavigationBarNoBackButton:(NSString *)title;
- (void)customNavigationBar;
- (void)customNavigationBar:(NSString *)title;

#pragma mark - MBProgressHUD

- (void)showHUDTextOnly: (NSString *)message;

- (void)showHUDSimple;

- (void)hideHUD;

- (void)shouKeyboard;

//- (void)showChatViewControllerWithTargetId:(NSString *)userID title:(NSString *)title;

#pragma mark -- 缓用按钮
- (void)timeFire:(UIButton *)button;
- (void)showTabBarView:(BOOL)show;

#pragma mark - Request Common

- (NSURLSessionDataTask *)defaultRequestwithURL: (NSString *)URL withParameters: (NSDictionary *)parameters withMethod: (NSString *)method withBlock:(void (^)(NSDictionary *dict, NSError *error))block;

#pragma mark - 实现多图片上传
-(void)startMultiPartUploadTaskWithURL:(NSString *)url
                           imagesArray:(NSArray *)images
                     parameterOfimages:(NSString *)parameter
                        parametersDict:(NSDictionary *)parameters
                      compressionRatio:(float)ratio
                          succeedBlock:(void (^)(NSDictionary *dict))succeedBlock
                           failedBlock:(void (^)(NSError *))failedBlock;

#pragma mark - NSArray或NSDictionary转成JSON各式
- (NSString*)ObjectToJson:(id)dic;

//#pragma mark - 角标设置
//-(void)cornerNumber;
#pragma mark - 绘制虚线
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

#pragma mark -uicolor转uiimage
- (UIImage *)createImageWithColor:(UIColor *)color;

//给View设置渐变色
-(void)setCAGradientLayerForView:(UIView *)view cornerRadius:(CGFloat)cornerRadius;

//给一个静态页网址拼接一个随机数，防止浏览器缓存 并拼接上平台版本号
- (NSString *)stitchingNumberForHtmlUrlString:(NSString *)urlStr;

#pragma mark - 通用方法，给一个URL添加token 和 platform
- (NSString *)stitchingTokenAndPlatformForURL:(NSString *)urlStr;

#pragma mark - 通用方法，给一个URL添加platform
- (NSString *)stitchingPlatformForURL:(NSString *)urlStr ;

#pragma mark - 将null的字符串转化为@""
- (NSString *) stringForNull:(NSString *)change;

#pragma mark - 点击banner   go_url空不跳
- (void) initHitBannerData:(NSString *)bannerId;

#pragma mark - 判断网络状态
- (BOOL)isExistenceNetwork;

@end
