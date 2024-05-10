// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ONGAuthenticatorType) {
    ONGAuthenticatorPIN = 0,
    ONGAuthenticatorTouchID = 1 /* Deprecated enum value, use ONGAuthenticatorBiometric instead. */,
    ONGAuthenticatorBiometric = 1,
    ONGAuthenticatorCustom = 3,
};

NS_ASSUME_NONNULL_BEGIN

/**
 * Represents an authenticator. Authenticator objects can be obtained using `ONGUserClient` `nonRegisteredAuthenticatorsForUser:` or
 * `registeredAuthenticatorsForUser:`.
 */
DEPRECATED_MSG_ATTRIBUTE("Please use `Authenticator` protocol instead.")
@interface ONGAuthenticator : NSObject <NSSecureCoding>

/**
 * Unique authenticator identifier.
 */
@property (nonatomic, copy, readonly) NSString *identifier;

/**
 * Human-readable authenticator name.
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 * Authenticator type.
 */
@property (nonatomic, readonly) ONGAuthenticatorType type;

/**
 * Indicates if this authenticator is registered for the user for which it was fetched.
 */
@property (nonatomic, readonly, getter=isRegistered) BOOL registered;

/**
 * Indicates if this authenticator is set as preferred for the user for which it was fetched.
 */
@property (nonatomic, readonly, getter=isPreferred) BOOL preferred;

@end

NS_ASSUME_NONNULL_END
