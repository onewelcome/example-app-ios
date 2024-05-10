//  Copyright © 2020 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ONGSignService : NSObject

+ (nullable NSData *)signData:(NSData *)data privateKey:(SecKeyRef)privateKey error:(NSError * _Nullable *)error;

@end

NS_ASSUME_NONNULL_END
