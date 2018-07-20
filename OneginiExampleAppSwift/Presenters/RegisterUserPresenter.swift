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

typealias RegisterUserPresenterProtocol = RegisterUserInteractorToPresenterProtocol & RegisterUserViewToPresenterProtocol & PinViewToPresenterProtocol

protocol RegisterUserInteractorToPresenterProtocol: class {
    func presentBrowserUserRegistrationView(regiserUserEntity: RegisterUserEntity)
    func presentCreatePinView(registerUserEntity: RegisterUserEntity)
    func presentDashboardView()
    func registerUserActionFailed(_ error: AppError)
    func registerUserActionCancelled()
}

protocol RegisterUserViewToPresenterProtocol {
    func signUp()
    func setupRegisterUserView() -> RegisterUserViewController
    func handleRedirectURL(registerUserEntity: BrowserViewControllerEntityProtocol)
}

class RegisterUserPresenter: RegisterUserInteractorToPresenterProtocol {
    var registerUserInteractor: RegisterUserInteractorProtocol
    let navigationController: UINavigationController
    var pinViewController: PinViewController?

    init(registerUserInteractor: RegisterUserInteractorProtocol, navigationController: UINavigationController) {
        self.registerUserInteractor = registerUserInteractor
        self.navigationController = navigationController
    }

    func presentBrowserUserRegistrationView(regiserUserEntity: RegisterUserEntity) {
        let browserViewController = BrowserViewController(registerUserEntity: regiserUserEntity, registerUserViewToPresenterProtocol: self)
        navigationController.pushViewController(browserViewController, animated: true)
    }

    func presentCreatePinView(registerUserEntity: RegisterUserEntity) {
        if let error = registerUserEntity.pinError {
            let errorDescription = "\(error.errorDescription) \(error.recoverySuggestion)"
            pinViewController?.setupErrorLabel(errorDescription: errorDescription)
        } else {
            pinViewController = PinViewController(mode: .registration, entity: registerUserEntity, viewToPresenterProtocol: self)
            navigationController.pushViewController(pinViewController!, animated: true)
        }
    }

    func presentDashboardView() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupDashboardPresenter()
    }

    func registerUserActionFailed(_ error: AppError) {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.popToWelcomeViewWithLogin()
        appRouter.setupErrorAlert(error: error)
    }
    
    func registerUserActionCancelled() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.popToWelcomeViewControllerWithRegisterUser()
    }
}

extension RegisterUserPresenter: RegisterUserViewToPresenterProtocol {
    func setupRegisterUserView() -> RegisterUserViewController {
        let identityProviders = registerUserInteractor.identityProviders()
        guard let registerUserViewController = AppAssembly.shared.resolver.resolve(RegisterUserViewController.self, argument: identityProviders) else { fatalError() }
        return registerUserViewController
    }

    func signUp() {
        registerUserInteractor.startUserRegistration()
    }

    func handleRedirectURL(registerUserEntity: BrowserViewControllerEntityProtocol) {
        registerUserInteractor.handleRedirectURL(registerUserEntity: registerUserEntity)
    }
}

extension RegisterUserPresenter: PinViewToPresenterProtocol {
    func handlePin(entity: PinViewControllerEntityProtocol) {
        registerUserInteractor.handleCreatedPin(registerUserEntity: entity)
    }
}
