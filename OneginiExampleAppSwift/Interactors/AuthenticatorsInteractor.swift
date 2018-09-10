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
    func handleLogin()
    func setPreferredAuthenticator(_ authenticator: ONGAuthenticator)
    func handlePasswordAuthenticatorRegistration()
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

    fileprivate func sortAuthenticatorsList(_ authenticators: Array<ONGAuthenticator>) -> Array<ONGAuthenticator> {
        return authenticators.sorted {
            if $0.type.rawValue == $1.type.rawValue {
                return $0.name < $1.name
            } else {
                return $0.type.rawValue < $1.type.rawValue
            }
        }
    }

    func handlePasswordAuthenticatorRegistration() {
        guard let customAuthenticatorChallenge = registerAuthenticatorEntity.customAuthenticatorRegistrationChallenege else { fatalError() }
        if registerAuthenticatorEntity.cancelled {
            registerAuthenticatorEntity.cancelled = false
            customAuthenticatorChallenge.sender.cancel(customAuthenticatorChallenge, underlyingError: nil)
        } else {
            if let data = registerAuthenticatorEntity.data {
                customAuthenticatorChallenge.sender.respond(withData: data, challenge: customAuthenticatorChallenge)
            } else {
                customAuthenticatorChallenge.sender.respond(withData: "", challenge: customAuthenticatorChallenge)
            }
        }
    }
}

extension AuthenticatorsInteractor: AuthenticatorsInteractorProtocol {
    func authenticatorsListForAuthenticatedUserProfile() -> Array<ONGAuthenticator> {
        let userClient = ONGUserClient.sharedInstance()
        guard let authenticatedUserProfile = userClient.authenticatedUserProfile() else { return [] }
        let authenticatros = userClient.allAuthenticators(forUser: authenticatedUserProfile)
        return sortAuthenticatorsList(Array(authenticatros))
    }

    func registerAuthenticator(_ authenticator: ONGAuthenticator) {
        ONGUserClient.sharedInstance().register(authenticator, delegate: self)
    }

    func deregisterAuthenticator(_ authenticator: ONGAuthenticator) {
        ONGUserClient.sharedInstance().deregister(authenticator, delegate: self)
    }

    func handleLogin() {
        guard let pinChallenge = registerAuthenticatorEntity.pinChallenge else { return }
        if let pin = registerAuthenticatorEntity.pin {
            pinChallenge.sender.respond(withPin: pin, challenge: pinChallenge)
        } else {
            pinChallenge.sender.cancel(pinChallenge)
        }
    }

    func setPreferredAuthenticator(_ authenticator: ONGAuthenticator) {
        ONGUserClient.sharedInstance().preferredAuthenticator = authenticator
    }
}

extension AuthenticatorsInteractor: ONGAuthenticatorRegistrationDelegate {
    func userClient(_: ONGUserClient, didReceive challenge: ONGPinChallenge) {
        registerAuthenticatorEntity.pinChallenge = challenge
        registerAuthenticatorEntity.pinLength = 5
        mapErrorFromChallenge(challenge)
        authenticatorsPresenter?.presentPinView(registerAuthenticatorEntity: registerAuthenticatorEntity)
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGCustomAuthFinishRegistrationChallenge) {
        registerAuthenticatorEntity.customAuthenticatorRegistrationChallenege = challenge
        authenticatorsPresenter?.presentCustomAuthenticatorRegistrationView(registerAuthenticatorEntity: registerAuthenticatorEntity)
    }

    func userClient(_: ONGUserClient, didFailToRegister authenticator: ONGAuthenticator, forUser _: ONGUserProfile, error: Error) {
        if error.code == ONGGenericError.actionCancelled.rawValue {
            authenticatorsPresenter?.authenticatorActionCancelled(authenticator: authenticator)
        } else {
            let mappedError = ErrorMapper().mapError(error)
            authenticatorsPresenter?.authenticatorActionFailed(mappedError, authenticator: authenticator)
        }
    }

    func userClient(_: ONGUserClient, didRegister authenticator: ONGAuthenticator, forUser _: ONGUserProfile, info _: ONGCustomInfo?) {
        authenticatorsPresenter?.backToAuthenticatorsView(authenticator: authenticator)
    }
}

extension AuthenticatorsInteractor: ONGAuthenticatorDeregistrationDelegate {
    func userClient(_: ONGUserClient, didDeregister _: ONGAuthenticator, forUser _: ONGUserProfile) {
        authenticatorsPresenter?.authenticatorDeregistrationSucced()
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGCustomAuthDeregistrationChallenge) {
        challenge.sender.continue(with: challenge)
    }

    func userClient(_: ONGUserClient, didFailToDeregister authenticator: ONGAuthenticator, forUser _: ONGUserProfile, error: Error) {
        if error.code == ONGGenericError.actionCancelled.rawValue {
            authenticatorsPresenter?.authenticatorActionCancelled(authenticator: authenticator)
        } else {
            let mappedError = ErrorMapper().mapError(error)
            authenticatorsPresenter?.authenticatorActionFailed(mappedError, authenticator: authenticator)
        }
    }
}
