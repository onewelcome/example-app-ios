//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPinPolicy.h"

@interface ONGClientConfig : NSObject <NSCoding>

@property (nonatomic, readonly) ONGPinPolicy *pinPolicy;
@property (nonatomic, copy, readonly) NSArray<NSString *> *allowedFunctions;
@property (nonatomic, readonly) NSNumber *maxAllowedPinAttempts;

- (instancetype)initWithAllowedFunctions:(NSArray<NSString *> *)allowedFunctions
                   maxAllowedPinAttempts:(NSNumber *)maxAllowedPinAttempts
                               pinPolicy:(ONGPinPolicy *)pinPolicy;


@end
