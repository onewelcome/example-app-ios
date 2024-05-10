// Copyright (c) 2017 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@interface ONGMultipartData : NSObject

/**
 * The data to be encoded and appended to the form data.
 */
@property(nonatomic) NSData *data;

/**
 * The name to be associated with the specified data.
 */
@property(nonatomic) NSString *name;

/**
 * The filename of the specified data.
 */
@property(nonatomic) NSString *fileName;

/**
 * The MIME type of the specified data.
 */
@property(nonatomic) NSString *mimeType;

@end
