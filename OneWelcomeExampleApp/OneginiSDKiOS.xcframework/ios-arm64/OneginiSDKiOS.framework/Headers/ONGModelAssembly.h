//  Copyright © 2017 Onegini. All rights reserved.

#import <Typhoon/Typhoon.h>

@class ONGChallengeAssembly;
@class ONGOAuthSessionModel;
@class ONGAuthenticatorProvider;
@class ONGMobileAuthenticationActionDTO;
@class ONGMobileAuthRequest;
@class ONGSessionTokens;
@class ONGUserProfile;
@class ONGClientCredentialsModel;
@class ONGClientConfigModel;
@class ONGClientIdModel;

@protocol ONGMobileAuthRequestDelegate;

@interface ONGModelAssembly : TyphoonAssembly

- (ONGOAuthSessionModel *)oAuthSessionModel;

- (ONGClientConfigModel *)clientConfigModel;

- (ONGClientCredentialsModel *)clientCredentialsModel;

- (ONGClientIdModel *)clientIdModel;

- (ONGAuthenticatorProvider *)authenticatorProvider;

- (ONGMobileAuthenticationActionDTO *)mobileAuthenticationActionWithDelegate:(id<ONGMobileAuthRequestDelegate>)delegate;

- (ONGSessionTokens *)sessionTokens;

@end
