//  Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGPinPolicy;

@interface ONGPinPolicy : NSObject <NSCoding>

@property (copy, nonatomic, readonly) NSString *policyName;
@property (nonatomic, readonly) NSArray<NSString *> *blackList;
@property (nonatomic, readonly) NSUInteger maxSimilarDigits;
@property (nonatomic, readonly) BOOL sequencesAllowed;
@property (nonatomic, readonly) NSUInteger pinLength;

- (instancetype)initWithPolicyName:(NSString *)policyName
                         blackList:(NSArray<NSString *> *)blackList
                  maxSimilarDigits:(NSUInteger)maxSimilarDigits
                  sequencesAllowed:(BOOL)sequencesAllowed
                         pinLength:(NSUInteger)pinLength;


@end
