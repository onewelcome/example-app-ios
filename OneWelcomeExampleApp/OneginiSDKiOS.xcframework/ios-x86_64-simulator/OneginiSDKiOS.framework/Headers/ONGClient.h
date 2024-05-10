// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGUserClient.h"
#import "ONGConfigModel.h"

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
#pragma ide diagnostic ignored "OCUnusedPropertyInspection"

@class ONGDeviceClient;

NS_ASSUME_NONNULL_BEGIN

/**
 * Main entry point for the Onegini SDK. This class owns SDK's configuration and such clients as `ONGUserClient` and
 * `ONGDeviceClient`. In order to use any feature of the OneginiSDK `-[ONGClientBuilder build]` needs to be called first.
 *
 * @see `ONGClientBuilder`
 */
DEPRECATED_MSG_ATTRIBUTE("Please use `Client` protocol or `SharedClient.instance` object instead.")
@interface ONGClient : NSObject

/**
 * Access to the initialized and configured instance of the `ONGClient`. Before calling this method You have to initialize
 * SDK by calling `-[ONGClientBuilder build]`.
 *
 * @return instance of the configured `ONGClient`.
 *
 * @see `ONGClientBuilder`
 *
 * @warning If the SDK is not initialized via `-[ONGClientBuilder build]` this method throws an exception.
 */
+ (instancetype)sharedInstance;

/**
 * Is a mandatory first call on ONGClient which is returned by `-[ONGClientBuilder build]`.
 *
 * @param completion is called after the method processing has finished. If the SDK is successfully started, other further work is allowed. Errors passed to the block will be within the ONGGenericErrorDomain
 *
 * @see `ONGClientBuilder`
 *
 */
- (void)start:(nullable void (^)(BOOL success, NSError * _Nullable error))completion;

/**
 * Reset to the state the SDK had just after completing the start method. Errors passed to the block will be within the ONGGenericErrorDomain.
 *
 * @param completion is called after the method processing has finished.
 *
 */
- (void)reset:(nullable void (^)(BOOL success, NSError * _Nullable error))completion;

/**
 * The ConfigModel used to configure OneginiSDK.
 */
@property (nonatomic, readonly) ONGConfigModel *configModel;

/**
 * Instance of `ONGUserClient` used for user-related features access. Once SDK has been configured, `ONGUserClient`
 * can be access either by calling this property or by `-[ONGUserClient sharedInstance]`.
 *
 * @see `-[ONGUserClient sharedInstance]`
 */
@property (nonatomic, readonly) ONGUserClient *userClient;

/**
 * Instance of `ONGDeviceClient` used for device and network-related features. Once SDK has been configured, `ONGDeviceClient`
 * can be access either by calling this property or by `-[ONGDeviceClient sharedInstance]`.
 *
 * @see `-[ONGDeviceClient sharedInstance]`
 */
@property (nonatomic, readonly) ONGDeviceClient *deviceClient;

@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
