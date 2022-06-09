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

protocol LoginInteractorProtocol: AnyObject {
    func userProfiles() -> Array<UserProfile>
    func authenticators(profile: UserProfile) -> Array<Authenticator>
    func login(profile: UserProfile, authenticator: Authenticator?)
    func handleLogin()
    func handlePasswordAuthenticatorLogin()
}

protocol LoginInteractorDelegate: AnyObject {
    func loginInteractor(_ loginInteractor: LoginInteractorProtocol, didAskForPin loginEntity: LoginEntity)
    func loginInteractor(_ loginInteractor: LoginInteractorProtocol, didAskForPassword loginEntity: LoginEntity)
    func loginInteractor(_ loginInteractor: LoginInteractorProtocol, didLoginUser profile: UserProfile)
    func loginInteractor(_ loginInteractor: LoginInteractorProtocol, didFailToLoginUser profile: UserProfile, withError error: AppError)
    func loginInteractor(_ loginInteractor: LoginInteractorProtocol, didCancelLoginUser profile: UserProfile)
}

class LoginInteractor: NSObject, LoginInteractorProtocol {
    weak var delegate: LoginInteractorDelegate?
    var loginEntity = LoginEntity()
    private var userClient: UserClient {
        return SharedUserClient.instance
    }

    fileprivate func mapErrorFromChallenge(_ challenge: PinChallenge) {
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
            customAuthenticatorChallenge.sender.respond(with: loginEntity.data, to: customAuthenticatorChallenge)
        }
    }

    func userProfiles() -> [UserProfile] {
        return userClient.userProfiles
    }

    func authenticators(profile: UserProfile) -> [Authenticator] {
        return userClient.authenticators(.registered, for: profile)
    }

    func login(profile: UserProfile, authenticator: Authenticator? = nil) {
        userClient.authenticateUserWith(profile: profile, authenticator: authenticator, delegate: self)
    }

    func handleLogin() {
        guard let pinChallenge = loginEntity.pinChallenge else { return }
        if let pin = loginEntity.pin {
            pinChallenge.sender.respond(with: pin, to: pinChallenge)
        } else {
            pinChallenge.sender.cancel(pinChallenge)
        }
    }
}

extension LoginInteractor: AuthenticationDelegate {
    func userClient(_: UserClient, didReceivePinChallenge challenge: PinChallenge) {
        loginEntity.pinChallenge = challenge
        loginEntity.pinLength = 5
        mapErrorFromChallenge(challenge)
        delegate?.loginInteractor(self, didAskForPin: loginEntity)
    }

    func userClient(_: UserClient, didReceive challenge: CustomAuthFinishAuthenticationChallenge) {
        loginEntity.customAuthenticatorAuthenticationChallenege = challenge
        delegate?.loginInteractor(self, didAskForPassword: loginEntity)
    }

    func userClient(_ userClient: UserClient, didAuthenticateUser userProfile: UserProfile, authenticator: Authenticator, info customAuthInfo: CustomInfo?) {
        delegate?.loginInteractor(self, didLoginUser: userProfile)
    }

    func userClient(_ userClient: UserClient, didFailToAuthenticateUser userProfile: UserProfile, authenticator: Authenticator, error: Error) {
        if error.code == ONGGenericError.actionCancelled.rawValue {
            delegate?.loginInteractor(self, didCancelLoginUser: userProfile)
        } else {
            let mappedError = ErrorMapper().mapError(error)
            delegate?.loginInteractor(self, didFailToLoginUser: userProfile, withError: mappedError)
        }
    }
}
