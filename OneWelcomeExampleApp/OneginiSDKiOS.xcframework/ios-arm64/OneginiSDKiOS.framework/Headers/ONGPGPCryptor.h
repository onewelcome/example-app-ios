//  Copyright © 2018 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGPGPKeyPair;

@interface ONGPGPCryptor : NSObject

+ (ONGPGPKeyPair *)generatePGPKeyPairWithUsername:(NSString *)username password:(NSString *)password;

+ (NSData *)encrypt:(NSData *)data withKey:(NSData *)publicKeyData signWith:(NSData *)privateKeyData password:(NSString *)pass;
+ (NSData *)decrypt:(NSData *)data withKey:(NSData *)privateKeyData verifyWith:(NSData *)publicKeyData password:(NSString *)pass;

@end
