//  Copyright © 2018 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
@class ONGSessionTokens;

@interface ONGCustomRegistrationFinishResponse : NSObject

@property (copy, nonatomic) ONGSessionTokens *sessionTokens;
@property (copy, nonatomic) NSString *data;
@property (nonatomic, readonly) NSInteger status;

- (instancetype)initWithStatus:(NSInteger)status
                          data:(NSString *)data
                 sessionTokens:(ONGSessionTokens *)sessionTokens;

@end
