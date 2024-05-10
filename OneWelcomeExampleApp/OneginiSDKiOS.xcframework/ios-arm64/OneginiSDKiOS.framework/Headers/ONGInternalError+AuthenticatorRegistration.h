// Copyright (c) 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGInternalError.h"
#import "ONGErrors.h"
#import "ONGHTTPStatus.h"

@class ErrorResponse;

@interface ONGInternalError (AuthenticatorRegistration)

+ (NSError *)unknownAuthenticatorRegistrationError;
+ (NSError *)authenticatorRegistrationErrorWithCode:(ONGAuthenticatorRegistrationError)errorCode;
+ (NSError *)authenticatorRegistrationErrorFromNetworkError:(NSError *)networkError status:(ONGHTTPStatus)status swiftErrorResponse:(ErrorResponse *)errorResponse;

@end
