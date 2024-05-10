//  Copyright © 2019 Onegini. All rights reserved.

#import "ONGInternalError.h"

@class ErrorResponse;

NS_ASSUME_NONNULL_BEGIN

@interface ONGInternalError (AppToWebSingleSignOn)

+ (NSError *)appToWebSingleSignOnRequestNetworkError:(NSError *)networkError statusCode:(NSInteger)statusCode swiftErrorResponse:(ErrorResponse *)errorResponse;

@end

NS_ASSUME_NONNULL_END
