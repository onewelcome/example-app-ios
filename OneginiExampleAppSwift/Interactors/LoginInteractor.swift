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
    func handleLogin(loginEntity: PinViewControllerEntityProtocol)
}

class LoginInteractor: NSObject, LoginInteractorProtocol {
    weak var loginPresenter: LoginInteractorToPresenterProtocol?
    var loginEntity = LoginEntity()

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

    func handleLogin(loginEntity: PinViewControllerEntityProtocol) {
        guard let pinChallenge = self.loginEntity.pinChallenge else { return }
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
        loginEntity.pinError = challenge.error
        loginPresenter?.presentPinView(loginEntity: loginEntity)
    }

    func userClient(_: ONGUserClient, didAuthenticateUser userProfile: ONGUserProfile, info customAuthInfo: ONGCustomInfo?) {
        loginPresenter?.presentDashboardView()
    }

    func userClient(_: ONGUserClient, didFailToAuthenticateUser userProfile: ONGUserProfile, error: Error) {
        if error.code != ONGGenericError.actionCancelled.rawValue {
            loginPresenter?.loginActionFailed(error)
        } else {
            loginPresenter?.loginActionFailed(nil)
        }
    }
}
