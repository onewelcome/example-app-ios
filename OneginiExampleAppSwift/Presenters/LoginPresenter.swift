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
    func presentPinView(loginEntity: LoginEntity)
    func presentDashboardView()
    func presentError(_ error: Error)
    func presentErrorOnPinView(errorDescription: String)

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
        let pinViewController = PinViewController(mode: .login, entity: loginEntity, viewToPresenterProtocol: self)
        self.pinViewController = pinViewController
        navigationController.pushViewController(pinViewController, animated: true)
    }
    
    func presentErrorOnPinView(errorDescription: String) {
        pinViewController?.setupErrorLabel(errorDescription: errorDescription)
    }
    
    func presentDashboardView() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupDashboardPresenter()
    }
    
    func presentError(_ error: Error) {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.popToWelcomeViewWithLogin()
        appRouter.setupErrorAlert(error: error, title: "")
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
}

extension LoginPresenter: PinViewToPresenterProtocol {
    func handlePin(entity: PinViewControllerEntityProtocol) {
        loginInteractor.handleLogin(loginEntity: entity)
    }
}
