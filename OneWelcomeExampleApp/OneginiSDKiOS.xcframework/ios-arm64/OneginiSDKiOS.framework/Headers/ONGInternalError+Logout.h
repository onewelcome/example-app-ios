// Copyright (c) 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGInternalError.h"
#import "ONGHTTPStatus.h"

@class ErrorResponse;

NS_ASSUME_NONNULL_BEGIN

@interface ONGInternalError (Logout)

+ (NSError *)logoutError;
+ (NSError *)logoutErrorFromNetworkError:(NSError *)networkError statusCode:(ONGHTTPStatus)statusCode swiftErrorResponse:(ErrorResponse *)errorResponse;

@end

NS_ASSUME_NONNULL_END
