// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPublicDefines.h"

typedef NS_ENUM(NSInteger, ONGHTTPStatus) {
    ONGHTTPStatusUnknown = 0,
    ONGHTTPStatusBadRequest = 400,
    ONGHTTPStatusUnauthorized = 401,
    ONGHTTPStatusForbidden = 403,
    ONGHTTPStatusNotFound = 404,
    ONGHTTPStatusConflict = 409,
    ONGHTTPStatusGone = 410,
    ONGHTTPStatusAuthenticationTimeout = 419,
    ONGHTTPStatusInternalServerError = 500
};

ONG_EXTERN BOOL ONGHTTPStatusIsFailure(ONGHTTPStatus status);