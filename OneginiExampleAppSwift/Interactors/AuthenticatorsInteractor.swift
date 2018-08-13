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

protocol AuthenticatorsInteractorProtocol {
    func authenticatorsListForAuthenticatedUserProfile() -> Array<ONGAuthenticator>
    func registerAuthenticator(_ authenticator: ONGAuthenticator)
    func deregisterAuthenticator(_ authenticator: ONGAuthenticator)
    func handleLogin(registerAuthenticatorEntity: PinViewControllerEntityProtocol)
}

class AuthenticatorsInteractor: NSObject {

    var registerAuthenticatorEntity = RegisterAuthenticatorEntity()
    weak var authenticatorsPresenter: AuthenticatorsInteractorToPresenterProtocol?

    
    fileprivate func mapErrorFromChallenge(_ challenge: ONGPinChallenge) {
        if let error = challenge.error {
            registerAuthenticatorEntity.pinError = ErrorMapper().mapError(error, pinChallenge: challenge)
        } else {
            registerAuthenticatorEntity.pinError = nil
        }
    }
}

extension AuthenticatorsInteractor: AuthenticatorsInteractorProtocol {
    func authenticatorsListForAuthenticatedUserProfile() -> Array<ONGAuthenticator> {
        let userClient = ONGUserClient.sharedInstance()
        guard let authenticatedUserProfile = userClient.authenticatedUserProfile() else { return [] }
        let authenticatros = userClient.allAuthenticators(forUser: authenticatedUserProfile)
        return Array(authenticatros)
    }
    
    func registerAuthenticator(_ authenticator: ONGAuthenticator) {
        ONGUserClient.sharedInstance().register(authenticator, delegate: self)
    }
    
    func deregisterAuthenticator(_ authenticator: ONGAuthenticator) {
        ONGUserClient.sharedInstance().deregister(authenticator, delegate: self)
    }
    
    func handleLogin(registerAuthenticatorEntity: PinViewControllerEntityProtocol) {
        guard let pinChallenge = self.registerAuthenticatorEntity.pinChallenge else { return }
        if let pin = registerAuthenticatorEntity.pin {
            pinChallenge.sender.respond(withPin: pin, challenge: pinChallenge)
        } else {
            pinChallenge.sender.cancel(pinChallenge)
        }
    }
}

extension AuthenticatorsInteractor: ONGAuthenticatorRegistrationDelegate {
    
    func userClient(_ userClient: ONGUserClient, didReceive challenge: ONGPinChallenge) {
        registerAuthenticatorEntity.pinChallenge = challenge
        registerAuthenticatorEntity.pinLength = 5
        mapErrorFromChallenge(challenge)
        authenticatorsPresenter?.presentPinView(registerAuthenticatorEntity: registerAuthenticatorEntity)
    }
    
    func userClient(_ userClient: ONGUserClient, didReceive challenge: ONGCustomAuthFinishRegistrationChallenge) {
        
    }
    
    func userClient(_ userClient: ONGUserClient, didFailToRegister authenticator: ONGAuthenticator, forUser userProfile: ONGUserProfile, error: Error) {
        
    }
    
    func userClient(_ userClient: ONGUserClient, didRegister authenticator: ONGAuthenticator, forUser userProfile: ONGUserProfile, info customAuthInfo: ONGCustomInfo?) {
        authenticatorsPresenter?.popToAuthenticatorsView()
    }
    
}

extension AuthenticatorsInteractor: ONGAuthenticatorDeregistrationDelegate {

    func userClient(_ userClient: ONGUserClient, didDeregister authenticator: ONGAuthenticator, forUser userProfile: ONGUserProfile) {
        authenticatorsPresenter?.authenticatorDeregistrationSucced()
    }

}
