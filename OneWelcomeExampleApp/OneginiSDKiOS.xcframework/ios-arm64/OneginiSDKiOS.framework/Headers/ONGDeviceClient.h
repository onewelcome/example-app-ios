// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPublicDefines.h"

@class ONGNetworkTask;
@class ONGResourceRequest;
@class ONGResourceResponse;

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
#pragma ide diagnostic ignored "OCUnusedPropertyInspection"

NS_ASSUME_NONNULL_BEGIN

DEPRECATED_MSG_ATTRIBUTE("Please use `DeviceClient` protocol or `SharedDeviceClient.instance` object instead.")
@interface ONGDeviceClient : NSObject

/**
 * Access to the initialized and configured instance of the `ONGDeviceClient`. Before calling this method You have to initialize
 * SDK by calling `-[ONGClientBuilder build]`.
 *
 * @return instance of the configured `ONGDeviceClient`.
 *
 * @see `ONGClientBuilder`, `-[ONGClient deviceClient]`
 *
 * @warning If the SDK is not initialized via `-[ONGClientBuilder build]` this method throws an exception.
 */
+ (ONGDeviceClient *)sharedInstance;

/**
 * Performs device authentication.
 *
 * The returned error will be of the ONGGenericErrorDomain.
 *
 * @param scopes array of scopes.
 * @param completion block that will be called on authentication completion.
 */
- (void)authenticateDevice:(nullable NSArray<NSString *> *)scopes completion:(nullable void (^)(BOOL success, NSError * _Nullable error))completion;

/**
 * Perform an authenticated network request. It requires passing an instance of the `ONGResourceRequest` as parameter.
 * In case of a malformed request no task will be returned and the completion block is called immediately (synchronously).
 * The device needs to be authenticated, otherwise SDK will return the `ONGFetchAnonymousResourceErrorDeviceNotAuthenticated` error.
 *
 * The returned errors will be within the ONGGenericErrorDomain, ONGFetchAnonymousResourceErrorDomain or NSURLErrorDomain.
 *
 * @param request instance of `ONGResourceRequest` instantiated manually or by using `ONGRequestBuilder`
 * @param completion block that will be called either upon request completion or immediately in case if validation error.
 * @return instance of `ONGNetworkTask` or nil. By utilizing `ONGNetworkTask` developer may observe and control execution of the request.
 */
- (nullable ONGNetworkTask *)fetchResource:(ONGResourceRequest *)request completion:(nullable void (^)(ONGResourceResponse * _Nullable response, NSError * _Nullable error))completion;

/**
 * Perform an unauthenticated network request. It requires passing an instance of the `ONGResourceRequest` as parameter.
 * In case of a malformed request no task will be returned and the completion block is called immediately (synchronously).
 *
 * The returned errors will be within the ONGGenericErrorDomain, ONGFetchUnauthenticatedResourceErrorDomain or NSURLErrorDomain.
 *
 * @param request instance of `ONGResourceRequest` instantiated manually or by using `ONGRequestBuilder`
 * @param completion completion block that will be called either upon request completion or immediately in case if validation error.
 * @return instance of `ONGNetworkTask` or nil. By utilizing `ONGNetworkTask` developer may observe and control exectution of request.
 */
- (nullable ONGNetworkTask *)fetchUnauthenticatedResource:(ONGResourceRequest *)request completion:(nullable void (^)(ONGResourceResponse * _Nullable response, NSError * _Nullable error))completion;

/**
 * Returns the clientId for the registered device.
 *
 * @param error describes the reason behind the clientId fetch failure.
 * @return string with clientId.
 */
- (nullable NSString *)clientIdWithError:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
