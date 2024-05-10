//  Copyright © 2021 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ONGHandshakeErrorResponse : NSObject

@property (copy, nonatomic) NSString *error;
@property (copy, nonatomic) NSString *errorDescription;
@property (copy, nonatomic) NSNumber *errorTimestamp;
@property (copy, nonatomic) NSString *errorAudience;
@property (copy, nonatomic) NSString *errorSignature;

@end

NS_ASSUME_NONNULL_END
