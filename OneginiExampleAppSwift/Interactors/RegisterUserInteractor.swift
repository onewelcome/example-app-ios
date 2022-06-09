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

protocol RegisterUserInteractorProtocol: AnyObject {
    var identityProviders: [IdentityProvider] { get }
    func startUserRegistration(identityProvider: IdentityProvider?)
    func handleRedirectURL()
    func handleCreatedPin()
    func handleOTPCode()
    func handleQRCode(_ qrCode: String?)
}

class RegisterUserInteractor: NSObject {
    weak var registerUserPresenter: RegisterUserInteractorToPresenterProtocol?
    var registerUserEntity = RegisterUserEntity()
    private var userClient: UserClient {
        return SharedUserClient.instance
    }

    fileprivate func mapErrorFromChallenge(_ challenge: CreatePinChallenge) {
        if let error = challenge.error {
            registerUserEntity.pinError = ErrorMapper().mapError(error)
        } else {
            registerUserEntity.pinError = nil
        }
    }
}

extension RegisterUserInteractor: RegisterUserInteractorProtocol {
    var identityProviders: [IdentityProvider] {
        return userClient.identityProviders
    }

    func startUserRegistration(identityProvider: IdentityProvider? = nil) {
        userClient.registerUserWith(identityProvider: identityProvider, scopes: ["read", "openid"], delegate: self)
    }

    func handleRedirectURL() {
        guard let browserRegistrationChallenge = registerUserEntity.browserRegistrationChallenge else { return }
        if let url = registerUserEntity.redirectURL {
            browserRegistrationChallenge.sender.respond(with: url, to: browserRegistrationChallenge)
        } else {
            browserRegistrationChallenge.sender.cancel(browserRegistrationChallenge)
        }
    }

    func handleOTPCode() {
        guard let customRegistrationChallenge = registerUserEntity.customRegistrationChallenge else { return }
        if registerUserEntity.cancelled {
            registerUserEntity.cancelled = false
            customRegistrationChallenge.sender.cancel(customRegistrationChallenge)
        } else {
            customRegistrationChallenge.sender.respond(with: registerUserEntity.responseCode, to: customRegistrationChallenge)
        }
    }

    func handleQRCode(_ qrCode: String?) {
        guard let customRegistrationChallenge = registerUserEntity.customRegistrationChallenge else { return }
        if let qrCode = qrCode {
            customRegistrationChallenge.sender.respond(with: qrCode, to: customRegistrationChallenge)
        } else {
            customRegistrationChallenge.sender.cancel(customRegistrationChallenge)
        }
    }

    func handleCreatedPin() {
        guard let createPinChallenge = registerUserEntity.createPinChallenge else { return }
        if let pin = registerUserEntity.pin {
            createPinChallenge.sender.respond(with: pin, to: createPinChallenge)
        } else {
            createPinChallenge.sender.cancel(createPinChallenge)
        }
    }

    fileprivate func mapErrorMessageFromTwoWayOTPStatus(_ status: Int) {
        if status == 2000 {
            registerUserEntity.errorMessage = nil
        } else if status == 4002 {
            registerUserEntity.errorMessage = "This code is not initialized on portal."
        } else {
            registerUserEntity.errorMessage = "Provided code is incorrect."
        }
    }

    fileprivate func mapErrorMessageFromQRCodeStatus(_ status: Int) {
        if status == 2000 {
            registerUserEntity.errorMessage = nil
        } else {
            registerUserEntity.errorMessage = "QR code is not valid."
        }
    }

    fileprivate func mapErrorMessageFromStatus(_ status: Int, identityProviderIdentifier: String) {
        if identityProviderIdentifier == "2-way-otp-api" {
            mapErrorMessageFromTwoWayOTPStatus(status)
        } else if identityProviderIdentifier == "qr-code-api" {
            mapErrorMessageFromQRCodeStatus(status)
        }
    }
}

extension RegisterUserInteractor: RegistrationDelegate {
    func userClient(_ userClient: UserClient, didReceiveCreatePinChallenge createPinChallenge: CreatePinChallenge) {
        registerUserEntity.createPinChallenge = createPinChallenge
        registerUserEntity.pinLength = Int(createPinChallenge.pinLength)
        mapErrorFromChallenge(createPinChallenge)
        registerUserPresenter?.presentCreatePinView(registerUserEntity: registerUserEntity)
    }

    func userClient(_ userClient: UserClient, didReceiveBrowserRegistrationChallenge browserRegistrationChallenge: BrowserRegistrationChallenge) {
        registerUserEntity.browserRegistrationChallenge = browserRegistrationChallenge
        registerUserEntity.registrationUserURL = browserRegistrationChallenge.url
        registerUserPresenter?.presentBrowserUserRegistrationView(regiserUserEntity: registerUserEntity)
    }

    func userClient(_ userClient: UserClient, didReceiveCustomRegistrationInitChallenge challenge: CustomRegistrationChallenge) {
        if challenge.identityProvider.identifier == "2-way-otp-api" {
            challenge.sender.respond(with: nil, to: challenge)
        }
    }

    func userClient(_ userClient: UserClient, didReceiveCustomRegistrationFinish challenge: CustomRegistrationChallenge) {
        registerUserEntity.customRegistrationChallenge = challenge
        if let info = challenge.info {
            registerUserEntity.challengeCode = info.data
            mapErrorMessageFromStatus(info.status, identityProviderIdentifier: challenge.identityProvider.identifier)
        }
        if challenge.identityProvider.identifier == "2-way-otp-api" {
            registerUserPresenter?.presentTwoWayOTPRegistrationView(regiserUserEntity: registerUserEntity)
        } else if challenge.identityProvider.identifier == "qr-code-api" {
            registerUserPresenter?.presentQRCodeRegistrationView(registerUserEntity: registerUserEntity)
        }
    }

    func userClient(_ userClient: UserClient, didRegisterUser userProfile: UserProfile, with identityProvider: IdentityProvider, info: CustomInfo?) {
        registerUserPresenter?.presentDashboardView(authenticatedUserProfile: userProfile)
    }

    func userClient(_ userClient: UserClient, didFailToRegisterUserWith identityProvider: IdentityProvider, error: Error) {
        if error.code == ONGGenericError.actionCancelled.rawValue {
            registerUserPresenter?.registerUserActionCancelled()
        } else {
            let mappedError = ErrorMapper().mapError(error)
            registerUserPresenter?.registerUserActionFailed(mappedError)
        }
        registerUserEntity.errorMessage = nil
    }
}
