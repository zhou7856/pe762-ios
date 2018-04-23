//
//  NSNull+JSON.m
//  SujiaMart-iOS
//
//  Created by Surfin Zhou on 15/5/8.
//  Copyright (c) 2015年 zmit. All rights reserved.
//

#import "NSNull+JSON.h"

@implementation NSNull (JSON)

- (NSUInteger)length
{
    return 0;
}

//- (NSInteger)integerValue
//{
//    return 0;
//}

- (float)floatValue
{
    return 0;
}

- (NSString *)stringValue
{
    return @"";
}

- (id)objectForKey:(id)key
{
    return nil;
}

- (BOOL)boolValue {
    return NO;
}

- (BOOL)isEqualToString:(NSString *)aString
{
    return NO;
}

//- (NSString *)description {
//    return @"0";
//}

- (NSArray *)componentsSeparatedByString:(NSString *)separator {
    return @[];
}

- (NSRange)rangeOfCharacterFromSet:(NSCharacterSet *)aSet{
    NSRange nullRange = {NSNotFound, 0};
    return nullRange;
}

@end
