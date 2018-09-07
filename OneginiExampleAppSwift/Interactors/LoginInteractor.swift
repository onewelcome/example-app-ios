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

import UIKit

protocol LoginInteractorProtocol {
    func userProfiles() -> Array<NSObject & UserProfileProtocol>
    func authenticators(profile: NSObject & UserProfileProtocol) -> Array<NSObject & AuthenticatorProtocol>
    func login(profile: NSObject & UserProfileProtocol)
    func handleLogin(loginEntity: PinViewControllerEntityProtocol)
}

class LoginInteractor: NSObject {
    private let loginEntity : LoginEntity
    private let userClient : ONGUserClient
    private let errorMapper : ErrorMapper
    fileprivate var pinChallenge : ONGPinChallenge?
    public weak var delegate: LoginInteractorToPresenterProtocol?
    
    init(userClient : ONGUserClient, errorMapper : ErrorMapper, loginEntity : LoginEntity){
        self.userClient = userClient
        self.errorMapper = errorMapper
        self.loginEntity = loginEntity
    }
    
    fileprivate func mapErrorFromChallenge(_ challenge: ONGPinChallenge) {
        if let error = challenge.error {
            loginEntity.pinError = errorMapper.mapError(error, remainingFailureCount: challenge.remainingFailureCount)
        } else {
            loginEntity.pinError = nil
        }
    }
}

extension LoginInteractor: LoginInteractorProtocol {
    func userProfiles() -> Array<NSObject & UserProfileProtocol> {
        return Array(userClient.userProfiles())
    }

    func authenticators(profile: NSObject & UserProfileProtocol) -> Array<NSObject & AuthenticatorProtocol> {
        let authenticators = userClient.registeredAuthenticators(forUser: profile as! ONGUserProfile)
        return Array(authenticators)
    }

    func login(profile: NSObject & UserProfileProtocol) {
        userClient.authenticateUser(profile as! ONGUserProfile, delegate: self)
    }

    func handleLogin(loginEntity: PinViewControllerEntityProtocol) {
        guard let pinChallenge = self.pinChallenge else { return }
        if let pin = loginEntity.pin {
            pinChallenge.sender.respond(withPin: pin, challenge: pinChallenge)
        } else {
            pinChallenge.sender.cancel(pinChallenge)
        }
    }
}

extension LoginInteractor: ONGAuthenticationDelegate {
    func userClient(_ userClient: ONGUserClient, didReceive challenge: ONGPinChallenge) {
        pinChallenge = challenge
        loginEntity.pinLength = 5
        mapErrorFromChallenge(challenge)
        delegate?.presentPinView(loginEntity: loginEntity)
    }
    
    func userClient(_ userClient: ONGUserClient, didAuthenticateUser userProfile: ONGUserProfile, info: ONGCustomInfo?) {
        delegate?.presentDashboardView()
    }
    
    func userClient(_ userClient: ONGUserClient, didFailToAuthenticateUser userProfile: ONGUserProfile, error: Error) {
        if error.code == ONGGenericError.actionCancelled.rawValue {
            delegate?.loginActionCancelled()
        } else {
            let mappedError = errorMapper.mapError(error)
            delegate?.loginActionFailed(mappedError)
        }
    }
}
