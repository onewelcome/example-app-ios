//  Copyright © 2017 Onegini. All rights reserved.

#ifndef ONGSecurityControllerAdapter_h
#define ONGSecurityControllerAdapter_h

#include <stdio.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wunused-function"

static BOOL isDebugDetectionEnabled(void)
{
    BOOL debugDetectionEnabled = YES;
    if ([NSClassFromString(@"SecurityController") respondsToSelector:NSSelectorFromString(@"debugDetection")]) {
        debugDetectionEnabled = (bool)[NSClassFromString(@"SecurityController") performSelector:NSSelectorFromString(@"debugDetection")];
    }
    return debugDetectionEnabled;
}

static BOOL isRootDetectionEnabled(void)
{
    BOOL rootDetectionEnabled = YES;
    if ([NSClassFromString(@"SecurityController") respondsToSelector:NSSelectorFromString(@"rootDetection")]) {
        rootDetectionEnabled = (bool)[NSClassFromString(@"SecurityController") performSelector:NSSelectorFromString(@"rootDetection")];
    }
    return rootDetectionEnabled;
}

static BOOL isDebugLogEnabled(void)
{
    BOOL debugLogEnabled = NO;
    if ([NSClassFromString(@"SecurityController") respondsToSelector:NSSelectorFromString(@"debugLogs")]) {
        debugLogEnabled = (bool)[NSClassFromString(@"SecurityController") performSelector:NSSelectorFromString(@"debugLogs")];
    }
    return debugLogEnabled;
}

static BOOL isTamperingProtectionEnabled(void)
{
    BOOL tamperingProtectionEnabled = YES;
    if ([NSClassFromString(@"SecurityController") respondsToSelector:NSSelectorFromString(@"tamperingProtection")]) {
        tamperingProtectionEnabled = (bool)[NSClassFromString(@"SecurityController") performSelector:NSSelectorFromString(@"tamperingProtection")];
    }
    return tamperingProtectionEnabled;
}

#pragma clang diagnostic pop

#endif
