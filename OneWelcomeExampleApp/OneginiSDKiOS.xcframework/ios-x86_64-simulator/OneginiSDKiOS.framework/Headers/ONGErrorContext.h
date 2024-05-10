// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPublicDefines.h"

typedef NS_ENUM(NSInteger, ONGAuthenticationMethod) {
    ONGAuthenticationMethodUndefined,
    ONGAuthenticationMethodEnrollProfile,
    ONGAuthenticationMethodAuthenticateProfile,
    ONGAuthenticationMethodReauthenticateProfile,
    ONGAuthenticationMethodAuthenticateDevice,
};

typedef NS_ENUM(NSInteger, ONGErrorContext) {
    ONGErrorContextUndefined,
    ONGErrorContextSDKInitialization,
    
    ONGErrorContextUserRegistration,
    ONGErrorContextUserDeregistration,
    ONGErrorContextUserAuthentication,
    ONGErrorContextUserLogout,
    
    ONGErrorContextPinChange,
    ONGErrorContextMobileAuthenticationEnrollment,
    ONGErrorContextMobileAuthentication,

    ONGErrorContextClientRegistration,
    ONGErrorContextClientAuthentication,
    ONGErrorContextClientValidation,
    ONGErrorContextClientMigration,
    ONGErrorContextPinValidation,

    ONGErrorContextAuthenticatorRegistration,
    ONGErrorContextAuthenticatorDeregistration,

    ONGErrorContextFetchUserResource,
    ONGErrorContextFetchUnauthenticatedResource,
    ONGErrorContextFetchAnonymousResource,
    
    ONGErrorContextImplicitAuthentication,
    ONGErrorContextFetchResourceImplicitly,
    
    ONGErrorContextAppToWebSingleSignOn,
};

ONG_EXTERN NSString *ONGErrorContextToString(ONGErrorContext context);
ONG_EXTERN ONGErrorContext ONGErrorContextFromAuthenticationMethod(ONGAuthenticationMethod method);
