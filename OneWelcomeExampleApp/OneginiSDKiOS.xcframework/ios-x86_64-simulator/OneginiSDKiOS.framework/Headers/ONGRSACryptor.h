//  Copyright © 2018 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@interface ONGRSACryptor : NSObject

- (NSData *)RSAKeyFromPGPPrivateKey:(NSData *)privateKeyData password:(NSString *)password;

- (NSString *)publicKeyPEMFromRSAKey:(NSData *)rsaKeyData password:(NSString *)password;

- (NSData *)signData:(NSData *)data withRSAKey:(NSData *)rsaKeyData password:(NSString *)password;

@end
