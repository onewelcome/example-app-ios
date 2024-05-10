//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserClient;
@class ONGPinChallenge;
@class ONGFingerprintChallenge;
@class ONGMobileAuthRequest;
@class ONGUserProfile;
@class ONGCustomAuthFinishAuthenticationChallenge;
@class ONGCustomInfo;
@class ONGBiometricChallenge;
@class ONGAuthenticator;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Protocol describing interface for objects implementing methods required to complete mobile authentication request.
 */
DEPRECATED_MSG_ATTRIBUTE("Please use `MobileAuthRequestDelegate` protocol instead.")
@protocol ONGMobileAuthRequestDelegate<NSObject>

@optional

/**
 *  Method called when mobile authentication request requires only confirmation to be completed.
 *
 *  @param userClient user client that received mobile authentication request
 *  @param confirmation confirmation block that needs to be invoked with confirmation value
 *  @param request mobile authentication request received by the SDK
 *
 *  @see ONGMobileAuthRequest
 */
- (void)userClient:(ONGUserClient *)userClient didReceiveConfirmationChallenge:(void (^)(BOOL confirmRequest))confirmation forRequest:(ONGMobileAuthRequest *)request;

/**
 *  Method called when mobile authentication request requires PIN code for confirmation.
 *
 *  @param userClient user client performing authentication
 *  @param challenge pin challenge used to complete authentication
 *  @param request mobile authentication request received by the SDK
 *
 *  @see ONGMobileAuthRequest
 */
- (void)userClient:(ONGUserClient *)userClient didReceivePinChallenge:(ONGPinChallenge *)challenge forRequest:(ONGMobileAuthRequest *)request;

/**
 *  Method called when authentication action requires TouchID or FaceID to continue. Its called before asking user for fingerprint or face.
 *  If its not implemented SDK will fallback to PIN code confirmation.
 *
 *  @param userClient user client performing authentication
 *  @param challenge biometric challenge used to complete authentication
 *  @param request mobile authentication request received by the SDK
 *
 *  @see ONGMobileAuthRequest, ONGBiometricChallenge
 */
- (void)userClient:(ONGUserClient *)userClient didReceiveBiometricChallenge:(ONGBiometricChallenge *)challenge forRequest:(ONGMobileAuthRequest *)request;

/**
 *  Method called when authentication action requires authentication with Custom Authenticator to continue.
 *
 *  @param userClient user client performing authentication
 *  @param challenge Custom Authenticator challenge used to complete authentication
 *  @param request mobile authentication request received by the SDK
 */
- (void)userClient:(ONGUserClient *)userClient didReceiveCustomAuthFinishAuthenticationChallenge:(ONGCustomAuthFinishAuthenticationChallenge *)challenge forRequest:(ONGMobileAuthRequest *)request;

/**
 *  Method called when mobile authentication request handling did fail.
 *
 *  The returned error will be either within the ONGGenericErrorDomain, ONGMobileAuthRequestErrorDomain or ONGAuthenticationErrorDomain.
 *
 *  @param userClient user client performing authentication
 *  @param request mobile authentication request received by the SDK
 *  @param authenticator authenticator used for mobile authentication, nil in case of authentication with confirmation
 *  @param error error describing failure reason
 *
 *  @see ONGMobileAuthRequest
 */
- (void)userClient:(ONGUserClient *)userClient didFailToHandleMobileAuthRequest:(ONGMobileAuthRequest *)request authenticator:(ONGAuthenticator *_Nullable)authenticator error:(NSError *)error;

/**
 *  Method called when mobile authentication request handled successfully.
 *
 *  @param userClient user client performing authentication
 *  @param request mobile authentication request received by the SDK
 *  @param authenticator authenticator used for mobile authentication, nil in case of authentication with confirmation
 *  @param customAuthenticatorInfo custom authenticator info about response from extension engine
 *
 *  @see ONGMobileAuthRequest
 */
- (void)userClient:(ONGUserClient *)userClient didHandleMobileAuthRequest:(ONGMobileAuthRequest *)request authenticator:(ONGAuthenticator *_Nullable)authenticator info:(ONGCustomInfo *_Nullable)customAuthenticatorInfo;

@end

NS_ASSUME_NONNULL_END
