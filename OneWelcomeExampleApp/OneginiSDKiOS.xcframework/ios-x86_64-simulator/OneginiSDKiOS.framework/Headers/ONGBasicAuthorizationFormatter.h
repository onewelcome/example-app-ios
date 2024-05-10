//  Copyright © 2018 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
#import "ONGClientCredentials.h"

NS_ASSUME_NONNULL_BEGIN

@interface ONGBasicAuthorizationFormatter : NSObject

+ (NSString *)basicHeaderWithCredentials:(ONGClientCredentials *)clientCredentials;

@end

NS_ASSUME_NONNULL_END
