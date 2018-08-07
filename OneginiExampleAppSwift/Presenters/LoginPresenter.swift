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

typealias LoginPresenterProtocol = LoginInteractorToPresenterProtocol & LoginViewToPresenterProtocol & ParentToChildPresenterProtocol

protocol ParentToChildPresenterProtocol {
    func reloadProfiles()
    func selectLastSelectedProfileAndReloadAuthenticators()
    func selectFirstProfileAndReloadAuthenticators()
}

protocol LoginInteractorToPresenterProtocol: class {
    func presentPinView(loginEntity: LoginEntity)
    func presentDashboardView(authenticatedUserProfile: ONGUserProfile)
    func loginActionFailed(_ error: AppError)
    func loginActionCancelled()
}

protocol LoginViewToPresenterProtocol: class {
    var profiles: Array<ONGUserProfile> { get set }

    func setupLoginView() -> LoginViewController
    func login(profile: ONGUserProfile)
    func reloadAuthenticators(_ profile: ONGUserProfile)
}

class LoginPresenter: LoginInteractorToPresenterProtocol {
    var loginInteractor: LoginInteractorProtocol
    var profiles = Array<ONGUserProfile>()
    let navigationController: UINavigationController
    var loginViewController: LoginViewController
    var pinViewController: PinViewController?

    init(loginInteractor: LoginInteractorProtocol, navigationController: UINavigationController, loginViewController: LoginViewController) {
        self.loginInteractor = loginInteractor
        self.navigationController = navigationController
        self.loginViewController = loginViewController
    }

    func presentPinView(loginEntity: LoginEntity) {
        if let error = loginEntity.pinError {
            let errorDescription = "\(error.errorDescription) \(error.recoverySuggestion)"
            pinViewController?.setupErrorLabel(errorDescription: errorDescription)
        } else {
            pinViewController = PinViewController(mode: .login, entity: loginEntity, viewToPresenterProtocol: self)
            navigationController.pushViewController(pinViewController!, animated: true)
        }
    }

    func presentDashboardView(authenticatedUserProfile: ONGUserProfile) {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupDashboardPresenter(authenticatedUserProfile: authenticatedUserProfile)
    }

    func loginActionFailed(_ error: AppError) {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.popToWelcomeViewWithLogin()
        appRouter.setupErrorAlert(error: error)
    }

    func loginActionCancelled() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.popToWelcomeViewWithLogin()
    }
}

extension LoginPresenter: LoginViewToPresenterProtocol {
    func setupLoginView() -> LoginViewController {
        profiles = loginInteractor.userProfiles()
        if profiles.count > 0 {
            let authenticators = loginInteractor.authenticators(profile: profiles[0])
            loginViewController.authenticators = authenticators
        }
        loginViewController.profiles = profiles
        return loginViewController
    }

    func login(profile: ONGUserProfile) {
        loginInteractor.login(profile: profile)
    }

    func reloadAuthenticators(_ profile: ONGUserProfile) {
        loginViewController.authenticators = loginInteractor.authenticators(profile: profile)
    }
}

extension LoginPresenter: ParentToChildPresenterProtocol {
    func reloadProfiles() {
        profiles = loginInteractor.userProfiles()
        loginViewController.profiles = profiles
    }

    func selectLastSelectedProfileAndReloadAuthenticators() {
        let profile = loginViewController.selectedProfile
        reloadAuthenticators(profile)
        if let index = loginViewController.profiles.index(of: profile) {
            loginViewController.selectProfile(index: index)
        }
    }

    func selectFirstProfileAndReloadAuthenticators() {
        reloadAuthenticators(profiles[0])
        loginViewController.selectProfile(index: 0)
    }
}

extension LoginPresenter: PinViewToPresenterProtocol {
    func handlePin(entity: PinViewControllerEntityProtocol) {
        loginInteractor.handleLogin(loginEntity: entity)
    }
}
