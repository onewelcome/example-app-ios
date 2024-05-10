// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserProfile;

NS_ASSUME_NONNULL_BEGIN

/**
 * The class representing mobile authentication request.
 */
DEPRECATED_MSG_ATTRIBUTE("Please use `MobileAuthRequest` protocol instead.")
@interface ONGMobileAuthRequest : NSObject

/**
* The mobile authentication type which is configured in the Token Server admin panel.
* The type can be used to distinguish between business functionalities. For example, mobile authentication can be used for logging in or transaction approval.
* The type can then be used to distinguish on the mobile device which functionality is triggered.
*/
@property (nonatomic, copy, readonly) NSString *type;

/**
 * User profile for which mobile authenticate request was sent.
 */
@property (nonatomic, readonly) ONGUserProfile *userProfile;

/**
 * Original user info recevied from the -[UIApplicationDelegate application:didReceiveRemoteNotification:]
 *
 * @see -[ONGUserClient handleMobileAuthenticationRequest:delegate:]
 */
@property (nonatomic, copy, readonly) NSDictionary *userInfo;

/**
 * Message of the request passed by the TS.
 */
@property (nonatomic, readonly, nullable) NSString *message;

/**
 * Transaction ID, a unique identifier for each request.
 */
@property (nonatomic, copy, readonly) NSString *transactionId;

/**
 * The data that is to be signed by the user. This may contain sensitive data.
 */
@property (nonatomic, copy, readonly) NSString *signingData;

@end

NS_ASSUME_NONNULL_END
