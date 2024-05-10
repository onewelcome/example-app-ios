// Copyright (c) 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGUserProfile;

@interface ONGMobileAuthenticationCryptor : NSObject

- (NSData *)encryptAnswerParameters:(NSDictionary *)parameters profile:(ONGUserProfile *)profile error:(NSError **)error;

@end
