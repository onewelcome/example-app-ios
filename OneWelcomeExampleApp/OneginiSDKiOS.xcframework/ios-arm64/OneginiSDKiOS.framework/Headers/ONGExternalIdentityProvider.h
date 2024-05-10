//  Copyright © 2018 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPublicDefines.h"

NS_ASSUME_NONNULL_BEGIN

ONG_EXTERN NSString *const ONGExternalIdpAppleType;

@interface ONGExternalIdentityProvider : NSObject<NSCopying>

/**
 * External identity provider name.
 */
@property (nonatomic, copy) NSString *name;

/**
 * External identity provider type.
 */
@property (nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
