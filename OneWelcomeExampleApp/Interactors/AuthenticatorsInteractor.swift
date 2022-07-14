//
// Copyright (c) 2022 OneWelcome. All rights reserved.
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
    var authenticatorsListForAuthenticatedUserProfile: [Authenticator] { get }
    func registerAuthenticator(_ authenticator: Authenticator)
    func deregisterAuthenticator(_ authenticator: Authenticator)
    func handleLogin()
    func setPreferredAuthenticator(_ authenticator: Authenticator)
    func handlePasswordAuthenticatorRegistration()
}

class AuthenticatorsInteractor: NSObject {
    var registerAuthenticatorEntity = RegisterAuthenticatorEntity()
    weak var authenticatorsPresenter: AuthenticatorsInteractorToPresenterProtocol?
    private var userClient: UserClient {
        return SharedUserClient.instance
    }
    
    fileprivate func mapErrorFromChallenge(_ challenge: PinChallenge) {
        if let error = challenge.error {
            registerAuthenticatorEntity.pinError = ErrorMapper().mapError(error, pinChallenge: challenge)
        } else {
            registerAuthenticatorEntity.pinError = nil
        }
    }

    fileprivate func sortAuthenticatorsList(_ authenticators: [Authenticator]) -> [Authenticator] {
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
            customAuthenticatorChallenge.sender.respond(with: registerAuthenticatorEntity.data, to: customAuthenticatorChallenge)
        }
    }
}

extension AuthenticatorsInteractor: AuthenticatorsInteractorProtocol {
    var authenticatorsListForAuthenticatedUserProfile: [Authenticator] {
        guard let authenticatedUserProfile = userClient.authenticatedUserProfile else { return [] }
        let authenticators = userClient.authenticators(.all, for: authenticatedUserProfile)
        return sortAuthenticatorsList(authenticators)
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
            pinChallenge.sender.respond(with: pin, to: pinChallenge)
        } else {
            pinChallenge.sender.cancel(pinChallenge)
        }
    }

    func setPreferredAuthenticator(_ authenticator: Authenticator) {
        userClient.setPreferredAuthenticator(authenticator)
    }
}

extension AuthenticatorsInteractor: AuthenticatorRegistrationDelegate {
    func userClient(_ userClient: UserClient, didReceivePinChallenge challenge: PinChallenge) {
        registerAuthenticatorEntity.pinChallenge = challenge
        registerAuthenticatorEntity.pinLength = 5
        mapErrorFromChallenge(challenge)
        authenticatorsPresenter?.presentPinView(registerAuthenticatorEntity: registerAuthenticatorEntity)
    }

    func userClient(_: UserClient, didReceiveCustomAuthFinishRegistrationChallenge challenge: CustomAuthFinishRegistrationChallenge) {
        registerAuthenticatorEntity.customAuthenticatorRegistrationChallenege = challenge
        authenticatorsPresenter?.presentCustomAuthenticatorRegistrationView(registerAuthenticatorEntity: registerAuthenticatorEntity)
    }
    
    func userClient(_ userClient: UserClient, didFailToRegister authenticator: Authenticator, for userProfile: UserProfile, error: Error) {
        let mappedError = ErrorMapper().mapError(error)
        if error.code == ONGGenericError.actionCancelled.rawValue {
            authenticatorsPresenter?.authenticatorActionCancelled(authenticator: authenticator)
        } else if error.code == ONGGenericError.userDeregistered.rawValue {
            authenticatorsPresenter?.popToWelcomeView(mappedError)
        } else {
            authenticatorsPresenter?.authenticatorActionFailed(mappedError, authenticator: authenticator)
        }
    }
    
    func userClient(_ userClient: UserClient, didRegister authenticator: Authenticator, for userProfile: UserProfile, info customAuthInfo: CustomInfo?) {
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

    func userClient(_ userClient: UserClient, didReceiveCustomAuthDeregistrationChallenge challenge: CustomAuthDeregistrationChallenge) {
        challenge.sender.proceed(with: challenge)
    }
}
