//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGChangePinDelegate.h"
#import "ONGAuthenticationDelegate.h"
#import "ONGUserProfile.h"
#import "ONGMobileAuthRequestDelegate.h"
#import "ONGConfigModel.h"
#import "ONGResourceRequest.h"
#import "ONGNetworkTask.h"

@protocol ONGRegistrationDelegate;
@class ONGAuthenticator;
@protocol ONGAuthenticatorRegistrationDelegate;
@protocol ONGAuthenticatorDeregistrationDelegate;
@class ONGPendingMobileAuthRequest;
@class ONGIdentityProvider;

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
#pragma ide diagnostic ignored "OCUnusedPropertyInspection"

NS_ASSUME_NONNULL_BEGIN

/**
 *  This is the main entry point into the SDK.
 *  The public API of the SDK consists of this client and an authorization delegate.
 *  The client must be instantiated early in the App lifecycle and thereafter only referred to by it's shared instance.
 */
DEPRECATED_MSG_ATTRIBUTE("Please use `UserClient` protocol or `SharedUserClient.instance` object instead.")
@interface ONGUserClient : NSObject

/**
* Access to the initialized and configured instance of the `ONGUserClient`. Before calling this method You have to initialize
* SDK by calling `-[ONGClientBuilder build]`.
*
* @return instance of the configured `ONGUserClient`.
*
* @see `ONGClientBuilder`, `-[ONGClient userClient]`
*
* @warning If the SDK is not initialized via `-[ONGClientBuilder build]` this method throws an exception.
*/
+ (ONGUserClient *)sharedInstance;

/**
 *  Main entry point into the authentication process.
 *
 *  @param profile profile to authenticate
 *  @param authenticator authenticatior used to authenticate, if nil is provided the SDK will pick a preferred authenticator
 *  @param delegate authentication delegate, ONGUserClient keeps weak reference on delegate to avoid retain cycles
 */
- (void)authenticateUser:(ONGUserProfile *)profile authenticator:(nullable ONGAuthenticator *)authenticator delegate:(id<ONGAuthenticationDelegate>)delegate;

/**
 *  Main entry point into the implicit authentication process.
 *
 *  @param userProfile profile to authenticate
 *  @param scopes array of scopes
 *  @param completion block that will be called on implicit authentication completion.
 */
- (void)implicitlyAuthenticateUser:(ONGUserProfile *)userProfile scopes:(nullable NSArray<NSString *> *)scopes completion:(nullable void (^)(BOOL success,  NSError * _Nullable error))completion;

/**
 *  Main entry point into the registration process.
 *
 *  @param identityProvider a specific identity provider used for registration, if nil is provided the token server will pick a default identity provider
 *  @param scopes array of scopes
 *  @param delegate registration delegate, ONGUserClient keeps weak reference on delegate to avoid retain cycles
 */
- (void)registerUserWithIdentityProvider:(nullable ONGIdentityProvider *)identityProvider scopes:(nullable NSArray<NSString *> *)scopes delegate:(id<ONGRegistrationDelegate>)delegate;


/// Main entry point to register a stateless user (a temporary user not saved)
/// @param identityProvider a specific identity provider used for registration, if nil is provided the token server will pick a default identity provider
/// @param scopes array of scopes
/// @param delegate registration delegate, ONGUserClient keeps weak reference on delegate to avoid retain cycles
- (void)registerStatelessUserWithIdentityProvider:(nullable ONGIdentityProvider *)identityProvider scopes:(nullable NSArray<NSString *> *)scopes delegate:(id<ONGRegistrationDelegate>)delegate;

/**
 *  Initiates the PIN change sequence.
 *  If no refresh token is registered then the sequence is cancelled.
 *  This will invoke a call to the ONGAuthorizationDelegate - (void)askForPinChange:(NSUInteger)pinSize;
 *
 *  @param delegate Object handling change pin callbacks
 */
- (void)changePin:(id<ONGChangePinDelegate>)delegate;

/**
 *  Return currently authenticated user.
 *
 *  @return authenticated user
 */
- (nullable ONGUserProfile *)authenticatedUserProfile;

/**
 *  Return currently implicitly authenticated user.
 *
 *  @return authenticated user
 */
- (nullable ONGUserProfile *)implicitlyAuthenticatedUserProfile;

/**
 *  Checks if the pin satisfies all pin policy constraints.
 *
 *  The returned error will be either within the ONGGenericErrorDomain or the ONGPinValidationErrorDomain.
 *
 *  @param pin pincode to validate against pin policy constraints
 *  @param completion completion block invoked when validation is completed
 */
- (void)validatePinWithPolicy:(NSString *)pin completion:(void (^)(BOOL valid, NSError *_Nullable error))completion;

/**
 *  Performs a user logout, by invalidating the access token.
 *  The refresh token and client credentials remain untouched.
 *
 *  The returned error will be either within the ONGGenericErrorDomain or the ONGLogoutErrorDomain.
 *
 *  @param completion completion block that is going to be invoked upon logout completion.
 */
- (void)logoutUser:(nullable void (^)(ONGUserProfile *_Nullable userProfile, NSError *_Nullable error))completion;

/**
 *  Enrolls the currently connected device for mobile authentication.
 *
 *  The returned error will be either within the ONGGenericErrorDomain or the ONGMobileAuthEnrollmentErrorDomain
 *  @param completion delegate handling mobile enrollment callbacks
 */
- (void)enrollForMobileAuth:(nullable void (^)(BOOL enrolled, NSError *_Nullable error))completion;

/**
 *  Indicates whenever user is enrolled for mobile authentication.
 *  @param userProfile user profile
 *  @return BOOL indicating if the user is enrolled for mobile auth
 */
- (BOOL)isUserEnrolledForMobileAuth:(ONGUserProfile *)userProfile;

/**
 *  Enrolls the currently connected user for mobile authentication with Push.
 *
 *  The returned error will be either within the ONGGenericErrorDomain or the ONGMobileAuthEnrollmentErrorDomain
 *  @param deviceToken device token returned by APNS
 *  @param completion delegate handling mobile authentication enrollment callbacks
 */
- (void)enrollForPushMobileAuthWithDeviceToken:(NSData *)deviceToken completion:(nullable void (^)(BOOL enrolled, NSError *_Nullable error))completion;

/**
 *  Indicates whenever user is enrolled for push mobile authentication.
 *  @param userProfile user profile
 *  @return BOOL indicating if the user is enrolled for mobile auth with push
 */
- (BOOL)isUserEnrolledForPushMobileAuth:(ONGUserProfile *)userProfile;

/**
 *  Indicates if mobile authentication request can be handled by validating request string. The string should be in JSON
 *  format and it should contain valid transaction_id and otp code.
 *
 *  @param otp base64 string containing the OTP
 *  @return true, if request string can be processed by the Onegini SDK
 */
- (BOOL)canHandleOTPMobileAuthRequest:(NSString *)otp;

/**
 *  Handles mobile authentication done with the one time password (OTP).
 *  The client will then fetch the actual encrypted payload and invoke the delegate with the embedded message.
 *
 *  The returned error will be either within the ONGGenericErrorDomain or ONGMobileAuthRequestErrorDomain domain.
 *  @param otp base64 string containing the OTP
 *  @param delegate delegate responsible for handling push messages
 */
- (void)handleOTPMobileAuthRequest:(NSString *)otp delegate:(id<ONGMobileAuthRequestDelegate>)delegate;

/**
 *  Fetches the pending push mobile authentications.
 *  @param completion block passing an array (sorted by the date) of the pending requests or an error from ONGGenericErrorDomain
 */
- (void)pendingPushMobileAuthRequests:(void(^)(NSArray<ONGPendingMobileAuthRequest *> * _Nullable , NSError * _Nullable))completion;

/**
 *  Parses user info object (from notification that is received by the application) into ONGPendingMobileAuthRequest.
 *  The returned ONGPendingMobileAuthRequest object should be used to handle received notification `-handlePendingPushMobileAuthRequest:delegate:`.
 *
 *  This should be invoked from the UIApplicationDelegate
 *  - (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
 *
 *  The returned error will be either within the ONGGenericErrorDomain, ONGAuthenticationErrorDomain or ONGMobileAuthRequestErrorDomain.
 *  @param userInfo the userInfo of the received push notification
 *  @return ONGPendingMobileAuthRequest object, if the notification can be processed by the Onegini SDK
 */
- (nullable ONGPendingMobileAuthRequest *)pendingMobileAuthRequestFromUserInfo:(NSDictionary *)userInfo;

/**
 *  Handles pending push mobile authentication request.
 *  The client will then fetch the actual encrypted payload and invoke the delegate with the embedded message.
 *
 *  @param pendingMobileAuthRequest representation of a pending mobile authentication request.
 *  @param delegate delegate responsible for handling push messages
 */
- (void)handlePendingPushMobileAuthRequest:(ONGPendingMobileAuthRequest *)pendingMobileAuthRequest delegate:(id<ONGMobileAuthRequestDelegate>)delegate;

/**
 *  List of enrolled users stored locally
 *
 *  @return Enrolled users
 */
- (NSSet<ONGUserProfile *> *)userProfiles;

/**
 *  Delete user locally and revoke it from token server
 *
 *  The returned error will be either within the ONGGenericErrorDomain or the ONGDeregistrationErrorDomain.
 *
 *  @param userProfile user to disconnect.
 *  @param completion completion block that will be invoke upon deregistration completion.
 */
- (void)deregisterUser:(ONGUserProfile *)userProfile completion:(nullable void (^)(BOOL deregistered, NSError *_Nullable error))completion;

/**
 * Perform an authenticated network request. It requires passing an instance of the `ONGResourceRequest` as parameter.
 * In case of a malformed request no task will be returned and the completion block is called immediatelly (sychronously).
 * The User needs to be authenticated, otherwise SDK will return the `ONGFetchResourceErrorUserNotAuthenticated` error.
 *
 * The returned errors will be within the ONGGenericErrorDomain, ONGFetchResourceErrorDomain or NSURLErrorDomain.
 *
 * @param request instance of `ONGResourceRequest` instantiated manually or by using `ONGRequestBuilder`
 * @param completion block that will be called either upon request completion or immediatelly in case if validation error.
 * @return instance of `ONGNetworkTask` or nil. By utilizing `ONGNetworkTask` developer may observe and control execution of the request.
 */
- (nullable ONGNetworkTask *)fetchResource:(ONGResourceRequest *)request completion:(nullable void (^)(ONGResourceResponse *_Nullable response, NSError *_Nullable error))completion;

/**
 * Perform an implicitly authenticated network request. It requires passing an instance of the `ONGResourceRequest` as parameter.
 * In case of a malformed request no task will be returned and the completion block is called immediatelly (sychronously).
 * The User needs to be authenticated implicitly, otherwise SDK will return the `ONGFetchImplicitResourceErrorUserNotAuthenticatedImplicitly` error.
 *
 * The returned errors will be within the ONGGenericErrorDomain, ONGFetchImplicitResourceErrorDomain or NSURLErrorDomain.
 *
 * @param request instance of `ONGResourceRequest` instantiated manually or by using `ONGRequestBuilder`
 * @param completion block that will be called either upon request completion or immediatelly in case if validation error.
 * @return instance of `ONGNetworkTask` or nil. By utilizing `ONGNetworkTask` developer may observe and control execution of the request.
 */
- (nullable ONGNetworkTask *)fetchImplicitResource:(ONGResourceRequest *)request completion:(nullable void (^)(ONGResourceResponse *_Nullable response, NSError *_Nullable error))completion;

/**
 * Returns a set of identity providers.
 *
 * @return set of identity providers
 */
- (NSSet<ONGIdentityProvider *> *)identityProviders;

/**
 * Returns a access token for the currently authenticated user, or nil if no user is currently
 * authenticated.
 *
 * <strong>Warning</strong>: Do not use this method if you want to fetch resources from your resource gateway: use the resource methods
 * instead.
 *
 * @return String with access token or nil
 */
@property (nonatomic, readonly, nullable) NSString *accessToken;

/**
 * Returns an OpenID token for the currently authenticated user, or nil if no user is currently
 * authenticated.
 *
 * <strong>Warning</strong>: To get OpenID token user needs to be registered with "openid" scope
 *
 * @return String with OpenID token or nil
 */
@property (nonatomic, readonly, nullable) NSString *idToken;

/**
 * Returns a set of authenticators which are supported both, client and server side, and are not yet registered.
 *
 * @param userProfile user profile for which authenticators are fetched
 * @return set of non registered authenticators
 */
- (NSSet<ONGAuthenticator *> *)nonRegisteredAuthenticatorsForUser:(ONGUserProfile *)userProfile;

/**
 * Returns a set of registered authenticators.
 *
 * @param userProfile user profile for which authenticators are fetched
 * @return set of registered authenticators
 */
- (NSSet<ONGAuthenticator *> *)registeredAuthenticatorsForUser:(ONGUserProfile *)userProfile;

/**
 * Returns a set of both registered and nonregistered authenticators.
 *
 * @param userProfile user profile for which authenticators are fetched
 * @return set of registered authenticators
 */
- (NSSet<ONGAuthenticator *> *)allAuthenticatorsForUser:(ONGUserProfile *)userProfile;

/**
 * Registers an authenticator. Use one of the non registered authenticators returned by `nonRegisteredAuthenticatorsForUser:` method.
 * Registering an authenticator may require user authentication which is handled by the delegate.
 *
 * The returned errors will be within the ONGGenericErrorDomain, ONGAuthenticatorRegistrationErrorDomain or ONGAuthenticationErrorDomain.
 *
 * @param authenticator to be registered authenticator
 * @param delegate delegate registering the authenticator
 */
- (void)registerAuthenticator:(ONGAuthenticator *)authenticator delegate:(id<ONGAuthenticatorRegistrationDelegate>)delegate;

/**
 * Deregisters an authenticator. Use one of the registered authenticators returned by `registeredAuthenticatorsForUser:` method.
 *
 * The returned errors will be within the ONGGenericErrorDomain, ONGAuthenticatorDeregistrationErrorDomain or ONGAuthenticationErrorDomain.
 *
 * @param authenticator to be deregistered authenticator
 * @param delegate delegate deregistering the authenticator
 */
- (void)deregisterAuthenticator:(ONGAuthenticator *)authenticator delegate:(id<ONGAuthenticatorDeregistrationDelegate>)delegate;

/**
 * This method allows to take a session from mobile application and extend it to a browser on the same device.
 *
 * The returned errors will be within the ONGGenericErrorDomain or ONGAppToWebSingleSignOnErrorDomain.
 *
 * @param targetUrl url for which the App To Web Single Sign On token is requested
 * @param completion completion block invoked when action is completed
 **/
- (void)appToWebSingleSignOnWithTargetUrl:(NSURL *)targetUrl completion:(void (^)(NSURL * _Nullable, NSString * _Nullable, NSError * _Nullable))completion;

/**
 * Represents preferred authenticator. By default SDK uses PIN as preferred authenticator.
 */
@property (nonatomic) ONGAuthenticator *preferredAuthenticator;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
