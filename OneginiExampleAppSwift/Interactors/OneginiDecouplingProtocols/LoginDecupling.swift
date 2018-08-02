//
//  LoginDecupling.swift
//  OneginiExampleAppSwift
//
//  Created by Stanisław Brzeski on 02/08/2018.
//  Copyright © 2018 Onegini. All rights reserved.
//

extension ONGUserClient : LoginClientProtocol {
    func registeredAuthenticatorsArray(forUser user: NSObject & UserProfileProtocol) -> Array<ONGAuthenticator> {
        return Array(registeredAuthenticators(forUser: user as! ONGUserProfile))
    }
    
    func userProfilesArray() -> Array<NSObject & UserProfileProtocol> {
        return Array(userProfiles())
    }
    
    func authenticateUser(profile: NSObject & UserProfileProtocol, delegate: NSObject & LoginDelegate) {
        authenticateUser(profile as! ONGUserProfile, delegate: delegate as! ONGAuthenticationDelegate)
    }
}
extension ONGUserProfile : UserProfileProtocol {}
extension ONGCustomInfo : CustomInfoProtocol {}

extension ONGPinChallengeSender {
    func respond(withPin pin: String, challenge: PinChallengeProtocol) {
        respond(withPin: pin, challenge: challenge as! ONGPinChallenge)
    }
    func cancel(_ challenge: PinChallengeProtocol) {
        cancel(challenge as! ONGPinChallenge)
    }
}

@objc protocol LoginDelegate {
    func userClient1(_ loginClient: LoginClientProtocol, didReceive challenge: PinChallengeProtocol)
    func userClient2(_ loginClient: LoginClientProtocol, didAuthenticateUser _: UserProfileProtocol, info _: CustomInfoProtocol?)
    func userClient3(_ loginClient: LoginClientProtocol, didFailToAuthenticateUser _: UserProfileProtocol, error: Error)
}

@objc public protocol PinChallengeProtocol {
    var userProfileProtocol: UserProfileProtocol { get }
    var maxFailureCount: UInt { get }
    var previousFailureCount: UInt { get }
    var remainingFailureCount: UInt { get }
    var error: Error? { get }
    var sender: ONGPinChallengeSender { get }
}

extension ONGPinChallenge : PinChallengeProtocol {
    public var userProfileProtocol: UserProfileProtocol {
        get {
            return self.userProfile
        }
    }
}

@objc public protocol UserProfileProtocol {
    var profileId: String { get set }
}

@objc public protocol CustomInfoProtocol {
    var status: Int { get }
    var data: String { get }
}

extension LoginInteractor: ONGAuthenticationDelegate {
    func userClient(_ userClient: ONGUserClient, didReceive challenge: ONGPinChallenge) {
        self.userClient1(userClient as LoginClientProtocol, didReceive: challenge as PinChallengeProtocol)
    }
    
    func userClient(_ userClient: ONGUserClient, didAuthenticateUser userProfile: ONGUserProfile, info: ONGCustomInfo?) {
        self.userClient2(userClient as LoginClientProtocol, didAuthenticateUser: userProfile as UserProfileProtocol, info: info as CustomInfoProtocol?)
    }
    
    func userClient(_ userClient: ONGUserClient, didFailToAuthenticateUser userProfile: ONGUserProfile, error: Error) {
        self.userClient3(userClient as LoginClientProtocol, didFailToAuthenticateUser: userProfile as UserProfileProtocol, error: error)
    }
}
