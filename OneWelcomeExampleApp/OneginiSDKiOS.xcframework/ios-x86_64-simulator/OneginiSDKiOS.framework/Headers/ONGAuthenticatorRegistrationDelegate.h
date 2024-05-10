//  Copyright © 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserClient;
@class ONGAuthenticator;
@class ONGUserProfile;
@class ONGPinChallenge;
@class ONGCustomAuthFinishRegistrationChallenge;
@class ONGCustomInfo;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Protocol describing interface for objects implementing methods required to register authenticator.
 *  All invocations are performed on the main queue.
 */
DEPRECATED_MSG_ATTRIBUTE("Please use `AuthenticatorRegistrationDelegate` protocol instead.")
@protocol ONGAuthenticatorRegistrationDelegate<NSObject>

@optional

/**
 *  Method called when authenticator registration is started.
 *
 *  @param userClient user client performing authenticator registration
 *  @param authenticator authenticator being registered
 *  @param userProfile user profile for which authenticator registration is started
 */
- (void)userClient:(ONGUserClient *)userClient didStartRegisteringAuthenticator:(ONGAuthenticator *)authenticator forUser:(ONGUserProfile *)userProfile;

/**
 *  Method called when authenticator registration is completed with success.
 *
 * @param userClient user client performing authenticator registration
 * @param authenticator registered authenticator
 * @param userProfile user profile for which authenticator was registered
 * @param customAuthInfo custom authenticator info about response from extension engine
 */
- (void)userClient:(ONGUserClient *)userClient didRegisterAuthenticator:(ONGAuthenticator *)authenticator forUser:(ONGUserProfile *)userProfile info:(ONGCustomInfo *_Nullable)customAuthInfo;

/**
 *  Method called when authenticator registration failed with an error.
 *
 *  The returned error will be either within the ONGGenericErrorDomain, ONGAuthenticatorRegistrationErrorDomain or ONGAuthenticationErrorDomain.
 *
 *  @param userClient user client performing authenticator registration
 *  @param authenticator authenticator whose registration failed
 *  @param userProfile user profile for which authenticator registration failed
 *  @param error error describing cause of an error. This error might include the ONGCustomInfo object into userInfo under the ONGCustomAuthInfoKey.
 */
- (void)userClient:(ONGUserClient *)userClient didFailToRegisterAuthenticator:(ONGAuthenticator *)authenticator
           forUser:(ONGUserProfile *)userProfile error:(NSError *)error;

/**
 *  Method called when authenticator registration requires PIN code to continue.
 *
 *  @param userClient user client performing authenticator registration
 *  @param challenge pin challenge used to complete registration
 */
- (void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge;

/**
 * Method called when custom authenticator registration requires data to continue.
 *
 * @param userClient user client performing authenticator registration
 * @param challenge challenge used to complete registration
 */
- (void)userClient:(ONGUserClient *)userClient didReceiveCustomAuthFinishRegistrationChallenge:(ONGCustomAuthFinishRegistrationChallenge *)challenge;

@end

NS_ASSUME_NONNULL_END
