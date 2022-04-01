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
import OneginiSDKiOS

protocol AuthenticatorsInteractorProtocol: AnyObject {
    func authenticatorsListForAuthenticatedUserProfile() -> Array<Authenticator>
    func registerAuthenticator(_ authenticator: Authenticator)
    func deregisterAuthenticator(_ authenticator: Authenticator)
    func handleLogin()
    func setPreferredAuthenticator(_ authenticator: Authenticator)
    func handlePasswordAuthenticatorRegistration()
}

class AuthenticatorsInteractor: NSObject {
    var registerAuthenticatorEntity = RegisterAuthenticatorEntity()
    weak var authenticatorsPresenter: AuthenticatorsInteractorToPresenterProtocol?
    private let userClient: UserClient = sharedUserClient() //TODO pass in the init
    
    fileprivate func mapErrorFromChallenge(_ challenge: PinChallenge) {
        if let error = challenge.error {
            registerAuthenticatorEntity.pinError = ErrorMapper().mapError(error, pinChallenge: challenge)
        } else {
            registerAuthenticatorEntity.pinError = nil
        }
    }

    fileprivate func sortAuthenticatorsList(_ authenticators: Array<Authenticator>) -> Array<Authenticator> {
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
            customAuthenticatorChallenge.sender.respond(withData: registerAuthenticatorEntity.data, challenge: customAuthenticatorChallenge)
        }
    }
}

extension AuthenticatorsInteractor: AuthenticatorsInteractorProtocol {
    func authenticatorsListForAuthenticatedUserProfile() -> Array<Authenticator> {
        guard let authenticatedUserProfile = userClient.authenticatedUserProfile else { return [] }
        return sortAuthenticatorsList(userClient.allAuthenticators(userProfile: authenticatedUserProfile))
    }

    func registerAuthenticator(_ authenticator: Authenticator) {
        userClient.register(authenticator: authenticator, delegate: self)
    }

    func deregisterAuthenticator(_ authenticator: Authenticator) {
        userClient.deregister(authenticator: authenticator, delegate: self)
    }

    func handleLogin() {
        guard let pinChallenge = registerAuthenticatorEntity.pinChallenge else { return }
        if let pin = registerAuthenticatorEntity.pin {
            pinChallenge.sender.respond(withPin: pin, challenge: pinChallenge)
        } else {
            pinChallenge.sender.cancel(pinChallenge)
        }
    }

    func setPreferredAuthenticator(_ authenticator: Authenticator) {
        userClient.setPreferredAuthenticator(authenticator)
    }
}

extension AuthenticatorsInteractor: AuthenticatorRegistrationDelegate {
    func userClient(_ userClient: UserClient, didReceive challenge: PinChallenge) {
//    func userClient(_: UserClient, didReceive challenge: PinChallenge) {
        registerAuthenticatorEntity.pinChallenge = challenge
        registerAuthenticatorEntity.pinLength = 5
        mapErrorFromChallenge(challenge)
        authenticatorsPresenter?.presentPinView(registerAuthenticatorEntity: registerAuthenticatorEntity)
    }

    func userClient(_: UserClient, didReceive challenge: CustomAuthFinishRegistrationChallenge) {
        registerAuthenticatorEntity.customAuthenticatorRegistrationChallenege = challenge
        authenticatorsPresenter?.presentCustomAuthenticatorRegistrationView(registerAuthenticatorEntity: registerAuthenticatorEntity)
    }

    func userClient(_: UserClient, didFailToRegister authenticator: Authenticator, forUser _: UserProfile, error: Error) {
        let mappedError = ErrorMapper().mapError(error)
        if error.code == ONGGenericError.actionCancelled.rawValue {
            authenticatorsPresenter?.authenticatorActionCancelled(authenticator: authenticator)
        } else if error.code == ONGGenericError.userDeregistered.rawValue {
            authenticatorsPresenter?.popToWelcomeView(mappedError)
        } else {
            authenticatorsPresenter?.authenticatorActionFailed(mappedError, authenticator: authenticator)
        }
    }

    func userClient(_: UserClient, didRegister authenticator: Authenticator, forUser _: UserProfile, info _: CustomInfo?) {
        authenticatorsPresenter?.backToAuthenticatorsView(authenticator: authenticator)
    }
}

extension AuthenticatorsInteractor: AuthenticatorDeregistrationDelegate {
    func userClient(_ userClient: UserClient, didDeregister authenticator: Authenticator, forUser userProfile: UserProfile) {
        authenticatorsPresenter?.authenticatorDeregistrationSucced()
    }

    func userClient(_ userClient: UserClient, didFailToDeregister authenticator: Authenticator, forUser userProfile: UserProfile, error: Error) {
        if error.code == ONGGenericError.actionCancelled.rawValue {
            authenticatorsPresenter?.authenticatorActionCancelled(authenticator: authenticator)
        } else {
            let mappedError = ErrorMapper().mapError(error)
            authenticatorsPresenter?.authenticatorActionFailed(mappedError, authenticator: authenticator)
        }
    }

    func userClient(_ userClient: UserClient, didReceive challenge: CustomAuthDeregistrationChallenge) {
        challenge.sender.continue(with: challenge)
    }
}
