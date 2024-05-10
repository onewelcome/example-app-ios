// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserClient;
@class ONGUserProfile;
@class ONGCreatePinChallenge;
@class ONGBrowserRegistrationChallenge;
@class ONGCustomRegistrationChallenge;
@class ONGCustomInfo;
@class ONGIdentityProvider;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Protocol describing interface for objects implementing methods required to complete registration.
 *  All invocations are performed on the main queue.
 */
DEPRECATED_MSG_ATTRIBUTE("Please use `RegistrationDelegate` protocol instead.")
@protocol ONGRegistrationDelegate<NSObject>

/**
 *  Method called when registration action requires creation of a PIN to continue.
 *
 *  @param userClient user client performing registration
 *  @param challenge create pin challenge used to complete registration
 */
- (void)userClient:(ONGUserClient *)userClient didReceivePinRegistrationChallenge:(ONGCreatePinChallenge *)challenge;

@optional

/**
 *  Method called when the registration action requires you to open a browser with the given URL. When the browser is finished processing it will use a
 *  custom URL scheme to hand over control to your application. You now need to call the respondWithURL:challenge: method of id<ONGBrowserRegistrationChallenge>
 *  instance in order to hand over control to the SDK and continue the registration action.
 *
 *  @discussion Example: if the HTTP request is performed by an external web browser, it will call
 *  application:openURL:options: method on the AppDelegate. In the implementation of this method the redirect can be handled
 *  by calling [challenge.sender respondWithUrl:url challenge:challenge].
 *
 *  @param userClient user client performing registration
 *  @param challenge contains URL used to perform a registration code request
 */
- (void)userClient:(ONGUserClient *)userClient didReceiveBrowserRegistrationChallenge:(ONGBrowserRegistrationChallenge *)challenge;

/**
 *  Method called when the initialization of two step custom registration requires a optional data to continue. You now need to call the respondWithData:challenge:
 *  method of id<ONGCustomRegistrationChallengeSender> instance, in order to provide optional data to the initialization step and continue the two step registration.
 *
 *  @param userClient user client performing registration
 *  @param challenge contains data and identity provider used to perform a registration
 */
- (void)userClient:(ONGUserClient *)userClient didReceiveCustomRegistrationInitChallenge:(ONGCustomRegistrationChallenge *)challenge;

/**
 *  Method called when the second step of two step custom registration or one step custom registration requires a optional data to continue.
 *  You now need to call the respondWithData:challenge: method of id<ONGCustomRegistrationChallenge> instance, in order to provide optional data to the finish step and continue the two step registration.
 *
 *  @param userClient user client performing registration
 *  @param challenge contains data, identity provider and user profile used to perform a registration
 */
- (void)userClient:(ONGUserClient *)userClient didReceiveCustomRegistrationFinishChallenge:(ONGCustomRegistrationChallenge *)challenge;

/**
 *  Method called when registration action is started.
 *
 *  @param userClient user client performing authentication
 */
- (void)userClientDidStartRegistration:(ONGUserClient *)userClient;

/**
 *  Method called when registration action is completed with success.
 *
 *  @param userClient user client performing registration
 *  @param userProfile successfully registered user profile
 *  @param identityProvider identity provider for which user registration succeeded.
 *  @param info object which contains additional information about successful user registration.
 */
- (void)userClient:(ONGUserClient *)userClient didRegisterUser:(ONGUserProfile *)userProfile identityProvider:(ONGIdentityProvider *)identityProvider info:(ONGCustomInfo *_Nullable)info;

/**
 *  Method called when registration action failed with error.
 *
 *  The returned error will be either within the ONGGenericErrorDomain or the ONGRegistrationErrorDomain.
 *
 *  @param userClient user client performing registration
 *  @param error error describing cause of an error. This error might include the ONGCustomInfo object into userInfo under the ONGCustomRegistrationInfoKey.
 *  @param identityProvider identity provider for which an error occured.
 */
- (void)userClient:(ONGUserClient *)userClient didFailToRegisterWithIdentityProvider:(ONGIdentityProvider *)identityProvider error:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
