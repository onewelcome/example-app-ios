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

typealias LoginPresenterProtocol = LoginInteractorToPresenterProtocol & LoginViewToPresenterProtocol

protocol LoginInteractorToPresenterProtocol: class {
    func presentPinView(loginEntity: LoginEntity)
    func presentDashboardView()
    func presentError(_ error: Error)
}

protocol LoginViewToPresenterProtocol: class {
    var profiles: Array<ONGUserProfile> { get set }

    func setupLoginView() -> LoginViewController
    func login(profile: ONGUserProfile)
    func reloadAuthenticators(_ profiles: ONGUserProfile)
    func reloadProfiles()
}

class LoginPresenter: LoginInteractorToPresenterProtocol {
    var loginInteractor: LoginInteractorProtocol
    var profiles = Array<ONGUserProfile>()
    let navigationController: UINavigationController
    var loginViewController: LoginViewController

    init(loginInteractor: LoginInteractorProtocol, navigationController: UINavigationController, loginViewController: LoginViewController) {
        self.loginInteractor = loginInteractor
        self.navigationController = navigationController
        self.loginViewController = loginViewController
    }
    
    func presentPinView(loginEntity: LoginEntity) {
        let pinViewController = PinViewController(mode: .login, entity: loginEntity, viewToPresenterProtocol: self)
        navigationController.present(pinViewController, animated: true, completion: nil)
    }
    
    func presentDashboardView() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupDashboardPresenter()
    }
    
    func presentError(_ error: Error) {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupErrorAlert(error: error, title: "")
    }
}

extension LoginPresenter: LoginViewToPresenterProtocol {
    func setupLoginView() -> LoginViewController {
        profiles = Array(loginInteractor.userProfiles())
        if profiles.count > 0 {
            let authenticators = Array(loginInteractor.authenticators(profile: profiles[0]))
            loginViewController.authenticators = authenticators
        }
        loginViewController.profiles = profiles
        return loginViewController
    }
    
    func login(profile: ONGUserProfile) {
        loginInteractor.login(profile: profile)
    }
    
    func reloadAuthenticators(_ profiles: ONGUserProfile) {
        loginViewController.authenticators = Array(loginInteractor.authenticators(profile: profiles))
    }
    
    func reloadProfiles() {
        profiles = Array(loginInteractor.userProfiles())
        loginViewController.profiles = profiles
    }
}

extension LoginPresenter: PinViewToPresenterProtocol {
    func handlePin(entity: PinViewControllerEntityProtocol) {
        if navigationController.presentedViewController is PinViewController {
            navigationController.dismiss(animated: true, completion: nil)
        }
        loginInteractor.handleLogin(loginEntity: entity)
    }
}
