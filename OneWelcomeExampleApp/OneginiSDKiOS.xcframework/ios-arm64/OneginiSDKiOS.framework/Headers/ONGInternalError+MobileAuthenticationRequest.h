// Copyright (c) 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGInternalError.h"
#import "ONGErrors.h"
#import "ONGMobileAuthenticationType.h"
#import "ONGHTTPStatus.h"

@class ErrorResponse;

NS_ASSUME_NONNULL_BEGIN

@interface ONGInternalError (MobileAuthenticationRequest)

+ (NSError *)mobileAuthenticationRequestErrorWithCode:(ONGMobileAuthRequestError)code
                                      underlyingError:(nullable NSError *)underlyingError;

+ (NSError *)mobileAuthenticationFetchPendingRequestNetworkError:(NSError *)networkError
                                                      statusCode:(ONGHTTPStatus)statusCode
                                              swiftErrorResponse:(ErrorResponse *)errorResponse;


+ (NSError *)mobileAuthenticationFetchDataRequestNetworkError:(NSError *)networkError
                                                   statusCode:(ONGHTTPStatus)statusCode
                                           swiftErrorResponse:(ErrorResponse *)errorResponse;

+ (NSError *)mobileAuthAnswerErrorFromNetworkError:(NSError *)networkError
                                  mobileAuthMethod:(ONGMobileAuthenticationMethod)method
                                        statusCode:(ONGHTTPStatus)statusCode
                                       userProfile:(ONGUserProfile *)userProfile
                                swiftErrorResponse:(ErrorResponse *)errorResponse;

+ (NSError *)mobileAuthenticationSigningErrorFormNetworkError:(NSError *)networkError
                                                   statusCode:(ONGHTTPStatus)status
                                                swiftErrorResponse:(ErrorResponse *)errorResponse;

@end

NS_ASSUME_NONNULL_END
