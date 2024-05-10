// Copyright (c) 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserProfile;

NS_ASSUME_NONNULL_BEGIN

/**
 * The class representing pending mobile authentication request.
 */
DEPRECATED_MSG_ATTRIBUTE("Please use `PendingMobileAuthRequest` protocol instead.")
@interface ONGPendingMobileAuthRequest : NSObject

/**
 * Transaction ID, a unique identifier for each request.
 */
@property (nonatomic, copy, readonly) NSString *transactionId;

/**
 * User profile for which mobile authentication request was sent.
 */
@property (nonatomic, readonly) ONGUserProfile *userProfile;

/**
 * The date when the mobile authentication request was sent.
 */
@property (nonatomic, readonly, nullable) NSDate *date;

/**
 * Time to live for which mobile authentication request was sent.
 */
@property (nonatomic, readonly, nullable) NSNumber *timeToLive;

/**
 * Message of the request passed by the TS.
 */
@property (nonatomic, copy, readonly, nullable) NSString *message;

/**
 * Original user info recevied from the -[UIApplicationDelegate application:didReceiveRemoteNotification:]
 *
 * @see -[ONGUserClient handleMobileAuthenticationRequest:delegate:]
 */
@property (nonatomic, copy, readonly, nullable) NSDictionary *userInfo;

@end

NS_ASSUME_NONNULL_END
