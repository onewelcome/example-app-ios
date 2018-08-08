//
//  ONGUserClientStub.swift
//  OneginiExampleAppSwiftTests
//
//  Created by Stanisław Brzeski on 30/07/2018.
//  Copyright © 2018 Onegini. All rights reserved.
//

import UIKit
@testable import OneginiExampleAppSwift

class CustomInfoStub : CustomInfoProtocol{
    var status: Int
    var data: String
    init(_ status: Int, _ data: String) {
        self.status = status
        self.data = data
    }
}

class PinChallengeStub : NSObject & PinChallengeProtocol {
    var sender: ONGPinChallengeSender
    
    var userProfileProtocol: NSObject & UserProfileProtocol
    
    var maxFailureCount: UInt = 0
    
    var previousFailureCount: UInt
    
    var remainingFailureCount: UInt
    
    var error: Error?
    
    init(_ profile : NSObject & UserProfileProtocol, _ maxFailureCount : UInt, _ previousFailureCount : UInt, _ remainingFailureCount : UInt, _ error : Error?, _ sender: ONGPinChallengeSender) {
        self.userProfileProtocol = profile
        self.maxFailureCount = maxFailureCount
        self.previousFailureCount = previousFailureCount
        self.remainingFailureCount = remainingFailureCount
        self.error = error
        self.sender = sender
    }
    
}

class UserProfileStub : NSObject & UserProfileProtocol {
    var profileId : String
    init(_ profileId: String) {
        self.profileId = profileId
    }
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? NSObject & UserProfileProtocol {
            return self.profileId == object.profileId
        } else {
            return false
        }
    }
}

class ONGUserClientStub : NSObject, LoginClientProtocol, ONGPinChallengeSender, PinChallengeSenderProtocol {
    let validPin = "11111"
    let invalidPin = "11112"
    var delegate : (NSObject & LoginDelegate)? = nil
    
    func userProfilesArray() -> Array<NSObject & UserProfileProtocol> {
        let profile1 = ONGUserProfile()
        profile1.profileId = "profile1"
        let profile2 = ONGUserProfile()
        profile2.profileId = "profile2"
        return Array(arrayLiteral: profile1, profile2)
    }
    
    func registeredAuthenticatorsArray(forUser: NSObject & UserProfileProtocol) -> Array<NSObject & AuthenticatorProtocol> {
        return Array()
    }
    
    func authenticateUser(profile: NSObject & UserProfileProtocol, delegate: NSObject & LoginDelegate) {
        let sender = self
        let pinChallenge = PinChallengeStub(profile, 5, 0, 5, nil, sender)
        self.delegate = delegate
        delegate.userClient(self, didReceive: pinChallenge)
    }
    
    func respond(withPin pin: String, challengeProtocol: NSObject & PinChallengeProtocol) {
        if(pin == validPin) {
            self.delegate?.userClient(self, didAuthenticateUser: challengeProtocol.userProfileProtocol, info: CustomInfoStub(2000, ""))
        } else {
            let error = NSError(domain: "domain", code: 0, userInfo: nil)
            self.delegate?.userClient(self, didFailToAuthenticateUser: challengeProtocol.userProfileProtocol, error: error)
        }
    }
    
    func cancel(challengeProtocol: PinChallengeProtocol) {
    }
    
    func respond(withPin pin: String, challenge: ONGPinChallenge) {
        if(pin == validPin) {
            self.delegate?.userClient(self, didAuthenticateUser: challenge.userProfileProtocol, info: CustomInfoStub(2000, ""))
        } else {
            let error = NSError(domain: "domain", code: 0, userInfo: nil)
            self.delegate?.userClient(self, didFailToAuthenticateUser: challenge.userProfileProtocol, error: error)
        }
    }
    
    func cancel(_ challenge: ONGPinChallenge) {
    }
}

class LoginPresenterStub : LoginInteractorToPresenterProtocol {
    var presentPinViewCalled : Bool = false
    var presentPinViewLoginEntity : LoginEntity?
    func presentPinView(loginEntity: LoginEntity) {
        self.presentPinViewCalled = true
        self.presentPinViewLoginEntity = loginEntity
    }
    var presentDashboardViewCalled : Bool = false
    func presentDashboardView() {
        self.presentDashboardViewCalled = true
    }
    var loginActionFailedCalled : Bool = false
    var loginActionFailedError : AppError?
    func loginActionFailed(_ error: AppError) {
        self.loginActionFailedCalled = true
        self.loginActionFailedError = error
    }
    var loginActionCancelledCalled : Bool = false
    func loginActionCancelled() {
        self.loginActionCancelledCalled = true
    }
}
