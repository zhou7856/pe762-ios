//
//  NSDictionary+Sorting.m
//  pf435-company-ios
//
//  Created by wsy on 2018/4/16.
//  Copyright © 2018年 zmit. All rights reserved.
//  排序

#import "NSDictionary+Sorting.h"

@implementation NSDictionary (Sorting)

- (NSArray *)dicSortingWithKey {
    NSArray *sortedKeys = [self.allKeys sortedArrayWithOptions:NSSortStable usingComparator:
                           ^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                               int value1 = [obj1 intValue];
                               int value2 = [obj2 intValue];
                               if (value1 > value2) {
                                   return NSOrderedDescending;
                               }else if (value1 == value2){
                                   return NSOrderedSame;
                               }else{
                                   return NSOrderedAscending;
                               }
                           }];
    
    return sortedKeys;
}

@end
