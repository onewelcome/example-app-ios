//  Copyright © 2021 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ONGHandshakeResponse : NSObject

@property (copy, nonatomic) NSString *publicKey;
@property (copy, nonatomic) NSString *signature;

@end

NS_ASSUME_NONNULL_END
