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

@objc protocol LoginClientProtocol {
    @objc func userProfilesArray() -> Array<NSObject & UserProfileProtocol>
    func registeredAuthenticatorsArray(forUser: NSObject & UserProfileProtocol) -> Array<ONGAuthenticator>
    func authenticateUser(profile: NSObject & UserProfileProtocol, delegate: NSObject & LoginDelegate)
}

protocol LoginInteractorProtocol {
    func userProfiles() -> Array<NSObject & UserProfileProtocol>
    func authenticators(profile: NSObject & UserProfileProtocol) -> Array<ONGAuthenticator>
    func login(profile: NSObject & UserProfileProtocol)
    func handleLogin(loginEntity: PinViewControllerEntityProtocol)
}

class LoginInteractor: NSObject {
    private let loginEntity : LoginEntity
    private let userClient : LoginClientProtocol
    private let errorMapper : ErrorMapper
    public weak var delegate: LoginInteractorToPresenterProtocol?

    func isEmpty(xs: Array<String>) -> Bool {
        return xs.count == 0
    }
    
    init(userClient : LoginClientProtocol, errorMapper : ErrorMapper, loginEntity : LoginEntity){
        self.userClient = userClient
        self.errorMapper = errorMapper
        self.loginEntity = loginEntity
    }
    
    fileprivate func mapErrorFromChallenge(_ challenge: PinChallengeProtocol) {
        if let error = challenge.error {
            loginEntity.pinError = errorMapper.mapError(error, pinChallenge: challenge)
        } else {
            loginEntity.pinError = nil
        }
    }
}

extension LoginInteractor: LoginInteractorProtocol {
    func userProfiles() -> Array<NSObject & UserProfileProtocol> {
        return userClient.userProfilesArray()
    }

    func authenticators(profile: NSObject & UserProfileProtocol) -> Array<ONGAuthenticator> {
        let authenticators = userClient.registeredAuthenticatorsArray(forUser: profile)
        return Array(authenticators)
    }

    func login(profile: NSObject & UserProfileProtocol) {
        self.userClient.authenticateUser(profile: profile, delegate: self)
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

extension LoginInteractor: LoginDelegate {
    func userClient1(_ loginClient: LoginClientProtocol, didReceive challenge: PinChallengeProtocol) {
        loginEntity.pinChallenge = challenge
        loginEntity.pinLength = 5
        mapErrorFromChallenge(challenge)
        delegate?.presentPinView(loginEntity: loginEntity)
    }
    
    func userClient2(_ loginClient: LoginClientProtocol, didAuthenticateUser _: UserProfileProtocol, info _: CustomInfoProtocol?) {
        delegate?.presentDashboardView()
    }
    func userClient3(_ loginClient: LoginClientProtocol, didFailToAuthenticateUser _: UserProfileProtocol, error: Error) {
        if error.code == ONGGenericError.actionCancelled.rawValue {
            delegate?.loginActionCancelled()
        } else {
            let mappedError = errorMapper.mapError(error)
            delegate?.loginActionFailed(mappedError)
        }
    }
}
