//  Copyright © 2018 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@protocol ONGMappable;

@interface ONGMappingService : NSObject

+ (id)mapObject:(NSDictionary *)dictionary classToMap:(Class)classToMap;
+ (NSArray *)mapObjectArray:(NSArray *)array classToMap:(Class)classToMap;
+ (NSSet *)mapToSet:(NSArray *)array classToMap:(Class)classToMap;

@end
