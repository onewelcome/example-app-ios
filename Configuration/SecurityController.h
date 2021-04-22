#import <Foundation/Foundation.h>

@interface SecurityController : NSObject
+ (bool)rootDetection;
+ (bool)debugDetection;
+ (bool)debugLogs;
@end
