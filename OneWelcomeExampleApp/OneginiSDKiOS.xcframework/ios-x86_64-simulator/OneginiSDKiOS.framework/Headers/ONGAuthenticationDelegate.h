//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserClient;
@class ONGUserProfile;
@class ONGPinChallenge;
@class ONGFingerprintChallenge;
@class ONGBiometricChallenge;
@class ONGCustomAuthFinishAuthenticationChallenge;
@class ONGCustomInfo;
@class ONGAuthenticator;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Protocol describing interface for objects implementing methods required to complete authentication.
 *  All invocations are performed on the main queue.
 */
DEPRECATED_MSG_ATTRIBUTE("Please use `AuthenticationDelegate` protocol instead.")
@protocol ONGAuthenticationDelegate<NSObject>

/**
 *  Method called when authentication action requires PIN code to continue.
 *
 *  @param userClient user client performing authentication
 *  @param challenge pin challenge used to complete authentication
 */
- (void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge;

@optional

/**
 *  Method called when authentication action is started.
 *
 *  @param userClient user client performing authentication
 *  @param userProfile currently authenticated user profile
 *  @param authenticator authenticator used to perform authentication
 */
- (void)userClient:(ONGUserClient *)userClient didStartAuthenticationForUser:(ONGUserProfile *)userProfile authenticator:(ONGAuthenticator *)authenticator;

/**
 *  Method called when authentication action requires TouchID or FaceID to continue. Its called before asking user for fingerprint or face.
 *  If its not implemented SDK will continue automatically.
 *
 *  @param userClient user client performing authentication
 *  @param challenge biometric challenge used to complete authentication
 */
- (void)userClient:(ONGUserClient *)userClient didReceiveBiometricChallenge:(ONGBiometricChallenge *)challenge;

/**
 *  Method called when authentication action requires Custom Authenticator data to continue.
 *
 *  @param userClient user client performing authentication
 *  @param challenge Custom Authenticator challenge used to complete authenticator
 */
- (void)userClient:(ONGUserClient *)userClient didReceiveCustomAuthFinishAuthenticationChallenge:(ONGCustomAuthFinishAuthenticationChallenge *)challenge;

/**
 *  Method called when authentication action is completed with success.
 *
 *  @param userClient user client performing authentication
 *  @param userProfile successfully authenticated user profile
 *  @param authenticator authenticator used to perform authentication
 *  @param customAuthInfo custom authenticator info about response from extension engine
 */
- (void)userClient:(ONGUserClient *)userClient didAuthenticateUser:(ONGUserProfile *)userProfile authenticator:(ONGAuthenticator *)authenticator info:(nullable ONGCustomInfo *)customAuthInfo;

/**
 *  Method called when authentication action failed with error.
 *
 *  The returned error will be either within the ONGGenericErrorDomain, ONGAuthenticationErrorDomain.
 *
 *  @param userClient user client performing authentication
 *  @param userProfile user profile for which authentication failed
 *  @param authenticator authenticator used to perform authentication
 *  @param error error describing cause of an error. This error might include the ONGCustomInfo object into userInfo under the ONGCustomAuthInfoKey.
 */
- (void)userClient:(ONGUserClient *)userClient didFailToAuthenticateUser:(ONGUserProfile *)userProfile authenticator:(ONGAuthenticator *)authenticator error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
