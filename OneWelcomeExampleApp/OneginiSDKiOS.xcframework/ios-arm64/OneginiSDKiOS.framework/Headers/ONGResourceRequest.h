// Copyright (c) 2016 Onegini. All rights reserved.

#import <Foundation/Foundation.h>

@class ONGMultipartData;

NS_ASSUME_NONNULL_BEGIN

/**
 * Supported types of parameters encoding during network request construction.
 */
typedef NS_ENUM(NSInteger, ONGParametersEncoding) {
    ONGParametersEncodingFormURL,
    ONGParametersEncodingJSON
};

/**
 * The object that encapsulates arguments required for performing a network request.
 *
 * @see ONGRequestBuilder, ONGMutableResourceRequest, ONGNetworkTask.
 */
@interface ONGResourceRequest : NSObject<NSCopying, NSMutableCopying>

/**
 * The path to the resource.
 *
 * @warning The path must be relative to the resource base URL from the config model (`ONGResourceBaseURL`).
 */
@property (copy, readonly) NSString *path;

/**
 * The HTTP Method. Supported values are: `GET`, `POST`, `PUT`, `DELETE`.
 * In case of an invalid method the request won't be executed and an error is returned.
 *
 * The default value is `GET`.
 */
@property (copy, readonly) NSString *method;

/**
 * The HTTP Headers to be added to the network request.
 *
 * @warning The following reserved headers take precedence over any custom values inserted by you: `Authorization`, `User-Agent`.
 */
@property (copy, readonly, nullable) NSDictionary<NSString *, NSString *> *headers;

/**
 * The parameters that will be added to the request. In conjunction with the `parametersEncoding` value it forms the body or URL of the request.
 *
 * @discussion For example the parameters {"key": "value"} for `parameterEncoding` equals to ONGParametersEncodingFormURL will form the following URL:
 * https://your.resource.server/path?key=value
 *
 * When using the `ONGParametersEncodingJSON` encoding, the parameters dictionary will be appended to the body.
 */
@property (copy, readonly, nullable) NSDictionary<NSString *, id> *parameters;

/**
 * The type of parameters encoding. It affects on how `parameters` get appended to the request. Sets the `Content-Type` header value:
 * ONGParametersEncodingFormURL - application/x-www-form-urlencoded
 * ONGParametersEncodingJSON - application/json
 *
 * The default value is ONGParametersEncodingJSON.
 */
@property (readonly) ONGParametersEncoding parametersEncoding;

/**
 * The HTTP body to be added to the network request.
 *
 * Setting the body on the request will overwrite the data passed as parameters and the parametersEncoding.
 */
@property (copy, readonly) NSData *body;

/**
 * The array of data to send using the `multipart/form-data` content type.
 *
 * The `multipart/form-data` Content-Type header is added automatically.
 *
 * When you add multipart data to a request the `parametersEncoding` property will be neglected.
 */
@property (copy, readonly, nullable) NSArray<ONGMultipartData *> *multipartData;

- (instancetype)initWithPath:(NSString *)path method:(NSString *)method;

- (instancetype)initWithPath:(NSString *)path method:(NSString *)method parameters:(nullable NSDictionary<NSString *, id> *)parameters;

- (instancetype)initWithPath:(NSString *)path method:(NSString *)method body:(nullable NSData *)body headers:(nullable NSDictionary<NSString *, NSString *> *)headers;

- (instancetype)initWithPath:(NSString *)path
                      method:(NSString *)method
                  parameters:(nullable NSDictionary<NSString *, id> *)parameters
                    encoding:(ONGParametersEncoding)encoding;

- (instancetype)initWithPath:(NSString *)path
                      method:(NSString *)method
                  parameters:(nullable NSDictionary<NSString *, id> *)parameters
                    encoding:(ONGParametersEncoding)encoding
                     headers:(nullable NSDictionary<NSString *, NSString *> *)headers;

- (instancetype)initWithPath:(NSString *)path
                      method:(NSString *)method
                  parameters:(nullable NSDictionary<NSString *, id> *)parameters
               multipartData:(NSArray<ONGMultipartData *> *) multipartData;

@end

/**
 * The mutable companion of the ONGResourceRequest.
 *
 * @see ONGResourceRequest, ONGRequestBuilder.
 */
@interface ONGMutableResourceRequest : ONGResourceRequest

@property (copy) NSString *path;
@property (copy) NSString *method;
@property (copy, nullable) NSDictionary<NSString *, NSString *> *headers;
@property (copy, nullable) NSData *body;
@property (copy, nullable) NSDictionary<NSString *, id> *parameters;
@property (copy, nullable) NSArray<ONGMultipartData *> *multipartData;
@property ONGParametersEncoding parametersEncoding;

@end

NS_ASSUME_NONNULL_END
