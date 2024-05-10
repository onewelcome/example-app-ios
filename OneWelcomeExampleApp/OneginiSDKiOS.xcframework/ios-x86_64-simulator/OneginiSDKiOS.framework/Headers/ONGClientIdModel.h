// Copyright (c) 2020 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGDefines.h"

NS_ASSUME_NONNULL_BEGIN

ONG_EXTERN NSString *const ONGOAuthClientId;

@interface ONGClientIdModel : NSObject

- (BOOL)isClientRegistered:(NSError * _Nullable *)error;
- (NSString * _Nullable)clientId:(NSError * _Nullable *)error;
- (BOOL)storeClientId:(NSString *)clientId error:(NSError * _Nullable *)error;
- (BOOL)deleteClientId;

@end

NS_ASSUME_NONNULL_END
