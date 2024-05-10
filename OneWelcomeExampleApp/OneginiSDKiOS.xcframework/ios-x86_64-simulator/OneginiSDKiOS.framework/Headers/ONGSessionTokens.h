//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

/**
 Access token data transfer object, part of the OAUTH data model
 */
@interface ONGSessionTokens : NSObject<NSCopying>

// serialized name "profile_id"
@property (copy, nonatomic) NSString *profileId;
// serialized name "token_type"
@property (copy, nonatomic) NSString *tokenType;
// serialized name "access_token"
@property (copy, nonatomic) NSString *accessToken;
// serialized name "id_token"
@property (copy, nonatomic) NSString *idToken;
// serialized name "refresh_token"
@property (nonatomic) NSString *refreshToken;
// serialized name "biometric"
@property (nonatomic) NSString *biometricRefreshToken;
// serialized name "expires_in"
@property (nonatomic) NSInteger expiresIn;
// serialized name "usage_count"
@property (nonatomic) NSInteger usageCount;
// serialized name "usage_limit"
@property (nonatomic) NSInteger usageLimit;

@end
