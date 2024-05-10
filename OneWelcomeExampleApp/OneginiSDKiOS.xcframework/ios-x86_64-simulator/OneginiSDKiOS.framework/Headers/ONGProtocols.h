//  Copyright © 2021 Onegini. All rights reserved.

NS_ASSUME_NONNULL_BEGIN

#pragma mark - AppleIdAuthorizationControllerFactoryProtocol

@class ASAuthorizationController;
@protocol ASAuthorizationControllerDelegate;

@protocol AppleIdAuthorizationControllerFactoryProtocol <NSObject>

- (nonnull ASAuthorizationController *)authorizationControllerWithDelegate:(id<ASAuthorizationControllerDelegate>)delegate API_AVAILABLE(ios(13.0));

@end

#pragma mark - ClientAssertionServiceProtocol

@protocol ClientAssertionServiceProtocol <NSObject>

- (nullable NSString *)generateClientAssertionJWTWithClientId:(NSString *)clientId
                                          privateKey:(SecKeyRef)privateKey
                                                uuid:(NSString *)uuid
                                               error:(NSError **)error;

@end

#pragma mark - JSONWebKeySetServiceProtocol

@protocol JSONWebKeySetServiceProtocol <NSObject>

- (nullable NSDictionary *)generateJWKSWithEcPublicKey:(nullable SecKeyRef)publicKey
                                                 error:(NSError **)error;

@end

#pragma mark - JSONWebTokenServiceProtocol

@protocol JSONWebTokenServiceProtocol <NSObject>

- (nullable NSString *)generateJWTWithPayload:(NSDictionary<NSString *, id>*)payload
                                   privateKey:(SecKeyRef)privateKey
                                        error:(NSError **)error;

@end

#pragma mark - ONGDisconnectControllerProtocol

@protocol ONGDisconnectControllerProtocol <NSObject>

- (void)deleteLocalData;

@end

#pragma mark - RequestTokenNetworkServiceProtocol

@class ONGSessionTokens;

@protocol RequestTokenNetworkServiceProtocol <NSObject>

- (void)requestClientAccessTokenWithScopes:(nullable NSArray<NSString *> *)scopes
                                  clientId:(NSString *)clientId
                                privateKey:(SecKeyRef)privateKey
                                      uuid:(NSString *)uuid
                                completion:(void (^)(ONGSessionTokens *_Nullable, NSError *_Nullable))completion;

@end

#pragma mark - RevokeTokenNetworkServiceProtocol

@protocol RevokeTokenNetworkServiceProtocol <NSObject>

- (void)revokeToken:(nullable NSString *)token
           clientId:(NSString *)clientId
         privateKey:(SecKeyRef)privateKey
               uuid:(NSString *)uuid
         completion:(void (^)(BOOL, NSError * _Nullable))completion;

- (void)revokeProfile:(nullable NSString *)profileId
             clientId:(NSString *)clientId
           privateKey:(SecKeyRef)privateKey
                 uuid:(NSString *)uuid
                token:(nullable NSString *)token
                tokenType:(nullable NSString *)tokenType
           completion:(void (^)(BOOL, NSError * _Nullable))completion;

@end

#pragma mark - StoreKeyValueNetworkServiceProtocol

@protocol StoreKeyValueNetworkServiceProtocol <NSObject>

- (void)storePayload:(NSString * _Nonnull)payload
  identityProviderId:(NSString * _Nonnull)identityProviderId
          completion:(void(^)(NSString * _Nullable, NSError * _Nullable))completion;

@end

#pragma mark - NetworkParamsHelperProtocol

@class ONGConfigModel;
@protocol NetworkParamsHelperProtocol <NSObject>
@property (nullable, nonatomic) ONGConfigModel *configModel;

- (NSDictionary *)paramsWith:(NSString *)redirectURL
                        jwks:(NSDictionary *)jwks
        softwareStatementJWT:(NSString *)softwareStatementJWT;

@end

NS_ASSUME_NONNULL_END
