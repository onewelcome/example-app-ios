// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPublicDefines.h"

typedef NSInteger ONGErrorCode;

/**
 * Generic errors that might happen in any flow (authentication, logout, etc) are in ONGGenericErrorDomain.
 */
ONG_EXTERN NSString *const ONGGenericErrorDomain;

/**
 * Error codes in ONGGenericErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGGenericError) {
    /// Due to a problem with the device internet connection it was not possible to initiate the requested action.
    ONGGenericErrorNetworkConnectivityFailure = 9000,
    /// Check the Onegini SDK configuration for the correct server URL.
    ONGGenericErrorServerNotReachable = 9001,
    /// The device registration was removed from the Token Server. All locally stored data is removed from the device and the user needs to register again.
    ONGGenericErrorDeviceDeregistered = 9002,
    /// The user account is deregistered from the device. The user supplied the wrong PIN for too many times. All local data associated with the user profile has been removed.
    ONGGenericErrorUserDeregistered = 9003,
    /// The Token Server denotes that the current app is no longer valid and can no longer be used. The end-user must update the application. Updating the SDK configuration might also solve the problem.
    ONGGenericErrorOutdatedApplication = 9004,
    /// The Token Server does not allow this application to run on the current OS version. Instruct the user to update the OS.
    ONGGenericErrorOutdatedOS = 9005,
    /// Requested action was cancelled.
    ONGGenericErrorActionCancelled = 9006,
    /// Another action already in progress and can not be performed concurrently.
    ONGGenericErrorActionAlreadyInProgress = 9007,
    /// An unknown error occurred
    ONGGenericErrorUnknown = 10000,
    /// The Token Server configuration is invalid.
    ONGGenericErrorConfigurationInvalid = 10001,
    /// The request to the Token Server was invalid. Please verify that the Token Server configuration is correct and that no reverse proxy is interfering with the connection.
    ONGGenericErrorRequestInvalid = 10015,
    /// The device could not be registered with the Token Server, verify that the SDK configuration, Token Server configuration and security features are correctly configured.
    ONGGenericErrorDeviceRegistrationFailure = 9008,
    /// The protected data storage could not be accessed.
    ONGGenericErrorProtectedDataStorageNotAvailable = 9023,
    /// The data storage could not be accessed.
    ONGGenericErrorDataStorageNotAvailable = 9024,
    /// The data storage is corrupted and cannot be recovered or cleared.
    ONGGenericErrorUnrecoverableDataState = 9025,
    /// The date or time used by the device is incorrect. Please check Date & Time Settings on the phone and sync them if necessary.
    ONGGenericErrorInvalidDateTime = 9031,
    /// Application integrity check failed. Please verify application signature on the Token Server.
    ONGGenericErrorAppIntegrityFailure = 10024,
};

/**
 * ONGAuthenticationErrorDomain contains errors that happen during Authentication.
 */
ONG_EXTERN NSString *const ONGAuthenticationErrorDomain;

typedef NS_ENUM(ONGErrorCode, ONGAuthenticationError) {
    /// The provided PIN was invalid
    ONGAuthenticationErrorInvalidPin = 9009,
    /// The authenticator that you provided is invalid. It may not exist, please verify whether you have supplied the correct authenticator.
    ONGAuthenticationErrorAuthenticatorInvalid = 9015,
    /// Authentication with the custom authenticator has failed. Please check the CustomInfo for details.
    ONGAuthenticationErrorCustomAuthenticatorFailure = 9027,
    /// The Token Server configuration does not allow you to use custom authenticators. Enable custom authentication for the current application in the Token Server configuration to allow custom authenticator usage.
    ONGAuthenticationErrorCustomAuthenticationDisabled = 10017,
    /// The given authenticator is not registered and therefore cannot be used.
    ONGAuthenticationErrorAuthenticatorNotRegistered = 10007,
    /// The Authenticator has been deregistered.
    ONGAuthenticationErrorAuthenticatorDeregistered = 9022,
    /// Deprecated Error. Authentication with the touchID has failed.
    ONGAuthenticationErrorTouchIDAuthenticatorFailure = 9030,
    /// Authentication with the biometric authenticator has failed.
    ONGAuthenticationErrorBiometricAuthenticatorFailure = 9030
};

/**
 * ONGAuthenticatorRegistrationErrorDomain contains errors that happen during Authenticator Registration.
 *
 * See -[ONGUserClient registerAuthenticator:delegate:]
 */
ONG_EXTERN NSString *const ONGAuthenticatorRegistrationErrorDomain;

/**
 * Error codes in ONGAuthenticatorRegistrationErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGAuthenticatorRegistrationError) {
    /// No user is currently authenticated, possibly due to the fact that the access token has expired. A user must be authenticated in order to register an authenticator.
    ONGAuthenticatorRegistrationErrorUserNotAuthenticated = 9010,
    /// The authenticator that you provided is invalid. It may not exist, please verify whether you have supplied the correct authenticator.
    ONGAuthenticatorRegistrationErrorAuthenticatorInvalid = 9015,
    /// Custom authenticator registration has failed. Please check the ONGCustomAuthenticatorInfo object for details.
    ONGAuthenticatorRegistrationErrorCustomAuthenticatorFailure = 9027,
    /// The given authenticator is already registered and can therefore not be registered again
    ONGAuthenticatorRegistrationErrorAuthenticatorAlreadyRegistered = 10004,
    /// The given authenticator is not supported.
    ONGAuthenticatorRegistrationErrorAuthenticatorNotSupported = 10006,
    /// The Token Server configuration does not allow you to use custom authenticators. Enable custom authentication for the current application in the Token Server configuration to allow custom authenticator usage.
    ONGAuthenticatorRegistrationErrorCustomAuthenticationDisabled = 10020
};

/**
 *
 * ONGAppToWebSingleSignOnErrorDomain contains errors that happen during Single sign on.
 *
 */
ONG_EXTERN NSString *const ONGAppToWebSingleSignOnErrorDomain;

typedef NS_ENUM(ONGErrorCode, ONGAppToWebSingleSignOnError) {
    /// No user is currently authenticated, possibly due to the fact that the access token has expired. A user must be authenticated in order to use single sign on feature.
    ONGAppToWebSingleSignOnErrorUserNotAuthenticated = 9010,
    /// The Token Server configuration does not allow you to use single sign on.
    ONGAppToWebSingleSignOnErrorAppToWebSingleSignOnDisabled = 10023,
};

/**
 * ONGAuthenticatorDeregistrationErrorDomain contains errors that happen during Authenticator Deregistration.
 *
 * See -[ONGUserClient deregisterAuthenticator:]
 */
ONG_EXTERN NSString *const ONGAuthenticatorDeregistrationErrorDomain;

/**
 * Error codes in ONGAuthenticatorDeregistrationErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGAuthenticatorDeregistrationError) {
    /// No user is currently authenticated, possibly due to the fact that the access token has expired. A user must be authenticated in order to deregister an authenticator.
    ONGAuthenticatorDeregistrationErrorUserNotAuthenticated = 9010,
    /// Authenticator was deregister only locally. It was not deregister on the server side.
    ONGAuthenticatorDeregistrationErrorDeregisteredLocally = 9028,
    /// The given authenticator is not supported.
    ONGAuthenticatorDeregistrationErrorAuthenticatorNotSupported = 10006,
    /// PIN authenticator deregistration not possible
    ONGAuthenticatorPinDeregistrationNotPossible = 10008,
    /// The Token Server configuration does not allow you to use custom authenticators. Enable custom authentication for the current application in the Token Server configuration to allow custom authenticator usage.
    ONGAuthenticatorDeregistrationErrorCustomAuthenticationDisabled = 10020
};

/**
 * ONGRegistrationErrorDomain contains errors that happen during User Registration.
 *
 * See -[ONGUserClient registerUser:delegate:]
 */
ONG_EXTERN NSString *const ONGRegistrationErrorDomain;

/**
 * Error codes in ONGRegistrationErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGRegistrationError) {
    /// The device could not be registered with the Token Server, verify that the SDK configuration, Token Server configuration and security features are correctly configured
    ONGRegistrationErrorDeviceRegistrationFailure = 9008,
    /// Stateless grant type is invalid or stateless registration is not enabled in backend configuration.
    ONGRegistrationErrorStateless = 9034,
    /// A possible security issue was detected during User Registration.
    ONGRegistrationErrorInvalidState = 10002,
    /// The specified custom IdP does not exist.
    ONGRegistrationErrorInvalidIdentityProvider = 10020,
    /// Invalid transaction id/state.
    ONGRegistrationErrorCustomRegistrationExpired = 10021,
    /// Authentication with the custom authenticator has failed. Please check the CustomInfo for details.
    ONGRegistrationErrorCustomRegistrationFailure = 10022,
    /// Signing in to external identity provider failed. Please check the underlying for details.
    ONGRegistrationErrorExternalIdentityProviderFailure = 10024
};

/**
 * ONGDeregistrationErrorDomain contains errors that happen during User Deregistration.
 *
 * See -[ONGUserClient deregisterUser:completion:]
 */
ONG_EXTERN NSString *const ONGDeregistrationErrorDomain;

/**
 * Error codes in ONGDeregistrationErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGDeregistrationError) {
    /// The user was only deregistered on the device. The device registration has not been removed on the server-side due to a connection problem. This does not pose a problem but you might want to inform the end-user as he might be able to see that he/she is still registered through a web portal.
    ONGDeregistrationErrorLocalDeregistration = 10003,
};

/**
 * ONGChangePinErrorDomain contains errors that happen during Pin Change.
 *
 * See -[ONGUserClient changePin:]
 */
ONG_EXTERN NSString *const ONGChangePinErrorDomain;

/**
 * Error codes in ONGChangePinErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGChangePinError) {
    /// No user is currently authenticated, possibly due to the fact that the access token has expired. A user must be authenticated in order to change PIN.
    ONGPinChangeErrorUserNotAuthenticated = 9010,
    /// The user is stateless, changing pin is not allowed
    ONGPinChangeErrorStatelessUser = 9033
};

/**
 * ONGPinValidationErrorDomain contains errors that happen during Pin Validation.
 *
 * See -[ONGUserClient validatePinWithPolicy:completion:]
 */
ONG_EXTERN NSString *const ONGPinValidationErrorDomain;

/**
 * The key for max similar digits value returned within userInfo. The value is defined by the received pin policy.
 * It is returned when Pin Validation fails with error ONGPinValidationErrorPinShouldNotUseSimilarDigits.
 */
ONG_EXTERN NSString *const ONGPinValidationErrorMaxSimilarDigitsKey;

/**
 * The key for recommended pin length returned within userInfo. The value is defined by the received pin policy.
 * It is returned when Pin Validation fails with error ONGPinValidationErrorWrongPinLength.
 */
ONG_EXTERN NSString *const ONGPinValidationErrorRequiredLengthKey;

/**
 * The key for which authenticator was disabled returned within userInfo.
 */
ONG_EXTERN NSString *const ONGDeregisteredAuthenticatorKey;

/**
 * The key used to fetch custom authenticator info from the error within the ONGPinChallenge during fallback to PIN flow.
 */
ONG_EXTERN NSString *const ONGCustomAuthInfoKey;

/**
 * The key used to fetch custom registration info from the error received on user registration failure.
 */
ONG_EXTERN NSString *const ONGCustomRegistrationInfoKey;

/**
 * Error codes in ONGPinValidationErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGPinValidationError) {
    /// The provided PIN was marked as blacklisted on the Token Server.
    ONGPinValidationErrorPinBlackListed = 9011,
    /// The provided PIN contains a not allowed sequence
    ONGPinValidationErrorPinShouldNotBeASequence = 9012,
    /// The provided PIN contains too many similar digits
    ONGPinValidationErrorPinShouldNotUseSimilarDigits = 9013,
    /// The provided PIN length is wrong
    ONGPinValidationErrorWrongPinLength = 9014
};

/**
 * ONGMobileAuthEnrollmentErrorDomain contains errors that happen during Mobile Authentication Enrollment.
 *
 * See -[ONGUserClient enrollForMobileAuth:]
 */
ONG_EXTERN NSString *const ONGMobileAuthEnrollmentErrorDomain;

/**
 * Error codes in ONGMobileAuthEnrollmentErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGMobileAuthEnrollmentError) {
    /// No user is currently authenticated, possibly due to the fact that the access token has expired. A user must be authenticated in order to enroll for mobile authentication.
    ONGMobileAuthEnrollmentErrorUserNotAuthenticated = 9010,
    /// The device is already enrolled for mobile authentication. This may happen in case an old push token is still left behind in the Token Server database and is reused by the OS.
    ONGMobileAuthEnrollmentErrorDeviceAlreadyEnrolled = 9016,
    /// The Mobile authentication feature is disabled in the Token Server configuration.
    ONGMobileAuthEnrollmentErrorEnrollmentNotAvailable = 9017,
    /// The user is already enrolled for mobile authentication on another device.
    ONGMobileAuthEnrollmentErrorUserAlreadyEnrolled = 9018,
    /// The user is not enrolled for mobile authentication.
    ONGMobileAuthEnrollmentErrorNotEnrolled = 9021,
    /// The user is stateless, enrollment is not allowed
    ONGMobileAuthEnrollmentErrorStatelessUser = 9033,
};

/**
 * ONGMobileAuthRequestErrorDomain contains errors that happen during handling of the Mobile Authentication Request.
 *
 * See -[ONGUserClient handleMobileAuthRequest:delegate:]
 */
ONG_EXTERN NSString *const ONGMobileAuthRequestErrorDomain;

/**
 * Error codes in ONGMobileAuthRequestErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGMobileAuthRequestError) {
    /// The mobile authentication request was not found. Please make sure that the mobile authentication request is available. This might be an indication that your Token Server setup is not correct. Cache replication might not work properly.
    ONGMobileAuthRequestErrorNotFound = 10013,
    /// The user has been disenrolled for security reasons. The keys have been revoked and the user has to enroll again in order to use mobile authentication.
    ONGMobileAuthRequestErrorUserDisenrolled = 9020,
    /// The user is not enrolled for mobile authentication.
    ONGMobileAuthRequestErrorNotEnrolled = 9021,
    /// No user is currently authenticated, possibly due to the fact that the access token has expired. A user must be authenticated in order to enroll for mobile authentication.
    ONGMobileAuthRequestErrorUserNotAuthenticated = 9010,
    /// The mobile authentication request cannot be handled by the Onegini SDK. It might be due to the fact that the request was not meant for the Onegini SDK or that it is malformed.
    ONGMobileAuthRequestErrorNotHandleable = 10018,
    /// The provided mobile authentication request is already being handled.
    ONGMobileAuthRequestErrorAlreadyHandled = 9029,
};

/**
 * ONGLogoutErrorDomain contains errors that happen during User Logout.
 *
 * See -[ONGUserClient logout:]
 */
ONG_EXTERN NSString *const ONGLogoutErrorDomain;

/**
 * Error codes in ONGLogoutErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGLogoutError) {
    /// The user was only logged out on the device. The access token has not been invalidated on the server-side. This does not pose a problem but you might want to inform the end-user as he might be able to see that he/she is still logged in through a web portal.
    ONGLogoutErrorLocalLogout = 10009
};

/**
 * ONGFetchResourceErrorDomain contains errors that happen during Resource Fetching for Authenticated User.
 *
 * See -[ONGUserClient fetchResource:completion:]
 */
ONG_EXTERN NSString *const ONGFetchResourceErrorDomain;

/**
 * Error codes in ONGFetchResourceErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGFetchResourceError) {
    /// No user is currently authenticated, possibly due to the fact that the access token has expired. A user must be authenticated in order to fetch resources.
    ONGFetchResourceErrorUserNotAuthenticated = 9010,
    /// provided request method is not valid, use one of @"GET", @"POST", @"DELETE", @"PUT"
    ONGFetchResourceErrorInvalidMethod = 10010,
    /// provided request headers are not valid
    ONGFetchResourceErrorInvalidHeaders = 10019
};

/**
 * ONGFetchUnauthenticatedResourceErrorDomain contains errors that happen during Resource Fetching without authentication.
 *
 * See -[ONGDeviceClient fetchUnauthenticatedResource:completion:]
 */
ONG_EXTERN NSString *const ONGFetchUnauthenticatedResourceErrorDomain;

/**
 * Error codes in ONGFetchUnauthenticatedResource
 */
typedef NS_ENUM(ONGErrorCode, ONGFetchUnauthenticatedResourceError) {
    /// provided request method is not valid, use one of @"GET", @"POST", @"DELETE", @"PUT"
    ONGFetchUnauthenticatedResourceErrorInvalidMethod = 10010,
    /// provided request headers are not valid
    ONGFetchUnauthenticatedResourceErrorInvalidHeaders= 10019
};

/**
 * ONGFetchResourceErrorDomain contains errors that happen during Resource Fetching for Authenticated User.
 *
 * See -[ONGDeviceClient fetchAnonymousResource:completion:]
 */
ONG_EXTERN NSString *const ONGFetchAnonymousResourceErrorDomain;

/**
 * Error codes in ONGFetchAnonymousResourceErrorDomain
 */
typedef NS_ENUM(ONGErrorCode, ONGFetchAnonymousResourceError) {
    /// provided request method is not valid, use one of @"GET", @"POST", @"DELETE", @"PUT"
    ONGFetchAnonymousResourceErrorInvalidMethod = 10010,
    /// A device access token could not be retrieved. Check your Application configuration in the Token Server
    ONGFetchAnonymousResourceErrorDeviceNotAuthenticated = 10012,
    /// provided request headers are not valid
    ONGFetchAnonymousResourceErrorInvalidHeaders = 10019
};

ONG_EXTERN NSString *const ONGFetchImplicitResourceErrorDomain;

typedef NS_ENUM(ONGErrorCode, ONGFetchResourceImplicitlyError) {
    /// No user is currently authenticated implicitly, possibly due to the fact that the implicit access token has expired. A user must be authenticated in order to fetch resources.
    ONGFetchImplicitResourceErrorUserNotAuthenticatedImplicitly = 9026,
    /// provided request method is not valid, use one of @"GET", @"POST", @"DELETE", @"PUT"
    ONGFetchImplicitResourceErrorInvalidMethod = 10010,
    /// provided request headers are not valid
    ONGFetchImplicitResourceErrorInvalidHeaders = 10019,
};
