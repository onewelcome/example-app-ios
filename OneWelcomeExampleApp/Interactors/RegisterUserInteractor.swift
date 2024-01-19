//
// Copyright © 2022 OneWelcome. All rights reserved.
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
    func handleTwoStepCode()
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

    func startUserRegistration(identityProvider: IdentityProvider?) {
        switch AllowedIdentityProviders(rawValue: identityProvider?.identifier ?? "") {
        case .stateless, .twoWayStateless:
            userClient.registerStatelessUserWith(identityProvider: identityProvider, scopes: ["read", "openid"], delegate: self)
        default:
            userClient.registerUserWith(identityProvider: identityProvider, scopes: ["read", "openid"], delegate: self)
        }
    }

    func handleRedirectURL() {
        guard let browserRegistrationChallenge = registerUserEntity.browserRegistrationChallenge else { return }
        if let url = registerUserEntity.redirectURL {
            browserRegistrationChallenge.sender.respond(with: url, to: browserRegistrationChallenge)
        } else {
            browserRegistrationChallenge.sender.cancel(browserRegistrationChallenge)
        }
    }

    func handleTwoStepCode() {
        guard let customRegistrationChallenge = registerUserEntity.customRegistrationChallenge else { return }
        if registerUserEntity.cancelled {
            registerUserEntity.cancelled = false
            customRegistrationChallenge.sender.cancel(customRegistrationChallenge, withUnderlyingError: nil)
        } else {
            customRegistrationChallenge.sender.respond(with: registerUserEntity.responseCode, to: customRegistrationChallenge)
        }
    }

    func handleQRCode(_ qrCode: String?) {
        guard let customRegistrationChallenge = registerUserEntity.customRegistrationChallenge else { return }
        if let qrCode {
            customRegistrationChallenge.sender.respond(with: qrCode, to: customRegistrationChallenge)
        } else {
            customRegistrationChallenge.sender.cancel(customRegistrationChallenge, withUnderlyingError: nil)
        }
    }
    
    func handleFirstStepOfTwoStepRegistration(_ challenge: CustomRegistrationChallenge) {
        // Handle the initial challenge: send the initial challenge response.
        // For the test purposes the value "OneWelcome" is hardcoded, you can prompt for anything.
        challenge.sender.respond(with: "OneWelcome", to: challenge)
    }
    
    func handleSecondStepOfTwoStepRegistration() {
        // Handle the final challenge: prompt for the final challenge response
        registerUserPresenter?.presentTwoStepRegistrationView(regiserUserEntity: registerUserEntity)
    }
    
    func handleStatelessRegistration(_ challenge: CustomRegistrationChallenge) {
        challenge.sender.respond(with: nil, to: challenge)
    }
    
    func registrationNotHandled(_ challenge: CustomRegistrationChallenge) {
        let error = AppError(errorDescription: "Identity provider \(challenge.identityProvider.identifier) is not handled in the example app.")
        challenge.sender.cancel(challenge, withUnderlyingError: error)
        registerUserPresenter?.registerUserActionFailed(error)
    }

    func handleCreatedPin() {
        guard let createPinChallenge = registerUserEntity.createPinChallenge else { return }
        if let pin = registerUserEntity.pin {
            createPinChallenge.sender.respond(with: pin, to: createPinChallenge)
        } else {
            createPinChallenge.sender.cancel(createPinChallenge)
        }
    }

    fileprivate func mapErrorMessageFromTwoStepStatus(_ status: Int) {
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
        switch AllowedIdentityProviders(rawValue: identityProviderIdentifier) {
        case .twoStep:
            mapErrorMessageFromTwoStepStatus(status)
        default:
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
        switch AllowedIdentityProviders(rawValue: challenge.identityProvider.identifier) {
        case .twoWayStateless:
            handleStatelessRegistration(challenge)
        case .twoStep:
            handleFirstStepOfTwoStepRegistration(challenge)
        default:
            registrationNotHandled(challenge)
        }
    }

    func userClient(_ userClient: UserClient, didReceiveCustomRegistrationFinishChallenge challenge: CustomRegistrationChallenge) {
        registerUserEntity.customRegistrationChallenge = challenge
        if let info = challenge.info {
            registerUserEntity.challengeCode = info.data
            mapErrorMessageFromStatus(info.status, identityProviderIdentifier: challenge.identityProvider.identifier)
        }
        
        switch AllowedIdentityProviders(rawValue: challenge.identityProvider.identifier) {
        case .twoStep:
            handleSecondStepOfTwoStepRegistration()
        case .qrCode:
            registerUserPresenter?.presentQRCodeRegistrationView(registerUserEntity: registerUserEntity)
        case .stateless, .twoWayStateless:
            handleStatelessRegistration(challenge)
        default:
            registrationNotHandled(challenge)
        }

    }

    func userClient(_ userClient: UserClient, didRegisterUser userProfile: UserProfile, with identityProvider: IdentityProvider, info: CustomInfo?) {
        registerUserPresenter?.presentDashboardView(authenticatedUserProfile: userProfile)
    }

    func userClient(_ userClient: UserClient, didFailToRegisterUserWith identityProvider: IdentityProvider, error: Error) {
        switch ONGRegistrationError(rawValue: error.code) {
        case .stateless:
            let mappedError = ErrorMapper().mapError(error)
            registerUserPresenter?.registerUserActionFailed(mappedError)
            return
        default:
            break
        }
        
        switch ONGGenericError(rawValue: error.code) {
        case .actionCancelled:
            registerUserPresenter?.registerUserActionCancelled()
        default:
            let mappedError = ErrorMapper().mapError(error)
            registerUserPresenter?.registerUserActionFailed(mappedError)
        }
        registerUserEntity.errorMessage = nil
    }
}
