// Copyright (c) 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGInternalError.h"
#import "ONGErrors.h"
#import "ONGHTTPStatus.h"

@class ErrorResponse;

NS_ASSUME_NONNULL_BEGIN

@interface ONGInternalError (AuthenticatorDeregistration)

+ (NSError *)authenticatorDeregistrationErrorWithCode:(ONGAuthenticatorDeregistrationError)errorCode underlyingError:(NSError *_Nullable)underlyingError;
+ (NSError *)authenticatorDeregistrationNetworkError:(NSError *)networkError statusCode:(NSInteger)statusCode errorResponse:(ONGErrorResponse *)errorResponse;
+ (NSError *)customAuthenticatorDeregistrationNetworkError:(NSError *)networkError statusCode:(ONGHTTPStatus)statusCode swiftErrorResponse:(ErrorResponse *)errorResponse;

@end

NS_ASSUME_NONNULL_END
