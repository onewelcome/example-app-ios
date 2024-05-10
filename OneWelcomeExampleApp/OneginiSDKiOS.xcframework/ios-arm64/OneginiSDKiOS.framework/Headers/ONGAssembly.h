//  Copyright © 2017 Onegini. All rights reserved.

#import <UIKit/UIKit.h>
@import Typhoon;

@class ONGUserClient;
@class ONGOperationAssembly;
@class ONGControllerAssembly;
@class ONGChallengeAssembly;
@class ONGServiceAssembly;
@class ONGModelAssembly;
@class ONGFactoryAssembly;

@interface ONGAssembly : TyphoonAssembly

@property (nonatomic, readonly) ONGModelAssembly *modelAssembly;
@property (nonatomic, readonly) ONGServiceAssembly *serviceAdapterAssembly;
@property (nonatomic, readonly) ONGControllerAssembly *controllerAssembly;
@property (nonatomic, readonly) ONGFactoryAssembly *factoryAssembly;

@end
