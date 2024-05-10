// Copyright (c) 2017 Onegini. All rights reserved.

#import "ONGInternalError.h"
#import "ONGHTTPStatus.h"
#import "ONGHandshakeErrorResponse.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ONGPayloadEncryptionErrorCode)
{
    ONGPayloadEncryptionErrorPayloadEncryptionDisabled
};

ONG_EXTERN NSString *const ONGErrorTimestampKey;
ONG_EXTERN NSString *const ONGErrorAudienceKey;
ONG_EXTERN NSString *const ONGErrorSignatureKey;
ONG_EXTERN NSString *const ONGErrorKey;

@interface ONGInternalError (PayloadEncryption)

+ (NSError *)handshakeV2NetworkError:(NSError *)networkError statusCode:(ONGHTTPStatus)statusCode errorResponse:(ONGHandshakeErrorResponse *)errorResponse;
+ (NSError *)messageExchangeErrorForErrorCode:(nullable NSString *)errorCode statusCode:(ONGHTTPStatus)statusCode;

@end

NS_ASSUME_NONNULL_END
