//  Copyright © 2018 Onegini. All rights reserved.

#import <Foundation/Foundation.h>
@import AFNetworking;

@interface ONGRequestSerializerModel : NSObject

- (instancetype)initWithSerializers;
- (void)configureSerializers;

@property (nonatomic)AFJSONRequestSerializer *JSONRequestSerializer;
@property (nonatomic)AFHTTPRequestSerializer *requestSerializer;

@end
