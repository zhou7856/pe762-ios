//
//  NSObject+Common.m
//  pd384-ios
//
//  Created by zmit on 16/6/4.
//  Copyright © 2016年 zmit. All rights reserved.
//

#import "NSObject+Common.h"

@implementation NSObject (Common)

#pragma mark - NSArray或NSDictionary转成JSON各式
- (NSString *)ToJsonString {
    
    NSString *jsonString = @"{}";
    
    if ( [self isKindOfClass:[NSArray class]]
        || [self isKindOfClass:[NSMutableArray class]]
        || [self isKindOfClass:[NSDictionary class]]
        || [self isKindOfClass:[NSMutableDictionary class]]) {
    
        NSError *error;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
//                                                           options:(NSJSONWritingOptions)    (false ? NSJSONWritingPrettyPrinted : 0)
//                                                             error:&error];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                           options:0
                                                             error:&error];
        
        if (jsonData){
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
    }
    
    return jsonString;
    
}

#pragma mark - 判断字典的一个key值是否为nil
- (BOOL)dictionaryKeyNilJudge:(id)dicData{
    //判断是不是空对象
    if ([dicData isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if (dicData == nil) {
        return YES;
    }
    
    if ([dicData isKindOfClass:[NSString class]]) {
        if ([dicData isEqualToString:@""]) {
            return YES;
        }
        if ([dicData isEqualToString:@"(null)"]) {
            return YES;
        }
        if ([dicData isEqualToString:@"0.00"]) {
            return YES;
        }
    }
    
    if (dicData == NULL) {
        return YES;
    }
    
    if ([dicData isKindOfClass:[NSArray class]]) {
        NSArray *dicArray = [NSArray arrayWithArray:dicData];
        if (dicArray.count == 0) {
            return YES;
        }
    }
    return NO;
}
#pragma mark - 判断字典的一个key值是否为nil
- (BOOL)dictionaryKeyNil:(id)dicData{
    //判断是不是空对象
    if ([dicData isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if (dicData == nil) {
        return YES;
    }
    
    if ([dicData isKindOfClass:[NSString class]]) {
        if ([dicData isEqualToString:@""]) {
            return YES;
        }
        if ([dicData isEqualToString:@"(null)"]) {
            return YES;
        }
        if ([dicData isEqualToString:@"0.00"]) {
            return YES;
        }
    }
    
    if (dicData == NULL) {
        return YES;
    }
    
    return NO;
}


- (BOOL)strTimeComparison:(NSString *)strTimer1 andTimer2:(NSString *)strTimer2{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date1 = [formatter dateFromString:strTimer1];
    NSDate *date2 = [formatter dateFromString:strTimer2];
    
    NSDate *bigDate = [date1 laterDate:date2];
    NSString *bigTimerStr = [formatter stringFromDate:bigDate];
    if ([bigTimerStr isEqualToString:strTimer1]) {
        return YES;
    } else {
        return NO;
    }
    
}

#pragma mark - 判断有几位小数
-(int)numberOfDecimalPlaces:(double)num{
    num = [[NSNumber numberWithFloat:num * 100] intValue];
    int number = (int)num;
    if (number % 10 == 0) {
        if (number % 100 == 0) {
            return 0;
        } else {
            return 1;
        }
    } else {
        return 2;
    }
    return 0;
}

#pragma mark - 根据小数点位数返回String
- (NSString *)stringOfDecimalPoint:(double)number{
    NSString *numberStr;
    int pointNumber = [self numberOfDecimalPlaces:number];
    if (pointNumber == 0) {
        numberStr = [NSString stringWithFormat:@"%.0f",number];
    } else if (pointNumber == 1) {
        numberStr = [NSString stringWithFormat:@"%.1f",number];
    } else {
        numberStr = [NSString stringWithFormat:@"%.2f",number];
    }
    
    return numberStr;
}

#pragma mark - 简单字典参数过滤
- (NSDictionary *)simpleDictionaryFiltering:(NSDictionary *)dataDic {
    NSMutableDictionary *returnDic = [[NSMutableDictionary alloc] initWithDictionary:dataDic];
    for (NSString *keyStr in returnDic.allKeys) {
        if ([[returnDic objectForKey:keyStr] isKindOfClass:[NSNull class]]) {
            [returnDic setObject:@"" forKey:keyStr];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:returnDic];
}


#pragma mark -- 获得文本高度
- (CGFloat)getTitleHeight:(NSString *)title withWidth:(CGFloat)width andFont:(CGFloat)fontNumber {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 10)];
    titleLabel.font = FONT(fontNumber * kFontProportion);
    titleLabel.numberOfLines = 0;
    titleLabel.text = title;
    [titleLabel sizeToFit];
    return titleLabel.height;
}
@end
