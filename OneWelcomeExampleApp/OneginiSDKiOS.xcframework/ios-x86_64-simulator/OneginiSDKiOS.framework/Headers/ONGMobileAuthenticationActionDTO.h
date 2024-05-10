// Copyright (c) 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGActionDTO.h"

@class ONGMobileAuthenticationType;
@class ONGUserProfile;
@class ONGAuthenticator;
@protocol ONGMobileAuthRequestDelegate;

@interface ONGMobileAuthenticationActionDTO : NSObject <ONGActionDTO>

@property (nonatomic, copy) NSString *transactionId;
@property (nonatomic) ONGUserProfile *userProfile;

@property (nonatomic, copy) NSDictionary *userInfo;
@property (nonatomic, copy) NSString *otpCode;

@property (nonatomic, copy) NSString *message;
@property (nonatomic) NSNumber *timestamp;
@property (nonatomic, copy) NSString *token;
@property (nonatomic) ONGMobileAuthenticationType *type;
@property (nonatomic) ONGAuthenticator *authenticator;
@property (nonatomic, copy) NSString *signingData;

@property (nonatomic) id challengeAwaitingResponse;

@property (nonatomic) BOOL confirmed;

@property (nonatomic) BOOL isPinFallback;

@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, copy) NSString *refreshTokenType;
@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic) id<ONGMobileAuthRequestDelegate> delegate;

- (void)populateWithRepresentation:(NSDictionary<NSString *, id> *)representation;

@end
