//  Copyright © 2018 Onegini. All rights reserved.

#import "ONGInternalError.h"

@class ErrorResponse;

NS_ASSUME_NONNULL_BEGIN

@interface ONGInternalError (Registration)

+ (NSError *)registrationErrorWithCode:(ONGRegistrationError)code context:(ONGErrorContext)context underlyingError:(nullable NSError *)underlyingError;
+ (NSError *)customRegistrationRequestNetworkError:(NSError *)networkError statusCode:(NSInteger)statusCode swiftErrorResponse:(ErrorResponse *)errorResponse;
+ (NSError *)externalIdentityProviderRegistrationRequestNetworkError:(NSError *)networkError statusCode:(NSInteger)statusCode swiftErrorResponse:(ErrorResponse *)errorResponse;

@end

NS_ASSUME_NONNULL_END
