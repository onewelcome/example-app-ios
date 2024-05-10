// Copyright (c) 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserProfile;
@class ONGPGPKeyPair;

NS_ASSUME_NONNULL_BEGIN

@interface ONGMobileAuthModel : NSObject

- (BOOL)isProfileEnrolledForMobileAuth:(ONGUserProfile *)userProfile;

- (nullable ONGPGPKeyPair *)clientPGPKeyPairForProfile:(nullable ONGUserProfile *)profile;
- (nullable NSData *)serverPGPPublicKeyForProfile:(nullable ONGUserProfile *)userProfile;

- (BOOL)storeClientPGPKeyPair:(ONGPGPKeyPair *)clientKeyPair profile:(nullable ONGUserProfile *)userProfile;
- (BOOL)storeServerPGPPublicKey:(NSData *)publicKey profile:(nullable ONGUserProfile *)userProfile;

- (BOOL)deleteClientPGPKeyPairForProfile:(nullable ONGUserProfile *)userProfile;
- (BOOL)deleteServerPGPPublicKeyForProfile:(nullable ONGUserProfile *)userProfile;
- (BOOL)deletePGPKeysForProfile:(ONGUserProfile *)userProfile;

@end

NS_ASSUME_NONNULL_END
