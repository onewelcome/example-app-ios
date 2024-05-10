// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserProfile;
@class ONGAuthenticator;
@class ONGPinChallenge;

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
#pragma ide diagnostic ignored "OCUnusedPropertyInspection"

NS_ASSUME_NONNULL_BEGIN

/**
 * Protocol describing SDK object waiting for response to authentication with PIN challenge.
 */
@protocol ONGPinChallengeSender<NSObject>

/**
 * Method to provide the PIN to the SDK.
 *
 * @param pin the PIN provided by the user
 * @param challenge pin challenge for which the response is made
 */
- (void)respondWithPin:(NSString *)pin challenge:(ONGPinChallenge *)challenge;

/**
 * Method to cancel challenge
 *
 * @param challenge pin challenge that needs to be cancelled
 */
- (void)cancelChallenge:(ONGPinChallenge *)challenge;

@end

/**
 * Represents authentication with PIN challenge. It provides all information about the challenge and a sender awaiting for a response.
 */
DEPRECATED_MSG_ATTRIBUTE("Please use `PinChallenge` protocol instead.")
@interface ONGPinChallenge : NSObject

/**
 * User profile for which authentication challenge was sent.
 */
@property (nonatomic, readonly) ONGUserProfile *userProfile;

/**
 * Authenticator object which authentication challenge was sent to.
 */
@property (nonatomic, readonly) ONGAuthenticator *authenticator;

/**
 * Maximum allowed pin attempts for the user.
 */
@property (nonatomic, readonly) NSUInteger maxFailureCount;

/**
 * Pin attempts used by the user on this device.
 */
@property (nonatomic, readonly) NSUInteger previousFailureCount;

/**
 * Available pin attempts left for the user on this device.
 */
@property (nonatomic, readonly) NSUInteger remainingFailureCount;

/**
 * Error describing cause of failure of previous challenge response.
 * Possible error domains: ONGAuthenticatorRegistrationErrorDomain, ONGGenericErrorDomain
 *
 * This error might include the ONGCustomInfo object under the ONGCustomAuthInfoKey. This object will be added to the userInfo
 * of the error in case of automatic PIN fallback from authentication using a custom authenticator.
 */
@property (nonatomic, readonly, nullable) NSError *error;

/**
 * Sender awaiting for response to the authenticate with PIN challenge.
 */
@property (nonatomic, readonly) id<ONGPinChallengeSender> sender;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
