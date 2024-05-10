// Copyright (c) 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGInternalError.h"
#import "ONGHTTPStatus.h"

@class ErrorResponse;

NS_ASSUME_NONNULL_BEGIN

@interface ONGInternalError (Deregistration)

+ (NSError *)deregistrationError;
+ (NSError *)deregistrationErrorFromNetworkError:(NSError *)networkError statusCode:(ONGHTTPStatus)statusCode swiftErrorResponse:(ErrorResponse *)errorResponse;

@end

NS_ASSUME_NONNULL_END
