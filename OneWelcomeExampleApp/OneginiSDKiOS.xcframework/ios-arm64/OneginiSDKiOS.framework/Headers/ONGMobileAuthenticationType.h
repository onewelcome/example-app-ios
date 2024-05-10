// Copyright (c) 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ONGMobileAuthenticationMethod) {
    ONGMobileAuthenticationMethodUndefined,
    ONGMobileAuthenticationMethodDefault,
    ONGMobileAuthenticationMethodPin,
    ONGMobileAuthenticationMethodBiometric,
    ONGMobileAuthenticationMethodOTP,
    ONGMobileAuthenticationMethodCustomAuthenticator
};

@interface ONGMobileAuthenticationType : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *timeToLive;
@property (nonatomic) ONGMobileAuthenticationMethod method;
@property (nonatomic, copy) NSString *authenticatorId;
@property (nonatomic) BOOL isTransactionSigning;

@end
