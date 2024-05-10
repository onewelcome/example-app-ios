//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

/**
 * Object representing the user profile.
 */
DEPRECATED_MSG_ATTRIBUTE("Please use `UserProfile` protocol instead.")
@interface ONGUserProfile : NSObject<NSCoding>

/**
 * Unique user profile identifier.
 */
@property (nonatomic, strong) NSString *profileId;

/**
 * Convenience initializer for ONGUserProfile.
 */
+ (ONGUserProfile *)profileWithId:(NSString *)profileId;

@end
