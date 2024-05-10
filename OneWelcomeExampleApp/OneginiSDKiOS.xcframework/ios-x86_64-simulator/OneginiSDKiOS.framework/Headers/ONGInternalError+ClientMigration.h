// Copyright (c) 2020 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGInternalError.h"
#import "ONGHTTPStatus.h"

@class ErrorResponse;

NS_ASSUME_NONNULL_BEGIN

@interface ONGInternalError (ClientMigration)

+ (NSError *)migrationChallengeWithNetworkError:(NSError *)networkError statusCode:(ONGHTTPStatus)status swiftErrorResponse:(ErrorResponse *)errorResponse;
+ (NSError *)migrationResponseWithNetworkError:(NSError *)networkError statusCode:(ONGHTTPStatus)status swiftErrorResponse:(ErrorResponse *)errorResponse;

@end

NS_ASSUME_NONNULL_END
