//
//  Identify.m
//  transport-vendor
//
//  Created by X on 15/8/25.
//  Copyright (c) 2015年 ZMIT. All rights reserved.
//

#import "Identify.h"

@implementation Identify

+(BOOL)validateMobile:(NSString *)phone
{
    // 手机号以13， 15，17, 18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^[1][3-8]\\d{9}$";
    NSPredicate *objctTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [objctTest evaluateWithObject:phone];
    //    return [self validateObject:phone withRegex:phoneRegex];
    
//    //8-10更新
//    NSString *MOBILE = @"^1(3[0-9]|4[145678]|5[0-9]|6[6]|7[01345678|8[0-9]|9[89])\\d{8}$";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    return [regextestmobile evaluateWithObject:phone];
}

//判断银行号
-(NSString *)getDigitsOnly:(NSString*)s
{
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < s.length; i++)
    {
        c = [s characterAtIndex:i];
        if (isdigit(c))
        {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    return digitsOnly;
}
+(BOOL)validateCardNumber:(NSString *)cardNumber
{
    if ([cardNumber isEqual:@""]) {
        return 0;
    }else
    {
        NSString *digitsOnly = @"";
        char c;
        for (int i = 0; i < cardNumber.length; i++)
            
        {
            c = [cardNumber characterAtIndex:i];
            if (isdigit(c))
            {
                digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
            }
        }
        int sum = 0;
        int digit = 0;
        int addend = 0;
        BOOL timesTwo = false;
        for (long i = digitsOnly.length - 1; i >= 0; i--)
        {
            digit = [digitsOnly characterAtIndex:i] - '0';
            if (timesTwo)
            {
                addend = digit * 2;
                if (addend > 9) {
                    addend -= 9;
                }
            }
            else {
                addend = digit;
            }
            sum += addend;
            timesTwo = !timesTwo;
        }
        int modulus = sum % 10;
        return modulus == 0;
    }
}

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//用户名
+ (BOOL) validateUserName:(NSString *)name
{
    if (![name isEqualToString:@""]) {
        return 1;
    }
    return 0;
//    NSString *      regex = @"^[a-zA-Z][a-zA-Z0-9]{5,7}$";
//    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    
//    return [pred evaluateWithObject:name];
}

//验证姓名
+ (BOOL) validateName:(NSString *)name
{
    if (![name isEqualToString:@""]) {
        NSString *      regex = @"(^[\u4E00-\u9FA5]*$)";
        NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        return [pred evaluateWithObject:name];
    }
    return 0;
}

//车牌号码
+ (BOOL) validateCarNo:(NSString*)carNo
{
    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[A-Z]{1}[A-Z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}

//密码
+ (BOOL) validatePassword:(NSString*) password
{
//    NSString *regex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
//    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
//    NSLog(@"passwordTest is %@",passwordTest);
//    return [passwordTest evaluateWithObject:password];
    if ([password length]>=5&&[password length]<19) {
        return 1;
    }
    return 0;
}

// 整形判断
+ (BOOL) validateInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断字符串为空
+ (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
//    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
//        return YES;
//    }
    return NO;
}

//邮箱
+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*=======================================李永奎=============================================*/
// 验证手机号
+(BOOL)isTelphoneNumber:(NSString *)telNum{
    // 验证长度
    telNum = [telNum stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([telNum length] != 11) {
        return NO;
    }
    
    /**
     * 规则 -- 更新日期 2017-03-30
     * 手机号码: 13[0-9], 14[5,7,9], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     *
     * [数据卡]: 14号段以前为上网卡专属号段，如中国联通的是145，中国移动的是147,中国电信的是149等等。
     * [虚拟运营商]: 170[1700/1701/1702(电信)、1703/1705/1706(移动)、1704/1707/1708/1709(联通)]、171（联通）
     * [卫星通信]: 1349
     */
    
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147(数据卡),150,151,152,157,158,159,170[5],178,182,183,184,187,188
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(17[8])|(18[2-4,7-8]))\\d{8}|(170[5])\\d{7}$";
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,145(数据卡),155,156,170[4,7-9],171,175,176,185,186
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(17[156])|(18[5,6]))\\d{8}|(170[4,7-9])\\d{7}$";
    
    /**
     * 中国电信：China Telecom
     * 133,149(数据卡),153,170[0-2],173,177,180,181,189
     */
    NSString *CT_NUM = @"^((133)|(149)|(153)|(17[3,7])|(18[0,1,9]))\\d{8}|(170[0-2])\\d{7}$";
    
    NSPredicate *pred_CM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM_NUM];
    NSPredicate *pred_CU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU_NUM];
    NSPredicate *pred_CT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT_NUM];
    BOOL isMatch_CM = [pred_CM evaluateWithObject:telNum];
    BOOL isMatch_CU = [pred_CU evaluateWithObject:telNum];
    BOOL isMatch_CT = [pred_CT evaluateWithObject:telNum];
    if (isMatch_CM || isMatch_CT || isMatch_CU) {
        return YES;
    }
    
    return NO;
}

// 验证密码
+ (BOOL)verifyPassword:(NSString *)password{
    // 数字，字母，特殊符号
    // ^(?=.*[a-zA-Z0-9].*)(?=.*[a-zA-Z\\W].*)(?=.*[0-9\\W].*).{6,20}
    NSString *pattern = @"^[0-9_a-zA-Z~!@#$%^&*]{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

// 验证昵称(中文，英文，数字)
+ (BOOL)verifyChineseStyle:(NSString *)name{
    NSString *pattern = @"[a-zA-Z\\u4e00-\\u9fa5][a-zA-Z0-9\\u4e00-\\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:name];
    return isMatch;
}

+ (BOOL)isverifyCode:(NSString* )string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([string length] != 4) {
        NSLog(@"buzhenwue");
        return NO;
    }
    return NO;
    
}
@end

