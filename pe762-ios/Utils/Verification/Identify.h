//
//  Identify.h
//  transport-vendor
//
//  Created by X on 15/8/25.
//  Copyright (c)2015年 ZMIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Identify : NSObject

//验证手机号码
+ (BOOL)validateMobile:(NSString *)mobileNum;

//银行卡
+ (BOOL)validateCardNumber:(NSString *)cardNumber;

//身份证
+ (BOOL)validateIdentityCard:(NSString *)identityCard;

//用户名
+ (BOOL)validateUserName:(NSString *)name;

//姓名
+ (BOOL)validateName:(NSString *)name;

//车牌号码
+ (BOOL)validateCarNo:(NSString*)carNo;

//密码
+ (BOOL)validatePassword:(NSString*)password;

//判断整形
+ (BOOL)validateInt:(NSString *)string;

// 判断为空
+ (BOOL)isBlankString:(NSString *)string;

//邮箱
+ (BOOL)validateEmail:(NSString *)email;

/*=======================================李永奎=============================================*/
// 验证手机号
+(BOOL)isTelphoneNumber:(NSString *)telNum;

// 验证密码
+ (BOOL)verifyPassword:(NSString *)password;

// 验证昵称、地址、公司名 (中文，英文，数字)
+ (BOOL)verifyChineseStyle:(NSString *)name;
//=======================================================
+ (BOOL)isverifyCode:(NSString *)string;


@end
