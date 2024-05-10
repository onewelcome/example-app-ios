// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGConfigModel;

@interface ONGPGPPasswordProvider : NSObject

+ (NSString *)passwordFromConfigModel:(ONGConfigModel *)configModel uuid:(NSString *)uuid;

@end