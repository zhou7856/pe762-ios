//
//  AFAppDotNetAPIClient.h
//  SujiaMart-iOS
//
//  Created by Surfin Zhou on 15/5/1.
//  Copyright (c) 2015年 zmit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
@interface AFAppDotNetAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end