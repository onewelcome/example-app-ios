//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGDefines.h"

@class ONGAuthenticator;
@class ONGAuthenticatorConfig;

NS_ASSUME_NONNULL_BEGIN

ONG_EXTERN NSString *const ONGOAuthServiceKey;
ONG_EXTERN NSString *const ONGOAuthClientSecret;
ONG_EXTERN NSString *const ONGOAuthClientSecretEncryption;
ONG_EXTERN NSString *const ONGOAuthRefreshToken;
ONG_EXTERN NSString *const ONGOAuthDefaultRefreshToken;
ONG_EXTERN NSString *const ONGOAuthFingerprintRefreshToken;
ONG_EXTERN NSString *const ONGPGPClientKeyPair;
ONG_EXTERN NSString *const ONGPGPServerPublicKey;
ONG_EXTERN NSString *const ONGPayloadEncryptionEnabled;
ONG_EXTERN NSString *const ONGUUID;
ONG_EXTERN NSString *const ONGMaxAllowedPinAttempts;
ONG_EXTERN NSString *const ONGUsedPinAttempts;
ONG_EXTERN NSString *const ONGPinLength;
ONG_EXTERN NSString *const ONGSDKDataVersion;
ONG_EXTERN NSString *const ONGPreviouslyInstalledSDKDataVersion;
ONG_EXTERN NSString *const ONGPreferredAuthenticator;
ONG_EXTERN NSString *const ONGPushMobileAuthEnrolled;
ONG_EXTERN NSString *const ONGErrorDomainKeyPairGeneration;

typedef NS_ENUM(NSInteger, ONGKeychainManagerErrorCode)
{
    ONGKeyPairGenerationErrorKeyPairAlreadyExists
};

@interface ONGKeychainManager : NSObject

#pragma mark - default refresh token

+ (BOOL)storeRefreshToken:(NSString *)refreshToken pin:(NSString *)pin profile:(nullable NSString *)profile error:(NSError *__autoreleasing *)error;
+ (nullable NSString *)fetchRefreshTokenWithPin:(NSString *)pin profile:(nullable NSString *)profile error:(NSError * _Nullable *)error;
+ (BOOL)deleteRefreshTokenForProfile:(nullable NSString *)profile;
+ (BOOL)isRefreshTokenStoredForProfile:(nullable NSString *)profile;

#pragma mark - biometric refresh token

+ (BOOL)storeBiometricRefreshToken:(NSString *)refreshToken profile:(nullable NSString *)profile error:(NSError **)error;
+ (NSString *)fetchBiometricRefreshTokenForProfile:(nullable NSString *)profile prompt:(NSString *)prompt error:(NSError **)error;
+ (BOOL)deleteBiometricRefreshTokenForProfile:(nullable NSString *)profile;
+ (BOOL)isBiometricRefreshTokenStoredForProfile:(NSString *)profile;

#pragma mark - client configuration

+ (void)storeUsedPinAttempts:(NSUInteger)usedPinAttempts profile:(NSString *)profileId;
+ (NSUInteger)fetchUsedPinAttemptsForProfile:(NSString *)profileId;
+ (void)deleteUsedPinAttemptsForProfile:(NSString *)profileId;

#pragma mark - uuid

+ (nullable NSString *)getUUID:(NSError **)error;
+ (void)deleteUUID;

#pragma mark - payload encryption

+ (BOOL)payloadEncryptionEnabled;
+ (void)setPayloadEncryptionEnabled:(BOOL)payloadEncrytionEnabled;
+ (void)deletePayloadEncryptionStatusFlag;

#pragma mark - SDK data version

+ (void)storeSDKDataVersion:(NSString *)dataVersion;
+ (nullable NSString *)fetchSDKDataVersion;
+ (void)deleteSDKDataVersion;

#pragma mark - Preferred authenticator

+ (BOOL)storePreferredAuthenticator:(ONGAuthenticator *)authenticator profile:(NSString *)profileId;
+ (nullable ONGAuthenticator *)preferredAuthenticatorForProfileId:(NSString *)profileId;
+ (BOOL)deletePreferredAuthenticatorForProfileId:(NSString *)profileId;

#pragma mark - key pair

+ (BOOL)generateKeyPairWithError:(NSError **)error;
+ (nullable SecKeyRef)privateKeyWithError:(NSError **)error CF_RETURNS_NOT_RETAINED;
+ (SecKeyRef)publicKeyFromPrivateKey:(SecKeyRef)privateKey CF_RETURNS_RETAINED;
+ (BOOL)deleteKeyPairWithError:(NSError **)error;

+ (nullable NSString *)appId;

@end

NS_ASSUME_NONNULL_END
