//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSString (ONGHex)

- (NSString *)ong_toHex;
- (NSData *)ong_dataFromHexString;
+ (NSString *)ong_hexStringWithData:(NSData *)data;
- (BOOL)ong_isHex;

@end
