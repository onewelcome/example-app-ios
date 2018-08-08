//
// Copyright (c) 2018 Onegini. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

extension ONGUserProfile : UserProfileProtocol {}

extension ONGCustomInfo : CustomInfoProtocol {}

extension ONGAuthenticator : AuthenticatorProtocol {}

@objc public protocol AuthenticatorProtocol {
    var identifier : String { get }
    var name : String { get }
    var type : ONGAuthenticatorType { get }
    var isRegistered : Bool { get }
    var isPreferred : Bool { get }
}

@objc public protocol UserProfileProtocol {
    var profileId: String { get set }
}

@objc public protocol CustomInfoProtocol {
    var status: Int { get }
    var data: String { get }
}

extension ONGUserClient : LoginClientProtocol {
    func registeredAuthenticatorsArray(forUser user: NSObject & UserProfileProtocol) -> Array<NSObject & AuthenticatorProtocol> {
        return Array(registeredAuthenticators(forUser: user as! ONGUserProfile))
    }
    
    func userProfilesArray() -> Array<NSObject & UserProfileProtocol> {
        return Array(userProfiles())
    }
    
    func authenticateUser(profile: NSObject & UserProfileProtocol, delegate: NSObject & LoginDelegate) {
        authenticateUser(profile as! ONGUserProfile, delegate: delegate as! ONGAuthenticationDelegate)
    }
}

//extension ONGPinChallengeSender where Self: PinChallengeSenderProtocol {
//    func respond(withPin pin: String, challengeProtocol: NSObject & PinChallengeProtocol) {
//        
//    }
//    func cancel(challengeProtocol: PinChallengeProtocol) {
//        
//    }
//}

@objc public protocol PinChallengeSenderProtocol {
    func respond(withPin pin: String, challengeProtocol: NSObject & PinChallengeProtocol)
    func cancel(challengeProtocol: PinChallengeProtocol)
}

@objc public protocol PinChallengeProtocol {
    var userProfileProtocol: NSObject & UserProfileProtocol { get }
    var maxFailureCount: UInt { get }
    var previousFailureCount: UInt { get }
    var remainingFailureCount: UInt { get }
    var error: Error? { get }
    var sender: ONGPinChallengeSender { get }
}

extension ONGPinChallenge : PinChallengeProtocol {
    public var userProfileProtocol: NSObject &  UserProfileProtocol {
        get {
            return self.userProfile
        }
    }
}

extension LoginInteractor: ONGAuthenticationDelegate {
    func userClient(_ userClient: ONGUserClient, didReceive challenge: ONGPinChallenge) {
        self.userClient(userClient as LoginClientProtocol, didReceive: challenge as NSObject & PinChallengeProtocol)
    }
    
    func userClient(_ userClient: ONGUserClient, didAuthenticateUser userProfile: ONGUserProfile, info: ONGCustomInfo?) {
        self.userClient(userClient as LoginClientProtocol, didAuthenticateUser: userProfile as UserProfileProtocol, info: info as CustomInfoProtocol?)
    }
    
    func userClient(_ userClient: ONGUserClient, didFailToAuthenticateUser userProfile: ONGUserProfile, error: Error) {
        self.userClient(userClient as LoginClientProtocol, didFailToAuthenticateUser: userProfile as UserProfileProtocol, error: error)
    }
}
