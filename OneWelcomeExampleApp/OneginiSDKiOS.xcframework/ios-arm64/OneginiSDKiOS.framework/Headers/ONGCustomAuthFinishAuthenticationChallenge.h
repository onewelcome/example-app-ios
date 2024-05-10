// Copyright (c) 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserProfile;
@class ONGAuthenticator;
@class ONGCustomAuthFinishAuthenticationChallenge;

NS_ASSUME_NONNULL_BEGIN

/**
 * Protocol describing SDK object waiting for response to authentication with Custom Authenticator.
 */
@protocol ONGCustomAuthFinishAuthenticationChallengeSender<NSObject>

/**
 * Method to provide the Custom Authenticator data to the SDK.
 *
 * @param data Custom Authenticator data
 * @param challenge challenge for which response is made
 */
- (void)respondWithData:(NSString *)data challenge:(ONGCustomAuthFinishAuthenticationChallenge *)challenge;

/**
 * Method providing pin fallback response to the SDK.
 *
 * @param challenge challenge for which response is made
 */
- (void)respondWithPinFallbackForChallenge:(ONGCustomAuthFinishAuthenticationChallenge *)challenge;

/**
 * Method to cancel challenge.
 *
 * @param challenge challenge for which response is made
 * @param underlyingError error specifying the reason behind the cancellation. It will ba added as a underlying error
 *        within the cancellation error returned in the authentication failure method.
 */
- (void)cancelChallenge:(ONGCustomAuthFinishAuthenticationChallenge *)challenge underlyingError:(nullable NSError *)underlyingError;

@end

/**
 * Represents authentication with custom authenticator challenge. It provides all information about the challenge and a sender awaiting for a response.
 */
DEPRECATED_MSG_ATTRIBUTE("Please use `CustomAuthFinishAuthenticationChallenge` protocol instead.")
@interface ONGCustomAuthFinishAuthenticationChallenge : NSObject

/**
 * User profile for which authenticate with custom authenticator challenge was sent.
 */
@property (nonatomic, readonly) ONGUserProfile *userProfile;

/**
 * Authenticator used for used for authentication.
 */
@property (nonatomic, readonly) ONGAuthenticator *authenticator;

/**
 * Custom authenticator data used to complete the authentication.
 */
@property (nonatomic, readonly, nullable) NSData *challengeData;

/**
 * Error describing cause of failure of previous challenge response.
 * Possible error domains: ONGAuthenticatorRegistrationErrorDomain, ONGGenericErrorDomain
 */
@property (nonatomic, readonly, nullable) NSError *error;

/**
 * Sender awaiting for response to the authenticate with custom authenticator challenge.
 */
@property (nonatomic, readonly) id<ONGCustomAuthFinishAuthenticationChallengeSender> sender;

@end

NS_ASSUME_NONNULL_END
