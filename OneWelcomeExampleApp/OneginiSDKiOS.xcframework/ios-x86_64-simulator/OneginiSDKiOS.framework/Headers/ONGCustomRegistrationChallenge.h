//  Copyright © 2018 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserProfile;
@class ONGIdentityProvider;
@class ONGCustomRegistrationChallenge;
@class ONGCustomInfo;

NS_ASSUME_NONNULL_BEGIN

/**
 * Protocol describing SDK object waiting for response to custom registration challenge.
 */

@protocol ONGCustomRegistrationChallengeSender<NSObject>

/**
 * Method providing Custom registration data to the SDK.
 *
 * @param data data provided by the user
 * @param challenge registration request challenge for which the response is made
 */
- (void)respondWithData:(nullable NSString *)data challenge:(ONGCustomRegistrationChallenge *)challenge;

/// Method to cancel challenge
/// @param challenge  registration request challenge that needs to be cancelled
/// @param underlyingError optional error description
- (void)cancelChallenge:(ONGCustomRegistrationChallenge *)challenge underlyingError:(NSError  * _Nullable)underlyingError;

@end

/**
 * Represents custom registration challenge. It provides all information about the challenge and a sender awaiting for a response.
 */
DEPRECATED_MSG_ATTRIBUTE("Please use `CustomRegistrationChallenge` protocol instead.")
@interface ONGCustomRegistrationChallenge : NSObject

/**
 * User profile for which custom registration challenge was sent.
 */
@property (nonatomic, readonly) ONGUserProfile *userProfile;

/**
 * Identity provider for which custom registration challenge was sent.
 */
@property (nonatomic, readonly) ONGIdentityProvider *identityProvider;

/**
 * Custom info used to perform a registration.
 */
@property (nonatomic, readonly, nullable) ONGCustomInfo *info;

/**
 * Error describing cause of failure of previous challenge response.
 * Possible error domains: ONGGenericErrorDomain
 */
@property (nonatomic, readonly, nullable) NSError *error;

/**
 * Sender awaiting for response to the custom registration challenge.
 */
@property (nonatomic, readonly) id<ONGCustomRegistrationChallengeSender> sender;

@end

NS_ASSUME_NONNULL_END
