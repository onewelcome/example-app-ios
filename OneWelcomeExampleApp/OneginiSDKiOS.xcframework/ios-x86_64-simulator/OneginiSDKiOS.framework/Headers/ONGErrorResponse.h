//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@interface ONGErrorResponse : NSObject

@property (copy, nonatomic) NSString *error;
@property (copy, nonatomic) NSString *errorDescription;
@property (copy, nonatomic) NSString *errorCode;
@property (copy, nonatomic) NSString *message;

@end
