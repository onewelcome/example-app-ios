// Copyright (c) 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGMappable.h"

@interface ONGAuthenticateCustomAuthenticatorResponse : NSObject<ONGMappable>

- (instancetype)initWithStatus:(NSNumber *)status
                          data:(NSString *)data
                   accessToken:(NSString *)accessToken;

@property (nonatomic) NSNumber *status;
@property (nonatomic) NSString *data;
@property (nonatomic) NSString *accessToken;

@end
