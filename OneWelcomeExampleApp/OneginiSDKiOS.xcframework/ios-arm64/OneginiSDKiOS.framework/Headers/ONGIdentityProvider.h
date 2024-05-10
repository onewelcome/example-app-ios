//  Copyright © 2018 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGExternalIdentityProvider;

NS_ASSUME_NONNULL_BEGIN
DEPRECATED_MSG_ATTRIBUTE("Please use `IdentityProvider` protocol instead.")
@interface ONGIdentityProvider : NSObject<NSCopying>

/**
 * Identity provider identifier.
 */
@property (nonatomic, copy) NSString *identifier;

/**
 * Identity provider name.
 */
@property (nonatomic, copy) NSString *name;

/**
 * External identity provider.
 */
@property (nonatomic, copy, nullable) ONGExternalIdentityProvider *externalIdentityProvider;

@end

NS_ASSUME_NONNULL_END
