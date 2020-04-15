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
import Dip

typealias RegisterUserPresenterProtocol = RegisterUserInteractorToPresenterProtocol & RegisterUserViewToPresenterProtocol

protocol RegisterUserInteractorToPresenterProtocol: class {
    func presentBrowserUserRegistrationView(regiserUserEntity: RegisterUserEntity)
    func presentCreatePinView(registerUserEntity: RegisterUserEntity)
    func presentDashboardView()
    func presentError(_ error: Error)
}

protocol RegisterUserViewToPresenterProtocol {
    func signUp()
    func setupRegisterUserView() -> RegisterUserViewController
    func handleRedirectURL(registerUserEntity: BrowserViewControllerEntityProtocol)
}

class RegisterUserPresenter: RegisterUserInteractorToPresenterProtocol {
    var registerUserInteractor: RegisterUserInteractorProtocol
    let navigationController: UINavigationController

    init(registerUserInteractor: RegisterUserInteractorProtocol, navigationController: UINavigationController) {
        self.registerUserInteractor = registerUserInteractor
        self.navigationController = navigationController
    }

    func presentBrowserUserRegistrationView(regiserUserEntity: RegisterUserEntity) {
        let browserViewController = BrowserViewController(registerUserEntity: regiserUserEntity, registerUserViewToPresenterProtocol: self)
        navigationController.present(browserViewController, animated: true, completion: nil)
    }

    func presentCreatePinView(registerUserEntity: RegisterUserEntity) {
        let pinViewController = PinViewController(mode: .registration, entity: registerUserEntity, viewToPresenterProtocol: self)
        navigationController.present(pinViewController, animated: true, completion: nil)
    }

    func presentDashboardView() {
        guard let appRouter = Injected<AppRouterProtocol>().value else { fatalError() }
        appRouter.setupDashboardPresenter()
    }

    func presentError(_ error: Error) {
        guard let appRouter = try? container.resolve() as AppRouterProtocol else { fatalError() }
        appRouter.setupErrorAlert(error: error, title: "")
    }
}

extension RegisterUserPresenter: RegisterUserViewToPresenterProtocol {
    func setupRegisterUserView() -> RegisterUserViewController {
        let identityProviders = registerUserInteractor.identityProviders()
        guard let registerUserViewController = try? container.resolve(arguments: Array(identityProviders)) as RegisterUserViewController else { fatalError() }
        return registerUserViewController
    }

    func signUp() {
        registerUserInteractor.startUserRegistration()
    }

    func handleRedirectURL(registerUserEntity: BrowserViewControllerEntityProtocol) {
        if navigationController.presentedViewController is BrowserViewController {
            navigationController.dismiss(animated: true, completion: nil)
        }
        registerUserInteractor.handleRedirectURL(registerUserEntity: registerUserEntity)
    }

    func handleCreatePinRegistrationChallenge(registerUserEntity: PinViewControllerEntityProtocol) {
        
    }
}

extension RegisterUserPresenter: PinViewToPresenterProtocol {
    func handlePin(entity: PinViewControllerEntityProtocol) {
        if navigationController.presentedViewController is PinViewController {
            navigationController.dismiss(animated: true, completion: nil)
        }
        registerUserInteractor.handleCreatedPin(registerUserEntity: entity)
    }
}
