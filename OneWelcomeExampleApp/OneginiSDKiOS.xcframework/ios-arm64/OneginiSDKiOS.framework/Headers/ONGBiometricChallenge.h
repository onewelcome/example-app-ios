//  Copyright © 2018 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserProfile;
@class ONGAuthenticator;
@class ONGBiometricChallenge;

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
#pragma ide diagnostic ignored "OCUnusedPropertyInspection"

NS_ASSUME_NONNULL_BEGIN

/**
 * Protocol describing SDK object waiting for response to authentication with biometric challenge.
 */
@protocol ONGBiometricChallengeSender<NSObject>
/**
 * Method providing confirmation response with prompt to the SDK.
 *
 * @param prompt Message to be displayed in the TouchID popup
 * @param challenge biometric challenge for which the response is made
 */
- (void)respondWithPrompt:(NSString *)prompt challenge:(ONGBiometricChallenge *)challenge;

/**
 * Method providing pin fallback response to the SDK.
 *
 * @param challenge biometric challenge for which the response is made
 */
- (void)respondWithPinFallbackForChallenge:(ONGBiometricChallenge *)challenge;

/**
 * Method to cancel challenge
 *
 * @param challenge biometric challenge that needs to be cancelled
 */
- (void)cancelChallenge:(ONGBiometricChallenge *)challenge;

@end

/**
 * Represents authentication with biometric challenge. It provides all information about the challenge and a sender awaiting for a response.
 */
DEPRECATED_MSG_ATTRIBUTE("Please use `BiometricChallenge` protocol instead.")
@interface ONGBiometricChallenge : NSObject

/**
 * User profile for which authenticate with biometric challenge was sent.
 */
@property (nonatomic, readonly) ONGUserProfile *userProfile;

/**
 * Authenticator object which authentication challenge was sent to.
 */
@property (nonatomic, readonly) ONGAuthenticator *authenticator;

/**
 * Error describing cause of failure of previous challenge response.
 * Domain of an error: ONGGenericErrorDomain
 *
 * IMPORTANT: Currently not in use.
 */
@property (nonatomic, readonly, nullable) NSError *error;

/**
 * Sender awaiting for response to the authentication with biometric challenge.
 */
@property (nonatomic, readonly) id<ONGBiometricChallengeSender> sender;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
