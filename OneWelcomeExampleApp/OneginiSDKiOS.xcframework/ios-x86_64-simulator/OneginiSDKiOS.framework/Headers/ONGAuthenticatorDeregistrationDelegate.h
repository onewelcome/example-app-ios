//  Copyright © 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserClient;
@class ONGAuthenticator;
@class ONGUserProfile;
@class ONGCustomAuthDeregistrationChallenge;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Protocol describing interface for objects implementing methods required to deregister authenticator.
 *  All invocations are performed on the main queue.
 */
DEPRECATED_MSG_ATTRIBUTE("Please use `AuthenticatorDeregistrationDelegate` protocol instead.")
@protocol ONGAuthenticatorDeregistrationDelegate<NSObject>

@optional

/**
 *  Method called when authenticator deregistration is started.
 *
 *  @param userClient user client performing authenticator deregistration
 *  @param authenticator authenticator being deregistered
 *  @param userProfile user profile for which authenticator deregistration is started
 */
- (void)userClient:(ONGUserClient *)userClient didStartDeregisteringAuthenticator:(ONGAuthenticator *)authenticator forUser:(ONGUserProfile *)userProfile;

/**
 *  Method called when authenticator deregistration is completed with success.
 *
 * @param userClient user client performing authenticator deregistration
 * @param authenticator deregistered authenticator
 * @param userProfile user profile for which authenticator was deregistered
 */
- (void)userClient:(ONGUserClient *)userClient didDeregisterAuthenticator:(ONGAuthenticator *)authenticator forUser:(ONGUserProfile *)userProfile;

/**
 *  Method called when authenticator deregistration failed with an error.
 *
 *  The returned error will be either within the ONGGenericErrorDomain or ONGAuthenticatorDeregistrationErrorDomain.
 *
 *  @param userClient user client performing authenticator deregistration
 *  @param authenticator authenticator whose deregistration failed
 *  @param userProfile user profile for which authenticator deregistration failed
 *  @param error error describing cause of an error
 */
- (void)userClient:(ONGUserClient *)userClient didFailToDeregisterAuthenticator:(ONGAuthenticator *)authenticator forUser:(ONGUserProfile *)userProfile error:(NSError *)error;

/**
 * Method called when custom authenticator deregistration requires data to continue.
 *
 * @param userClient user client performing authenticator registration
 * @param challenge challenge used to complete deregistration
 */
- (void)userClient:(ONGUserClient *)userClient didReceiveCustomAuthDeregistrationChallenge:(ONGCustomAuthDeregistrationChallenge *)challenge;

@end

NS_ASSUME_NONNULL_END
