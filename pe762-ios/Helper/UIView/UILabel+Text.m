//
//  UILabel+Text.m
//  pe637-user
//
//  Created by wsy on 2018/2/2.
//  Copyright © 2018年 zmit. All rights reserved.
//  全局控制后台返回的null

#import "UILabel+Text.h"

@implementation UILabel (Text)

+ (void)initialize
{
    // SEL:获取哪个方法
    Method setText =class_getInstanceMethod([UILabel class], @selector(setText:));
    Method setTextMySelf =class_getInstanceMethod([self class],@selector(setTextHooked:));
    
    IMP setTextImp =method_getImplementation(setText);
    class_addMethod([UILabel class], @selector(setTextOriginal:), setTextImp,method_getTypeEncoding(setText));
    
    //然后用我们自己的函数的实现，替换目标函数对应的实现
    IMP setTextMySelfImp =method_getImplementation(setTextMySelf);
    class_replaceMethod([UILabel class], @selector(setText:), setTextMySelfImp,method_getTypeEncoding(setText));
    
    
//     交互方法:runtime
//        method_exchangeImplementations(setTextMethod, xmg_setTextMethod);
//     调用imageNamed => xmg_imageNamedMethod
//     调用xmg_imageNamedMethod => imageNamed
}

- (void)setTextHooked:(id)textStr {
    NSString *titleStr;
//    if ()
    if (!textStr) {
        titleStr = @"";
    }
    
    if ([textStr isKindOfClass:[NSNull class]]) {
        titleStr = @"";
    }

    if ([textStr isKindOfClass:[NSString class]]) {
        //字条串是否包含有某字符串
        if ([textStr rangeOfString:@"<null>"].location == NSNotFound) {
//            NSLog(@"string 不存在 空");
            titleStr = [NSString stringWithFormat:@"%@",textStr];
        } else {
//            NSLog(@"string 包含 空");
            titleStr = @"";
        }
        
    }
    
//    titleStr = [NSString stringWithFormat:@"%@",textStr];
//    self.text = titleStr;
    [self performSelector:@selector(setTextOriginal:) withObject:titleStr];
//    NSLog(@"123");
}

@end
