//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@interface ONGAuthenticationHeaderBuilder : NSObject

+ (NSString *)buildBasic:(NSString *)username password:(NSString *)password;

+ (NSString *)buildBearer:(NSString *)token;

@end
