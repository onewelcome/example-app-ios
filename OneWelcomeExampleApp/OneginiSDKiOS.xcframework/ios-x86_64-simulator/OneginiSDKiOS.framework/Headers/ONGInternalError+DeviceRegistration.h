// Copyright (c) 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGInternalError.h"
#import "ONGHTTPStatus.h"

@class ErrorResponse;

NS_ASSUME_NONNULL_BEGIN

ONG_EXTERN NSString *const ONGErrorDomainClientRegistration;

typedef NS_ENUM(NSInteger, ONGClientRegistrationErrorCode)
{
    ONGClientRegistrationErrorRegistrationIdConflict
};

@interface ONGInternalError (DeviceRegistration)

+ (NSError *)clientChallengeWithNetworkError:(NSError *)networkError statusCode:(ONGHTTPStatus)status swiftErrorResponse:(ErrorResponse *)errorResponse;
+ (NSError *)registrationResponseWithNetworkError:(NSError *)networkError statusCode:(ONGHTTPStatus)status swiftErrorResponse:(ErrorResponse *)errorResponse;

@end

NS_ASSUME_NONNULL_END
