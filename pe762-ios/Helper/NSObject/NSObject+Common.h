//
//  NSObject+Common.h
//  pd384-ios
//
//  Created by zmit on 16/6/4.
//  Copyright © 2016年 zmit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Common)

#pragma mark - NSArray或NSDictionary转成JSON各式
- (NSString *)ToJsonString;

#pragma mark - 判断字典的一个key值是否为nil
- (BOOL)dictionaryKeyNilJudge:(id)dicData;

- (BOOL)dictionaryKeyNil:(id)dicData;

////判断两个时间Str大小 年月日 yes 1 大于 2
- (BOOL)strTimeComparison:(NSString *)strTimer1 andTimer2:(NSString *)strTimer2;

#pragma mark - 判断有几位小数
-(int)numberOfDecimalPlaces:(double)num;

#pragma mark - 根据小数点位数返回String
- (NSString *)stringOfDecimalPoint:(double)number;

#pragma mark - 简单字典参数过滤
- (NSDictionary *)simpleDictionaryFiltering:(NSDictionary *)dataDic;

#pragma mark -- 获得文本高度
- (CGFloat)getTitleHeight:(NSString *)title withWidth:(CGFloat)width andFont:(CGFloat)fontNumber;

@end
