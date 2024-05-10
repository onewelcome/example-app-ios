// Copyright (c) 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGInternalError.h"
#import "ONGErrors.h"
#import "ONGErrorContext.h"
#import "ONGHTTPStatus.h"

@class ErrorResponse;

NS_ASSUME_NONNULL_BEGIN

@interface ONGInternalError (Authentication)

+ (NSError *)authenticationErrorWithCode:(ONGAuthenticationError)code
                                 context:(ONGErrorContext)context
                                userInfo:(nullable NSDictionary *)userInfo
                         underlyingError:(nullable NSError *)underlyingError;

+ (NSError *)authenticatorDeregisteredError:(ONGAuthenticator *)authenticator
                                    context:(ONGErrorContext)context
                            underlyingError:(nullable NSError *)underlyingError;

+ (NSError *)biometricAuthenticationErrorFromNetworkError:(NSError *)networkError
                                               statusCode:(ONGHTTPStatus)statusCode
                                                  context:(ONGErrorContext)errorContext
                                       swiftErrorResponse:(ErrorResponse *)errorResponse;

+ (NSError *)tokenValidationErrorFromNetworkError:(NSError *)error
                                           status:(ONGHTTPStatus)status
                                          profile:(nullable ONGUserProfile *)userProfile
                               swiftErrorResponse:(ErrorResponse *)errorResponse;

+ (NSError *)implicitTokenValidationErrorFromNetworkError:(NSError *)networkError
                                                   status:(ONGHTTPStatus)statusCode
                                       swiftErrorResponse:(ErrorResponse *)errorResponse;

+ (NSError *)customAuthenticatorErrorFromNetworkError:(NSError *)networkError
                                               status:(ONGHTTPStatus)statusCode
                                        authenticator:(ONGAuthenticator *)authenticator
                                   swiftErrorResponse:(ErrorResponse *)errorResponse;


@end

NS_ASSUME_NONNULL_END
