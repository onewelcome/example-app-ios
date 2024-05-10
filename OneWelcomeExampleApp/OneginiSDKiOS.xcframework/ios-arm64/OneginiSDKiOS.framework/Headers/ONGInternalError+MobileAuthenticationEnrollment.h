// Copyright (c) 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGInternalError.h"
#import "ONGHTTPStatus.h"

@class ErrorResponse;

NS_ASSUME_NONNULL_BEGIN

@interface ONGInternalError (MobileAuthenticationEnrollment)

+ (NSError *)mobileAuthenticationErrorWithCode:(ONGMobileAuthEnrollmentError)code;

+ (NSError *)pushMobileAuthEnrollmentErrorFromNetworkError:(NSError *)networkError status:(ONGHTTPStatus)status swiftErrorResponse:(ErrorResponse *)errorResponse;
+ (NSError *)mobileAuthEnrollmentErrorFromNetworkError:(NSError *)networkError status:(ONGHTTPStatus)status swiftErrorResponse:(ErrorResponse *)errorResponse;

@end

NS_ASSUME_NONNULL_END
