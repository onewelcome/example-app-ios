//  Copyright © 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  The class representing Custom Authenticator related response from Extension Engine.
 */
DEPRECATED_MSG_ATTRIBUTE("Please use `CustomInfo` protocol instead.")
@interface ONGCustomInfo : NSObject

/**
 * Status of the Extension Engine response.
 */
@property (nonatomic, readonly) NSInteger status;

/**
 * Data sent by the Extension Engine.
 */
@property (nonatomic, readonly, copy) NSString *data;

@end

NS_ASSUME_NONNULL_END
