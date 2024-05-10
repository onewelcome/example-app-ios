//  Copyright © 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGAuthenticator;
@class ONGCustomAuthDeregistrationChallenge;
@class ONGUserProfile;


#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
#pragma ide diagnostic ignored "OCUnusedPropertyInspection"

NS_ASSUME_NONNULL_BEGIN

/**
 * Protocol describing SDK object waiting for response to deregistration of custom authenticator.
 */
@protocol ONGCustomAuthDeregistrationChallengeSender<NSObject>

/**
 * Method to continue deregistration.
 *
 * @param challenge challenge for which the response is made
 */
- (void)continueWithChallenge:(ONGCustomAuthDeregistrationChallenge *)challenge;

/**
 * Method to cancel deregistration.
 *
 * @param challenge challenge for which the response is made
 * @param underlyingError error specifying the reason behind the cancellation. It will ba added as a underlying error
 *        within the cancellation error returned in the deregistration failure method.
 */
- (void)cancelChallenge:(ONGCustomAuthDeregistrationChallenge *)challenge withUnderlyingError:(NSError *_Nullable)underlyingError;

@end

/**
 * Represents deregistration challenge of custom authenticator. It provides all information about the challenge and a sender awaiting for a response.
 */
DEPRECATED_MSG_ATTRIBUTE("Please use `CustomAuthDeregistrationChallenge` protocol instead.")
@interface ONGCustomAuthDeregistrationChallenge : NSObject

/**
 * User profile for which deregistration challenge was sent.
 */
@property (nonatomic, readonly) ONGUserProfile *userProfile;

/**
 * Authenticator to be deregistered.
 */
@property (nonatomic, readonly) ONGAuthenticator *authenticator;

/**
 * Sender awaiting response to the deregistration challenge.
 */
@property (nonatomic, readonly) id<ONGCustomAuthDeregistrationChallengeSender> sender;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
