//  Copyright © 2018 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ONGHashService : NSObject

+ (NSString *)sha256:(NSString *)source;
+ (NSData *)sha256WithData:(NSData *)data;
+ (NSData *)sha256WithString:(NSString *)string;
+ (NSData *)hmacsha256WithData:(NSData *)data key:(NSData *)key;

@end

NS_ASSUME_NONNULL_END
