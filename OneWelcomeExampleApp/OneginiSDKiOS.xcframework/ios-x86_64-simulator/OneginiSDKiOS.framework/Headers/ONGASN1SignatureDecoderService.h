//  Copyright © 2020 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@interface ONGASN1SignatureDecoderService : NSObject

+ (nullable NSData *)decodeASN1Signature:(nonnull NSData *)signature;

@end
