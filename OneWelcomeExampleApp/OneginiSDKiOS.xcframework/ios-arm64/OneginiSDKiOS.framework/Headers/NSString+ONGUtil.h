//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSString (ONGUtil)

+ (BOOL)ong_isEmpty:(NSString *)source;
+ (NSString *)ong_base64StringFromURLSafeBase64String:(NSString *)string;
- (NSString *)ong_base64UrlEncodedStringFromBase64String;

@end
