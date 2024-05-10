//  Copyright © 2018 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserProfile;
@class ONGIdentityProvider;
@class ONGBrowserRegistrationChallenge;

NS_ASSUME_NONNULL_BEGIN

/**
 * Protocol describing SDK object waiting for response to browser registration challenge.
 */
@protocol ONGBrowserRegistrationChallengeSender<NSObject>

/**
 * Method providing the URL to the SDK.
 *
 * @param url URL provided by the user
 * @param challenge registration request challenge for which the response is made
 */
- (void)respondWithURL:(NSURL *)url challenge:(ONGBrowserRegistrationChallenge *)challenge;

/**
 * Method to cancel challenge
 *
 * @param challenge registration request challenge that needs to be cancelled
 */
- (void)cancelChallenge:(ONGBrowserRegistrationChallenge *)challenge;

@end

/**
 * Represents browser registration challenge. It provides all information about the challenge and a sender awaiting for a response.
 */
DEPRECATED_MSG_ATTRIBUTE("Please use `BrowserRegistrationChallenge` protocol instead.")
@interface ONGBrowserRegistrationChallenge : NSObject

/**
 * Identity provider for which browser registration challenge was sent.
 */
@property (nonatomic, readonly) ONGIdentityProvider *identityProvider;

/**
 * URL used to perform a registration code request.
 */
@property (nonatomic, readonly) NSURL *url;

/**
 * Error describing cause of failure of previous challenge response.
 * Possible error domains: ONGGenericErrorDomain
 */
@property (nonatomic, readonly, nullable) NSError *error;

/**
 * Sender awaiting for response to the browser registration challenge.
 */
@property (nonatomic, readonly) id<ONGBrowserRegistrationChallengeSender> sender;

@end

NS_ASSUME_NONNULL_END
