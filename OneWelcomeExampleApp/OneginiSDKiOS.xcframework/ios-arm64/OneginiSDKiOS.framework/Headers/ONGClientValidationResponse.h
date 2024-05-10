//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGClientConfig.h"

@class ONGAuthenticatorConfig;
@class ONGIdentityProviderConfig;

@interface ONGClientValidationResponse : NSObject

@property (nonatomic, copy) NSString *clientId;
@property (nonatomic) ONGClientConfig *clientConfig;

@property (nonatomic, copy) NSSet<NSString *> *profiles;
@property (nonatomic, copy) NSSet<ONGAuthenticatorConfig *> *customAuthenticators;
@property (nonatomic, copy) NSArray<ONGIdentityProviderConfig *> *identityProviders;

- (NSSet<ONGAuthenticatorConfig *> *)customAuthenticatorsForProfile:(NSString *)profile;

- (NSSet<ONGAuthenticatorConfig *> *)enabledCustomAuthenticators;

@end
