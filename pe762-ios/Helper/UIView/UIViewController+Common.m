//
//  UIViewController+Common.m
//
//  Created by Surfin Zhou on 15/5/13.
//  Copyright (c) 2015年 zmit. All rights reserved.
//
//
//  自定义返回按钮
//  自定义标题颜色
//  集成了HUD（弹框提示）
//

#import "UIViewController+Common.h"
#import <objc/runtime.h>
#import "AppVariable.h"
#import "UIImage+Common.h"
#import "AFAppDotNetAPIClient.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppDelegate.h"
//#import "BannerH5ViewController.h"
#import "TabBarController.h"

/* This key is used to dynamically create an instance variable
 * within the MBProgressHUD category using objc_setAssociatedObject
 */
const char *progressHUDKey = "progressHUDKey";

@interface UIViewController () <MBProgressHUDDelegate>

@end

@implementation UIViewController (Common)

#pragma mark - Custom NavigationBar

- (void)customNavigationBarNoBackButton:(NSString *)title
{
    if (kScreenHeight == 812) {
        NSLog(@"this is iPhone X");
        self.navigationController.navigationBarHidden = YES;
        UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        statusView.backgroundColor = kDefaultColor;
        [self.view addSubview:statusView];
        
        UIView *view = [UIView viewWithFrame:CGRectMake(0, 44, kScreenWidth, 44) backgroundColor:kDefaultColor];
        [self.view addSubview:view];
        
        UILabel *label = [UILabel labelWithFrame:CGRectMake(0, -12, 200, 56) text:title textAlignment:NSTextAlignmentCenter font:FONT(17)];
        label.centerX = kScreenWidth/2.0;
        label.textColor = kBlackColor;
//        label.backgroundColor = [UIColor redColor];
        [view addSubview:label];
        
        UIView *lineView = [UIView viewWithFrame:CGRectMake(0, 43, kScreenWidth, 0.8) backgroundColor:RGBA(210, 210, 210, 0.4)];
        [view addSubview:lineView];
    } else {
        self.navigationController.navigationBarHidden = YES;
        UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        statusView.backgroundColor = kDefaultColor;
        [self.view addSubview:statusView];
        
        UIView *view = [UIView viewWithFrame:CGRectMake(0, 20, kScreenWidth, 44) backgroundColor:kDefaultColor];
        [self.view addSubview:view];
        
        UILabel *label = [UILabel labelWithFrame:CGRectMake(0, 0, 200, 44) text:title textAlignment:NSTextAlignmentCenter font:FONT(17)];
        label.centerX = kScreenWidth/2.0;
        label.textColor = kWhiteColor;
        [view addSubview:label];
        
        UIView *lineView = [UIView viewWithFrame:CGRectMake(0, 43, kScreenWidth, 0.8) backgroundColor:RGBA(210, 210, 210, 0.4)];
        [view addSubview:lineView];
    }
    
}

- (void)customNavigationBar:(NSString *)title
{
    if (kScreenHeight == 812) {
        NSLog(@"this is iPhone X");
        self.navigationController.navigationBarHidden = YES;
        UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        statusView.backgroundColor = kWhiteColor;
        [self.view addSubview:statusView];
        
        UIView *view = [UIView viewWithFrame:CGRectMake(0, 44, kScreenWidth, 44) backgroundColor:kWhiteColor];
        [self.view addSubview:view];
        
        UILabel *label = [UILabel labelWithFrame:CGRectMake(0, -12, 200, 56) text:title textAlignment:NSTextAlignmentCenter font:FONT(17)];
        label.centerX = kScreenWidth/2.0;
        label.textColor = kBlackLabelColor;
        //        label.backgroundColor = [UIColor redColor];
        [view addSubview:label];
        
        UIButton *backButton = [UIButton buttonWithFrame:CGRectMake(0, 0, 35, 44) type:UIButtonTypeCustom title:nil titleColor:nil imageName:@"top_icon_back_white" action:@selector(customBackToViewController) target:self];
//        backButton.backgroundColor = [UIColor redColor];
        backButton.centerY = label.centerY;
        [view addSubview:backButton];
        
        UIView *lineView = [UIView viewWithFrame:CGRectMake(0, 43, kScreenWidth, 0.8) backgroundColor:RGBA(210, 210, 210, 0.4)];
        [view addSubview:lineView];
    } else {
        self.navigationController.navigationBarHidden = YES;
        
        UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        statusView.backgroundColor = kWhiteColor;
        [self.view addSubview:statusView];
        
        UIView *view = [UIView viewWithFrame:CGRectMake(0, 20, kScreenWidth, 44) backgroundColor:kWhiteColor];
        [self.view addSubview:view];
        
        UILabel *label = [UILabel labelWithFrame:CGRectMake(0, 0, 200, 44) text:title textAlignment:NSTextAlignmentCenter font:FONT(17)];
        label.centerX = kScreenWidth/2.0;
        label.textColor = kBlackLabelColor;
        [view addSubview:label];
        
        UIButton *backButton = [UIButton buttonWithFrame:CGRectMake(0, 0, 35, 44) type:UIButtonTypeCustom title:nil titleColor:nil imageName:@"top_icon_back_white" action:@selector(customBackToViewController) target:self];
        [view addSubview:backButton];
        
        UIView *lineView = [UIView viewWithFrame:CGRectMake(0, 43, kScreenWidth, 0.8) backgroundColor:RGBA(210, 210, 210, 0.4)];
        [view addSubview:lineView];
    }
}

#pragma mark 返回按钮事件
- (void)customBackToViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)timeFire:(UIButton *)button
{
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:@"获取验证码" forState:UIControlStateNormal];
                button.enabled = YES;
                //                sender.titleLabel.font = FONT(12);
                if (kScreenHeight == 812) {
                    button.titleLabel.font = FONT(12 * kFontProportion);
                } else {
                    button.titleLabel.font = FONT(13 * kFontProportion);
                }
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [button setTitle:[NSString stringWithFormat:@"重新发送(%@)",strTime] forState:UIControlStateNormal];
                if (kScreenHeight == 812) {
                    button.titleLabel.font = FONT(12 * kFontProportion);
                } else {
                    button.titleLabel.font = FONT(12 * kFontProportion);
                }
                //                sender.titleLabel.font = FONT(14 * kFontProportion);
                //                [sender setFont:FONT(11)];
                [UIView commitAnimations];
                button.enabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)showTabBarView:(BOOL)show
{
    TabBarController *tabBarVC = (TabBarController *)self.tabBarController;
    [tabBarVC showTabBar:show];
}

#pragma mark - MBProgressHUD

- (MBProgressHUD *)progressHUD
{
    MBProgressHUD *hud = objc_getAssociatedObject(self, progressHUDKey);
    if(!hud)
    {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIView *hudSuperView = app.window;
        hud = [[MBProgressHUD alloc] initWithView:hudSuperView];
        hud.dimBackground = YES;
        hud.removeFromSuperViewOnHide = YES;
        [hudSuperView addSubview:hud];
        self.progressHUD = hud;
    }
    return hud;
}

- (void)setProgressHUD:(MBProgressHUD *)progressHUD
{
    objc_setAssociatedObject(self, progressHUDKey, progressHUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHUDTextOnly:(NSString *)message
{
    if (message.length == 0 || message == nil || [message isKindOfClass:[NSNull class]]) {
        return;
    }
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.progressHUD = [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.margin = 10.f;
    // Configure for text only and offset down
    self.progressHUD.yOffset =  kScreenHeight/2 - 100.f;
    self.progressHUD.cornerRadius = 5.f;
    self.progressHUD.labelText = message;
    self.progressHUD.labelFont = [UIFont systemFontOfSize:13.0f];
    self.progressHUD.color = [UIColor colorWithRed:83/255.0f green:83/255.0f blue:83/255.0f alpha:1.0f];
    self.progressHUD.label.numberOfLines = 0;
    self.progressHUD.removeFromSuperViewOnHide = YES;
    [self.progressHUD hide:YES afterDelay:2.f];
}

- (void)showHUDTextBig: (NSString *)message andFont:(CGFloat)font andHeight:(CGFloat)height
{
    if (message.length == 0 || message == nil || [message isKindOfClass:[NSNull class]]) {
        return;
    }
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    self.progressHUD = [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.margin = 10.f;
    // Configure for text only and offset down
    self.progressHUD.yOffset =  height;
    self.progressHUD.cornerRadius = 5.f;
    self.progressHUD.labelText = message;
    self.progressHUD.labelFont = [UIFont systemFontOfSize:font];
    self.progressHUD.color = [UIColor colorWithRed:83/255.0f green:83/255.0f blue:83/255.0f alpha:1.0f];
    //    self.progressHUD.height = [UILabel getHeightByWidth:kScreenWidth - 20 title:message font:[UIFont systemFontOfSize:font]];
    self.progressHUD.label.numberOfLines = 0;
    self.progressHUD.removeFromSuperViewOnHide = YES;
    [self.progressHUD hide:YES afterDelay:1];
}
- (void)showHUDSimple
{
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.progressHUD];
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    self.progressHUD.delegate = self;
    
    [self.progressHUD show:YES];
}

- (void)hideHUD
{
    if(self.progressHUD.taskInProgress) return;
    self.progressHUD.taskInProgress = NO;
    [self.progressHUD hide:YES];
    self.progressHUD = nil;
}


- (void)callPhoneNumber:(NSString *)phoneNumber
{
    UIWebView *webView = [UIWebView new];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]]]];
    [self.view addSubview:webView];
}
-(void)shouKeyboard
{
    [self.view endEditing:YES];
}

- (BOOL)isNoLogin
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"] == NO) {
        [self showTabBarView:NO];
        //        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
        return YES;
    }
    
    return NO;
}

#pragma mark - Request

- (NSURLSessionDataTask *)defaultRequestwithURL: (NSString *)URL withParameters: (NSDictionary *)parameters withMethod: (NSString *)method withBlock:(void (^)(NSDictionary *dict, NSError *error))block
{
    //默认打印传入的实参
#ifdef DEBUG
    NSLog(@"common method = %@", method);//get 或 post
    NSLog(@"common URL = %@", URL);//所请求的网址
    NSLog(@"common parameters = %@", parameters);//传入的参数
#endif
    
    //根据method字符串判断调用AFNetworking里的get方法还是post方法
    if ( [method isEqualToString:@"GET"] ) {//所用到的是AFNetworking3.1.0里的方法，其新加了progress进度block
        return [[AFAppDotNetAPIClient sharedClient] GET:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable JSON) {
#ifdef DEBUG
            NSLog(@"common get json = %@", JSON);//打印获取到的json
#endif
            
            NSDictionary *dict = JSON;//直接返回字典，方便使用
            
            if (block) {
                block(dict, nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (block) {
                //                block([NSDictionary dictionary], error);
                block (nil, error);
                
                //                ErrorViewController *errorVC = [[ErrorViewController alloc] init];
                //
                //                [self presentViewController:errorVC animated:YES completion:nil];
            }
            
            //从指针级判断error是否为空，如果不为空就打印error
            if (error) {
                NSLog(@"%@",error);
            }
        }];
    }
    
    //post相关代码
    return [[AFAppDotNetAPIClient sharedClient]POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable JSON) {
#ifdef DEBUG
        NSLog(@"common post json = %@", JSON);//打印获取到的json
#endif
        
        NSDictionary *dict = JSON;//直接返回字典，方便使用
        
        if (block) {
            block(dict, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (block) {
            //            block([NSDictionary dictionary], error);
            block (nil, error);
            
            //            ErrorViewController *errorVC = [[ErrorViewController alloc] init];
            //
            //            [self presentViewController:errorVC animated:YES completion:nil];
        }
        
        //从指针级判断error是否为空，如果不为空就打印error
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    
    //返回值暂时用不到，不需要创建变量接收；传进的self指针也没有用到所以这个方法可移植性很强
}

#pragma mark - 实现多图片上传
-(void)startMultiPartUploadTaskWithURL:(NSString *)url
                           imagesArray:(NSArray *)images
                     parameterOfimages:(NSString *)parameter
                        parametersDict:(NSDictionary *)parameters
                      compressionRatio:(float)ratio
                          succeedBlock:(void (^)(NSDictionary *dict))succeedBlock
                           failedBlock:(void (^)(NSError *error))failedBlock{
    if (images.count == 0) {
        NSLog(@"图片数组计数为零");
        return;
    }
    for (int i = 0; i < images.count; i++) {
        if (![images[i] isKindOfClass:[UIImage class]]) {
            NSLog(@"images中第%d个元素不是UIImage对象",i+1);
        }
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/plain", @"text/javascript", nil];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        int i = 0;
        //根据当前系统时间生成图片名称
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *dateString = [formatter stringFromDate:date];
        
        for (UIImage *image in images) {
            NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
            NSData *imageData;
            if (ratio > 0.0f && ratio < 1.0f) {
                imageData = UIImageJPEGRepresentation(image, ratio);
            }else{
                imageData = UIImageJPEGRepresentation(image, 1.0f);
            }
            [formData appendPartWithFileData:imageData name:parameter fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        succeedBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            failedBlock(error);
            
            NSLog(@"%@",error);
        }
    }];
}

#pragma mark - NSArray或NSDictionary转成JSON各式
- (NSString*)ObjectToJson:(id)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark  - 绘制虚线

/**
 
 ** lineView:       需要绘制成虚线的view
 
 ** lineLength:     虚线的宽度
 
 ** lineSpacing:    虚线的间距
 
 ** lineColor:      虚线的颜色
 
 **/

- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor

{
    
    BOOL horizontalJudge = NO;
    
    if (CGRectGetWidth(lineView.frame) > CGRectGetHeight(lineView.frame)) {
        
        horizontalJudge = YES;
        
    }
    
    
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    [shapeLayer setBounds:lineView.bounds];
    
    if (horizontalJudge == YES) {
        
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
        
    }else{
        
        [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame), CGRectGetHeight(lineView.frame) / 2)];
        
    }
    
    
    
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    
    
    
    //  设置虚线颜色为blackColor
    
    [shapeLayer setStrokeColor:lineColor.CGColor];
    
    
    
    //  设置虚线宽度
    
    if (horizontalJudge == YES) {
        
        [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
        
    }else{
        
        [shapeLayer setLineWidth:CGRectGetWidth(lineView.frame)];
        
    }
    
    
    
    [shapeLayer setLineJoin:kCALineJoinRound];
    
    
    
    //  设置线宽，线间距
    
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    
    
    
    //  设置路径
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 0, 0);
    
    
    
    if (horizontalJudge == YES) {
        
        //  横线
        
        CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
        
    }else{
        
        //  竖线
        
        CGPathAddLineToPoint(path, NULL, 0, CGRectGetHeight(lineView.frame));
        
    }
    
    
    
    [shapeLayer setPath:path];
    
    CGPathRelease(path);
    
    
    
    //  把绘制好的虚线添加上来
    
    [lineView.layer addSublayer:shapeLayer];
    
}

#pragma mark -uicolor转uiimage
- (UIImage *)createImageWithColor:(UIColor *)color

{
    
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
    
}

-(void)setCAGradientLayerForView:(UIView *)view cornerRadius:(CGFloat)cornerRadius
{
    //初始化渐变层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    gradientLayer.cornerRadius = cornerRadius;
    [view.layer addSublayer:gradientLayer];
    
    //设置渐变颜色方向
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设定颜色组
    gradientLayer.colors = @[(__bridge id)RGB(28, 166, 236).CGColor,
                             (__bridge id)RGB(21, 137, 228).CGColor];
    
    //设定颜色分割点
    gradientLayer.locations = @[@(0.5f) ,@(1.0f)];
}

//给一个静态页网址拼接一个随机数，防止浏览器缓存
- (NSString *)stitchingNumberForHtmlUrlString:(NSString *)urlStr {
    NSString *randomStr = @"";
    for (int i = 0; i < 5;i ++) {
        int value = arc4random() % 10;
        randomStr = [NSString stringWithFormat:@"%@%d",randomStr,value];
    }
    
    NSString *returnStr = [NSString stringWithFormat:@"%@%@&%@",urlStr,kVersions,randomStr];
    return returnStr;
}

#pragma mark - 通用方法，给一个URL添加token 和 platform
- (NSString *)stitchingTokenAndPlatformForURL:(NSString *)urlStr {
    NSString *returnURLStr;
    NSString *token = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
//    NSString *userType = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"user_type"]];
    //字条串是否包含有某字符串
    if ([urlStr rangeOfString:@"?"].location == NSNotFound) {
//        NSLog(@"string 不存在 ?");
        returnURLStr = [NSString stringWithFormat:@"%@%@%@",urlStr,kTokenVersion,token];
    } else {
//        NSLog(@"string 包含 ?");
        returnURLStr = [NSString stringWithFormat:@"%@%@%@",urlStr,kTokenVersions,token];
    }
//    NSLog(@"%@",returnURLStr);
    
    return returnURLStr;
}

- (NSString *)stitchingPlatformForURL:(NSString *)urlStr {
    NSString *returnURLStr;
//    NSString *token = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"token"]];
    //字条串是否包含有某字符串
    if ([urlStr rangeOfString:@"?"].location == NSNotFound) {
        //        NSLog(@"string 不存在 ?");
        returnURLStr = [NSString stringWithFormat:@"%@%@",urlStr,kTokenVersion];
    } else {
        //        NSLog(@"string 包含 ?");
        returnURLStr = [NSString stringWithFormat:@"%@%@",urlStr,kTokenVersions];
    }
    //    NSLog(@"%@",returnURLStr);
    
    return returnURLStr;
}



#pragma mark - 将null的字符串转化为@""
- (NSString *) stringForNull:(NSString *)change{
    
    NSString *temp = [NSString stringWithFormat:@"%@", change];
    
    if ([temp isEqualToString:@"<null>"] || [temp isEqualToString:@"(null)"] || [temp isEqualToString:@""]) {
        temp = @"";
    }
    
    return temp;
}

#pragma mark - 点击banner   go_url空不跳
- (void) initHitBannerData:(NSString *)bannerId{
//    NSString *url = [NSString stringWithFormat:@"%@",kHitBannerURL];
//    url = [self stitchingTokenAndPlatformForURL:url];
//    url = [NSString stringWithFormat:@"%@&banner_id=%@", url, bannerId];
//    
//    [self defaultRequestwithURL:url withParameters:nil withMethod:kGET withBlock:^(NSDictionary *dict, NSError *error) {
//        
//        //判断有无数据
//        if ([[dict allKeys] containsObject:@"errorCode"]) {
//            NSString *errorCode = [NSString stringWithFormat:@"%@",dict[@"errorCode"]];
//            if ([errorCode isEqualToString:@"-1"]){
//                //未登陆
//                [self showTabBarView:NO];
//                
//                LoginViewController *loginVC = [[LoginViewController alloc] init];
//                [self.navigationController pushViewController:loginVC animated:YES];
//                return;
//            }
//            
//            if ([errorCode isEqualToString:@"0"]) {
//                NSDictionary *dataDic = dict[@"data"];
//                NSString *goUrl = [self stringForNull:dataDic[@"go_url"]];
//                
//                if ([goUrl isEqualToString:@""]) {
//                    return;
//                } else {
//                    [self showTabBarView:NO];
//                    BannerH5ViewController *pushVC = [[BannerH5ViewController alloc] init];
//                    pushVC.urlStr = goUrl;
//                    [self.navigationController pushViewController:pushVC animated:YES];
//                }
//                
//            }
//        }
//    }];
}

#pragma mark - 判断网络状态
- (BOOL)isExistenceNetwork
{
    BOOL isExistenceNetwork;
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch([reachability currentReachabilityStatus]){
        case NotReachable:
            isExistenceNetwork = FALSE;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = TRUE;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = TRUE;
            break;
    }
    return isExistenceNetwork;
}

@end
