//  Copyright © 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGCustomAuthFinishRegistrationChallenge;
@class ONGAuthenticator;
@class ONGUserProfile;

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
#pragma ide diagnostic ignored "OCUnusedPropertyInspection"

NS_ASSUME_NONNULL_BEGIN

/**
 * Protocol describing SDK object waiting for response to registration of custom authenticator.
 */
@protocol ONGCustomAuthFinishRegistrationChallengeSender<NSObject>

/**
 * Method to provide data requried to complete registration.
 *
 * @param challenge challenge for which the response is made
 */
- (void)respondWithData:(NSString *)data challenge:(ONGCustomAuthFinishRegistrationChallenge *)challenge;

/**
 * Method to cancel registration.
 *
 * @param challenge challenge for which the response is made
 * @param underlyingError error specifying the reason behind the cancellation. It will ba added as a underlying error
 *        within the cancellation error returned in the registration failure method.
 */
- (void)cancelChallenge:(ONGCustomAuthFinishRegistrationChallenge *)challenge underlyingError:(nullable NSError *)underlyingError;

@end

/**
 * Represents registration challenge of custom authenticator. It provides all information about the challenge and a sender awaiting for a response.
 */
DEPRECATED_MSG_ATTRIBUTE("Please use `CustomAuthFinishRegistrationChallenge` protocol instead.")
@interface ONGCustomAuthFinishRegistrationChallenge : NSObject

/**
 * User profile for which registration challenge was sent.
 */
@property (nonatomic, readonly) ONGUserProfile *userProfile;

/**
 * Authenticator to be registered.
 */
@property (nonatomic, readonly) ONGAuthenticator *authenticator;

/**
 * Sender awaiting response to the registration challenge.
 */
@property (nonatomic, readonly) id<ONGCustomAuthFinishRegistrationChallengeSender> sender;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
