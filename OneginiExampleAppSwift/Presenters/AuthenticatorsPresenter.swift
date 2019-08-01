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

typealias AuthenticatorsPresenterProtocol = AuthenticatorsInteractorToPresenterProtocol & AuthenticatorsViewToPresenterProtocol

protocol AuthenticatorsInteractorToPresenterProtocol: class {
    func presentAuthenticatorsView()
    func presentPinView(registerAuthenticatorEntity: RegisterAuthenticatorEntity)
    func backToAuthenticatorsView(authenticator: ONGAuthenticator)
    func authenticatorDeregistrationSucced()
    func authenticatorActionFailed(_ error: AppError, authenticator: ONGAuthenticator)
    func authenticatorActionCancelled(authenticator: ONGAuthenticator)
    func presentCustomAuthenticatorRegistrationView(registerAuthenticatorEntity: RegisterAuthenticatorEntity)
    func popToWelcomeView(_ error: AppError)
}

protocol AuthenticatorsViewToPresenterProtocol: class {
    func registerAuthenticator(_ authenticator: ONGAuthenticator)
    func deregisterAuthenticator(_ authenticator: ONGAuthenticator)
    func popToDashboardView()
    func reloadAuthenticators()
    func setPreferredAuthenticator(_ authenticator: ONGAuthenticator)
}

class AuthenticatorsPresenter: AuthenticatorsInteractorToPresenterProtocol {
    let navigationController: UINavigationController
    let authenticatorsInteractor: AuthenticatorsInteractorProtocol
    let authenticatorsViewController: AuthenticatorsViewController
    var pinViewController: PinViewController?

    init(_ authenticatorsInteractor: AuthenticatorsInteractorProtocol, navigationController: UINavigationController, authenticatorsViewController: AuthenticatorsViewController) {
        self.navigationController = navigationController
        self.authenticatorsInteractor = authenticatorsInteractor
        self.authenticatorsViewController = authenticatorsViewController
    }

    func reloadAuthenticators() {
        let authenticators = authenticatorsInteractor.authenticatorsListForAuthenticatedUserProfile()
        authenticatorsViewController.authenticatorsList = authenticators
    }

    func authenticatorDeregistrationSucced() {
        authenticatorsViewController.finishDeregistrationAnimation()
    }

    func presentAuthenticatorsView() {
        reloadAuthenticators()
        navigationController.pushViewController(authenticatorsViewController, animated: true)
    }

    func presentPinView(registerAuthenticatorEntity: RegisterAuthenticatorEntity) {
        if let error = registerAuthenticatorEntity.pinError {
            let errorDescription = "\(error.errorDescription) \(error.recoverySuggestion)"
            pinViewController?.setupErrorLabel(errorDescription: errorDescription)
        } else {
//            pinViewController = PinViewController(mode: .login, entity: registerAuthenticatorEntity, viewToPresenterProtocol: self)
//            navigationController.present(pinViewController!, animated: true)
        }
    }

    func backToAuthenticatorsView(authenticator: ONGAuthenticator) {
        reloadAuthenticators()
        let animated = authenticator.type != .custom
        navigationController.dismiss(animated: animated, completion: nil)
    }

    func authenticatorActionFailed(_ error: AppError, authenticator: ONGAuthenticator) {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        backToAuthenticatorsView(authenticator: authenticator)
        appRouter.setupErrorAlert(error: error)
    }

    func authenticatorActionCancelled(authenticator: ONGAuthenticator) {
        backToAuthenticatorsView(authenticator: authenticator)
    }

    func popToWelcomeView(_ error: AppError) {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        navigationController.dismiss(animated: true, completion: nil)
        appRouter.updateWelcomeView(selectedProfile: nil)
        appRouter.popToWelcomeView()
        appRouter.setupErrorAlert(error: error)
    }

    func setPreferredAuthenticator(_ authenticator: ONGAuthenticator) {
        authenticatorsInteractor.setPreferredAuthenticator(authenticator)
    }

    func presentCustomAuthenticatorRegistrationView(registerAuthenticatorEntity: RegisterAuthenticatorEntity) {
        let passwordViewController = PasswordAuthenticatorViewController(mode: .register, entity: registerAuthenticatorEntity, viewToPresenterProtocol: self)
        passwordViewController.modalPresentationStyle = .overCurrentContext
        navigationController.present(passwordViewController, animated: false, completion: nil)
    }
}

extension AuthenticatorsPresenter: AuthenticatorsViewToPresenterProtocol {
    func registerAuthenticator(_ authenticator: ONGAuthenticator) {
        authenticatorsInteractor.registerAuthenticator(authenticator)
    }

    func deregisterAuthenticator(_ authenticator: ONGAuthenticator) {
        authenticatorsInteractor.deregisterAuthenticator(authenticator)
    }

    func popToDashboardView() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.popToDashboardView()
    }
}

extension AuthenticatorsPresenter: PinViewToPresenterProtocol {
    func handlePin() {
        authenticatorsInteractor.handleLogin()
    }
}

extension AuthenticatorsPresenter: PasswordAuthenticatorViewToPresenterProtocol {
    func handlePassword() {
        authenticatorsInteractor.handlePasswordAuthenticatorRegistration()
    }
}
