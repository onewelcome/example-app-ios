//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGConfigModel.h"
#import "ONGSessionTokens.h"

typedef NS_OPTIONS(NSInteger, ONGSessionTokensType)
{
    ONGSessionTokensTypeAccessToken = 1 << 0,
    ONGSessionTokensTypeClientAccessToken = 1 << 1,
    ONGSessionTokensTypeImplicitAccessToken = 1 << 2,
};

/**
 This class provides access to session scope properties.
 */
@interface ONGOAuthSessionModel : NSObject

@property (nonatomic) ONGSessionTokens *sessionTokens;
@property (nonatomic) ONGSessionTokens *clientSessionTokens;
@property (nonatomic) ONGSessionTokens *implicitSessionTokens;
@property (nonatomic) ONGConfigModel *configModel;
@property (nonatomic) BOOL isStatelessUser;
@property (nonatomic) NSArray *additionalResourceUrls;
@property (nonatomic) NSArray *x509PEMcertificates;
@property (nonatomic) NSString *serverPublicKey;

- (void)clearSession:(ONGSessionTokensType)type;

/**
 Clear the encrypted refresh token from the key chain and reset
 the pin attempt count and current the session.
 
 @return true if the token is deleted
 */
- (bool)clearTokens;

- (NSString *)accessToken;

- (NSString *)idToken;

- (NSString *)clientAccessToken;

- (NSString *)implicitAccessToken;

- (NSString *)customUserAgentHeader;

- (void)setStatelessSession;
- (void)unsetStatelessSession;

@end
