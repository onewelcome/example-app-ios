//  Copyright © 2018 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@interface ONGPGPKeyPair : NSObject<NSCoding>

@property (nonatomic) NSData *privateKey;
@property (nonatomic) NSData *publicKey;

+ (instancetype)keyPairWithPrivateKey:(NSData *)privateKey pubicKey:(NSData *)publicKey;

@end
