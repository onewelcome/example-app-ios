// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

#import "ONGErrors.h"
#import "ONGErrorContext.h"

@class ONGPinPolicy;
@class ONGUserProfile;
@class ONGAuthenticator;
@class ONGErrorResponse;

NS_ASSUME_NONNULL_BEGIN

extern NSString *const ONGOneginiErrorDomain;

@interface ONGInternalError : NSObject

+ (BOOL)isErrorFromOneginiDomain:(NSError *)error;
+ (NSError *)remapError:(NSError *)error context:(ONGErrorContext)context;
+ (NSError *)genericErrorWithCode:(ONGGenericError)code context:(ONGErrorContext)context;
+ (NSError *)genericErrorWithCode:(ONGGenericError)code context:(ONGErrorContext)context underlyingError:(nullable NSError *)underlyingError;
+ (NSError *)genericNetworkError:(NSError *)error statusCode:(NSInteger)statusCode;
+ (NSError *)genericNetworkError:(NSError *)error statusCode:(NSInteger)statusCode context:(ONGErrorContext)context;
@end

NS_ASSUME_NONNULL_END
