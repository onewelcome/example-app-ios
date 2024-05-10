// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGPublicDefines.h"
#import "ONGSecurityControllerAdapter.h"

#ifndef ONG_DEFINES
#define ONG_DEFINES

#define ONGThreadAssert NSAssert([NSThread isMainThread], @"Invalid thread: OneginiSDK methods should be called only from the main thread.")

#define ONG_SYSTEM_VERSION_AT_LEAST(v) (([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending) || ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame))

#ifdef DEBUG
    #define ONGDLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
    #define ONGDLogMethodName() NSLog(@"OneginiLog: Application called %s", __PRETTY_FUNCTION__);
#else
    #define ONGDLog(...)
    #define ONGDLogMethodName() if (isDebugLogEnabled()) NSLog(@"OneginiLog: Application called %s", __PRETTY_FUNCTION__);
#endif


#ifndef ONG_BLOCK_ASSERTIONS

#define ONGAssert(condition, name, description, ...)\
do {\
    if (!(condition)) {\
        [NSException raise:name format:description, ##__VA_ARGS__];\
    }\
}\
while(0)

#define ONGConsistencyAssert(condition, description, ...) ONGAssert(condition, NSInternalInconsistencyException, description, ##__VA_ARGS__)

#else

#define ONGAssert(condition, name, description, ...)
#define ONGConsistencyAssert(condition, description, ...)

#endif

#endif
