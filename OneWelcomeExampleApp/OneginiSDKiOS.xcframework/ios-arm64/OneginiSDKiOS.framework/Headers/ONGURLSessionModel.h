//  Copyright © 2018 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
@import AFNetworking;

@interface ONGURLSessionModel : NSObject

@property (nonatomic) AFURLSessionManager *tokenServerEncryptedSessionManager;
@property (nonatomic) AFURLSessionManager *resourceServerEncryptedSessionManager;

@end
