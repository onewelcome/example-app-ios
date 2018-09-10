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
    func userProfiles() -> Array<ONGUserProfile>
    func authenticators(profile: ONGUserProfile) -> Array<ONGAuthenticator>
    func login(profile: ONGUserProfile)
    func handleLogin()
    func handlePasswordAuthenticatorLogin()
}

class LoginInteractor: NSObject {
    weak var loginPresenter: LoginInteractorToPresenterProtocol?
    var loginEntity = LoginEntity()

    fileprivate func mapErrorFromChallenge(_ challenge: ONGPinChallenge) {
        if let error = challenge.error, error.code != ONGAuthenticationError.touchIDAuthenticatorFailure.rawValue {
            loginEntity.pinError = ErrorMapper().mapError(error, pinChallenge: challenge)
        } else {
            loginEntity.pinError = nil
        }
    }

    func handlePasswordAuthenticatorLogin() {
        guard let customAuthenticatorChallenge = loginEntity.customAuthenticatorAuthenticationChallenege else { fatalError() }
        if loginEntity.cancelled {
            loginEntity.cancelled = false
            customAuthenticatorChallenge.sender.cancel(customAuthenticatorChallenge, underlyingError: nil)
        } else {
            if let data = loginEntity.data {
                customAuthenticatorChallenge.sender.respond(withData: data, challenge: customAuthenticatorChallenge)
            } else {
                customAuthenticatorChallenge.sender.respond(withData: "", challenge: customAuthenticatorChallenge)
            }
        }
    }
}

extension LoginInteractor: LoginInteractorProtocol {
    func userProfiles() -> Array<ONGUserProfile> {
        let userProfiles = ONGUserClient.sharedInstance().userProfiles()
        return Array(userProfiles)
    }

    func authenticators(profile: ONGUserProfile) -> Array<ONGAuthenticator> {
        let authenticators = ONGUserClient.sharedInstance().registeredAuthenticators(forUser: profile)
        return Array(authenticators)
    }

    func login(profile: ONGUserProfile) {
        ONGUserClient.sharedInstance().authenticateUser(profile, delegate: self)
    }

    func handleLogin() {
        guard let pinChallenge = loginEntity.pinChallenge else { return }
        if let pin = loginEntity.pin {
            pinChallenge.sender.respond(withPin: pin, challenge: pinChallenge)
        } else {
            pinChallenge.sender.cancel(pinChallenge)
        }
    }
}

extension LoginInteractor: ONGAuthenticationDelegate {
    func userClient(_: ONGUserClient, didReceive challenge: ONGPinChallenge) {
        loginEntity.pinChallenge = challenge
        loginEntity.pinLength = 5
        mapErrorFromChallenge(challenge)
        loginPresenter?.presentPinView(loginEntity: loginEntity)
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGCustomAuthFinishAuthenticationChallenge) {
        loginEntity.customAuthenticatorAuthenticationChallenege = challenge
        loginPresenter?.presentPasswordAuthenticatorView(loginEnity: loginEntity)
    }

    func userClient(_: ONGUserClient, didAuthenticateUser userProfile: ONGUserProfile, info _: ONGCustomInfo?) {
        loginPresenter?.presentDashboardView(authenticatedUserProfile: userProfile)
    }

    func userClient(_: ONGUserClient, didFailToAuthenticateUser profile: ONGUserProfile, error: Error) {
        if error.code == ONGGenericError.actionCancelled.rawValue {
            loginPresenter?.loginActionCancelled(profile: profile)
        } else {
            let mappedError = ErrorMapper().mapError(error)
            loginPresenter?.loginActionFailed(mappedError, profile: profile)
        }
    }
}
