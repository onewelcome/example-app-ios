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

protocol RegisterUserInteractorProtocol {
    func identityProviders() -> Array<ONGIdentityProvider>
    func startUserRegistration()
    func handleRedirectURL(registerUserEntity: BrowserViewControllerEntityProtocol)
    func handleCreatedPin(registerUserEntity: PinViewControllerEntityProtocol)
}

class RegisterUserInteractor: NSObject, RegisterUserInteractorProtocol {
    weak var registerUserPresenter: RegisterUserInteractorToPresenterProtocol?
    var registerUserEntity = RegisterUserEntity()

    func identityProviders() -> Array<ONGIdentityProvider> {
        let identityProviders = ONGUserClient.sharedInstance().identityProviders()
        return Array(identityProviders)
    }

    func startUserRegistration() {
        ONGUserClient.sharedInstance().registerUser(with: nil, scopes: ["read"], delegate: self)
    }

    func handleRedirectURL(registerUserEntity: BrowserViewControllerEntityProtocol) {
        guard let browserRegistrationChallenge = registerUserEntity.browserRegistrationChallenge else { return }
        if let url = registerUserEntity.redirectURL {
            browserRegistrationChallenge.sender.respond(with: url, challenge: browserRegistrationChallenge)
        } else {
            browserRegistrationChallenge.sender.cancel(browserRegistrationChallenge)
        }
    }

    func handleCreatedPin(registerUserEntity: PinViewControllerEntityProtocol) {
        guard let createPinChallenge = self.registerUserEntity.createPinChallenge else { return }
        if let pin = registerUserEntity.pin {
            createPinChallenge.sender.respond(withCreatedPin: pin, challenge: createPinChallenge)
        } else {
            createPinChallenge.sender.cancel(createPinChallenge)
        }
    }
}

extension RegisterUserInteractor: ONGRegistrationDelegate {
    func userClient(_: ONGUserClient, didReceive challenge: ONGBrowserRegistrationChallenge) {
        registerUserEntity.browserRegistrationChallenge = challenge
        registerUserEntity.registrationUserURL = challenge.url
        registerUserPresenter?.presentBrowserUserRegistrationView(regiserUserEntity: registerUserEntity)
    }

    func userClient(_: ONGUserClient, didReceivePinRegistrationChallenge challenge: ONGCreatePinChallenge) {
        registerUserEntity.createPinChallenge = challenge
        registerUserEntity.pinLength = Int(challenge.pinLength)
        registerUserPresenter?.presentCreatePinView(registerUserEntity: registerUserEntity)
    }

    func userClient(_: ONGUserClient, didRegisterUser _: ONGUserProfile, info _: ONGCustomInfo?) {
        registerUserPresenter?.presentDashboardView()
    }

    func userClient(_: ONGUserClient, didFailToRegisterWithError error: Error) {
        registerUserPresenter?.presentError(error)
    }
}
