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
}

protocol LoginInteractorToPresenterProtocol: class {
    var appRouterDelegate: AppRouterProtocol? { get set }
    
    func presentPinView(loginEntity: LoginEntity)
    func presentDashboardView()
    func loginActionFailed(_ error: AppError)
    func loginActionCancelled()
}

protocol LoginViewToPresenterProtocol: class {
    var profiles: Array<NSObject & UserProfileProtocol> { get set }

    func setupLoginView() -> UIViewController & LoginPresenterToViewProtocol
    func login(profile: NSObject & UserProfileProtocol)
    func reloadAuthenticators(_ profile: NSObject & UserProfileProtocol)
}

protocol LoginPresenterToViewProtocol {
    var authenticators: Array<NSObject & AuthenticatorProtocol> { get set }
    var profiles: Array<NSObject & UserProfileProtocol> { get set }
    var selectedProfile: (NSObject & UserProfileProtocol)? { get set }
    
    func selectProfile(index: Int)
    var loginViewToPresenterProtocol: LoginViewToPresenterProtocol? { get set }
}

class LoginPresenter: LoginInteractorToPresenterProtocol {
    var loginInteractor: LoginInteractorProtocol
    var profiles = Array<NSObject & UserProfileProtocol>()
    let navigationController: UINavigationController
    var loginViewController: UIViewController & LoginPresenterToViewProtocol
    var pinViewController: PinViewController?
    public weak var appRouterDelegate: AppRouterProtocol?

    init(loginInteractor: LoginInteractorProtocol,
         navigationController: UINavigationController,
         loginViewController: UIViewController & LoginPresenterToViewProtocol) {
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

    func presentDashboardView() {
        appRouterDelegate!.setupDashboardPresenter()
    }

    func loginActionFailed(_ error: AppError) {
        appRouterDelegate!.popToWelcomeViewWithLogin()
        appRouterDelegate!.setupErrorAlert(error: error)
    }

    func loginActionCancelled() {
        appRouterDelegate!.popToWelcomeViewWithLogin()
    }
}

extension LoginPresenter: LoginViewToPresenterProtocol {
    func setupLoginView() -> UIViewController & LoginPresenterToViewProtocol {
        profiles = loginInteractor.userProfiles()
        if profiles.count > 0 {
            let authenticators = loginInteractor.authenticators(profile: profiles[0])
            loginViewController.authenticators = authenticators
        }
        loginViewController.profiles = profiles
        return loginViewController
    }

    func login(profile: NSObject & UserProfileProtocol) {
        loginInteractor.login(profile: profile)
    }

    func reloadAuthenticators(_ profile: NSObject & UserProfileProtocol) {
        loginViewController.authenticators = loginInteractor.authenticators(profile: profile)
    }
}

extension LoginPresenter: ParentToChildPresenterProtocol {
    func reloadProfiles() {
        profiles = loginInteractor.userProfiles()
        loginViewController.profiles = profiles
    }

    func selectLastSelectedProfileAndReloadAuthenticators() {
        if let profile = loginViewController.selectedProfile {
            reloadAuthenticators(profile)
            if let index = loginViewController.profiles.index(where:{ $0 as NSObject & UserProfileProtocol == profile}) {
                loginViewController.selectProfile(index: index)
            }
        }
    }
}

extension LoginPresenter: PinViewToPresenterProtocol {
    func handlePin(entity: PinViewControllerEntityProtocol) {
        loginInteractor.handleLogin(loginEntity: entity)
    }
}
