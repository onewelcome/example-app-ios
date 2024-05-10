//  Copyright © 2018 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@interface ONGCustomRegistrationInitResponse : NSObject

@property (copy, nonatomic) NSString *transactionId;
@property (copy, nonatomic) NSString *data;
@property (nonatomic, readonly) NSInteger status;

- (instancetype)initWithTransactionId:(NSString *)transactionId
                                 data:(NSString *)data
                               status:(NSInteger)status;

@end
