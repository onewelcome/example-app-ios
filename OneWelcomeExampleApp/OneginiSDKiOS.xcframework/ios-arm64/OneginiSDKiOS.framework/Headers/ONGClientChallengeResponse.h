//  Copyright © 2020 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGAbdet.h"

NS_ASSUME_NONNULL_BEGIN

@interface ONGClientChallengeResponse : NSObject

@property (nonatomic) ONGIntegrityType integrityLevel;
@property (copy, nonatomic) NSString *challenge;

@end

NS_ASSUME_NONNULL_END
