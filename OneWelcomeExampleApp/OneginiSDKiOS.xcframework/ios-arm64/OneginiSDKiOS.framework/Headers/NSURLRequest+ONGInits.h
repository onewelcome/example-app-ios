//  Copyright © 2018 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
@import AFNetworking;

NS_ASSUME_NONNULL_BEGIN

@interface NSURLRequest (ONGInits)

+ (nullable instancetype)ong_requestWithPath:(NSString *)path
                                      method:(NSString *)method
                                      params:(nullable NSDictionary *)params
                                     headers:(nullable NSDictionary *)headers
                           requestSerializer:(AFHTTPRequestSerializer *)serializer;

@end

NS_ASSUME_NONNULL_END
