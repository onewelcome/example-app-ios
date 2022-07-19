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

typealias AuthenticatorsPresenterProtocol = AuthenticatorsInteractorToPresenterProtocol & AuthenticatorsViewToPresenterProtocol

protocol AuthenticatorsInteractorToPresenterProtocol: AnyObject {
    func presentAuthenticatorsView()
    func presentPinView(registerAuthenticatorEntity: RegisterAuthenticatorEntity)
    func backToAuthenticatorsView(authenticator: Authenticator)
    func authenticatorDeregistrationSucced()
    func authenticatorActionFailed(_ error: AppError, authenticator: Authenticator)
    func authenticatorActionCancelled(authenticator: Authenticator)
    func presentCustomAuthenticatorRegistrationView(registerAuthenticatorEntity: RegisterAuthenticatorEntity)
    func popToWelcomeView(_ error: AppError)
}

protocol AuthenticatorsViewToPresenterProtocol: AnyObject {
    func registerAuthenticator(_ authenticator: Authenticator)
    func deregisterAuthenticator(_ authenticator: Authenticator)
    func popToDashboardView()
    func reloadAuthenticators()
    func setPreferredAuthenticator(_ authenticator: Authenticator)
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
            pinViewController = PinViewController(mode: .login, entity: registerAuthenticatorEntity, viewToPresenterProtocol: self)
            navigationController.present(pinViewController!, animated: true)
        }
    }

    func backToAuthenticatorsView(authenticator: Authenticator) {
        reloadAuthenticators()
        let animated = authenticator.type != .custom
        navigationController.dismiss(animated: animated, completion: nil)
    }

    func authenticatorActionFailed(_ error: AppError, authenticator: Authenticator) {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        backToAuthenticatorsView(authenticator: authenticator)
        appRouter.setupErrorAlert(error: error)
    }

    func authenticatorActionCancelled(authenticator: Authenticator) {
        backToAuthenticatorsView(authenticator: authenticator)
    }

    func popToWelcomeView(_ error: AppError) {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        navigationController.dismiss(animated: true, completion: nil)
        appRouter.updateWelcomeView(selectedProfile: nil)
        appRouter.popToWelcomeView()
        appRouter.setupErrorAlert(error: error)
    }

    func presentCustomAuthenticatorRegistrationView(registerAuthenticatorEntity: RegisterAuthenticatorEntity) {
        let passwordViewController = PasswordAuthenticatorViewController(mode: .register, entity: registerAuthenticatorEntity, viewToPresenterProtocol: self)
        passwordViewController.modalPresentationStyle = .overCurrentContext
        navigationController.present(passwordViewController, animated: false, completion: nil)
    }
}

extension AuthenticatorsPresenter: AuthenticatorsViewToPresenterProtocol {
    func registerAuthenticator(_ authenticator: Authenticator) {
        authenticatorsInteractor.registerAuthenticator(authenticator)
    }

    func deregisterAuthenticator(_ authenticator: Authenticator) {
        authenticatorsInteractor.deregisterAuthenticator(authenticator)
    }

    func popToDashboardView() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.popToDashboardView()
    }
    
    func reloadAuthenticators() {
        authenticatorsViewController.authenticatorsList = authenticatorsInteractor.authenticatorsListForAuthenticatedUserProfile
    }
    
    func setPreferredAuthenticator(_ authenticator: Authenticator) {
        authenticatorsInteractor.setPreferredAuthenticator(authenticator)
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
