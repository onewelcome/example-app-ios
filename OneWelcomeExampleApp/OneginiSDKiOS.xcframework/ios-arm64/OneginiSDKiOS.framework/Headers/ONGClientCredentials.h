// Copyright (c) 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ONGClientCredentials : NSObject <NSCopying>

@property (copy, nonatomic) NSString *clientSecret;
@property (copy, nonatomic) NSString *clientId;

- (instancetype)initWithClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret;

@end

NS_ASSUME_NONNULL_END
