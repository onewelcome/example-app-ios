//
// Copyright (c) 2016 Onegini. All rights reserved.
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
    func handleCreatePinRegistrationChallenge(registerUserEntity: PinViewControllerEntityProtocol)
}

class RegisterUserPresenter: RegisterUserInteractorToPresenterProtocol {

    var registerUserInteractor: RegisterUserInteractorProtocol?
    let navigationContorller = AppNavigationController.shared
    
    func presentBrowserUserRegistrationView(regiserUserEntity: RegisterUserEntity) {
        let browserViewController = BrowserViewController(registerUserEntity: regiserUserEntity, registerUserViewToPresenterProtocol:self)
        navigationContorller.present(browserViewController, animated: true, completion: nil)
    }

    func presentCreatePinView(registerUserEntity: RegisterUserEntity) {
        let pinViewController = PinViewController(mode: .registration, registerUserEntity: registerUserEntity, registerUserViewToPresenterProtocol: self)
        navigationContorller.present(pinViewController, animated: true, completion: nil)
    }
    
    func presentDashboardView() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupDashboardPresenter()
    }
    
    func presentError(_ error: Error) {
        ErrorPresenter().showErrorAlert(error: error, title: "")
    }
}

extension RegisterUserPresenter: RegisterUserViewToPresenterProtocol {
    
    func setupRegisterUserView() -> RegisterUserViewController {
        guard let registerUserInteractor = registerUserInteractor,
            let registerUserViewController = AppAssembly.shared.resolver.resolve(RegisterUserViewController.self)
            else { fatalError() }
        
        let identityProviders = registerUserInteractor.identityProviders()
        registerUserViewController.identityProviders = Array(identityProviders)
        return registerUserViewController
    }
    
    func signUp() {
        guard let registerUserInteractor = registerUserInteractor else { fatalError() }
        registerUserInteractor.startUserRegistration()
    }
    
    func handleRedirectURL(registerUserEntity: BrowserViewControllerEntityProtocol) {
        if navigationContorller.presentedViewController is BrowserViewController {
            navigationContorller.dismiss(animated: true, completion: nil)
        }
        registerUserInteractor?.handleRedirectURL(registerUserEntity: registerUserEntity)
    }
    
    func handleCreatePinRegistrationChallenge(registerUserEntity: PinViewControllerEntityProtocol) {
        if navigationContorller.presentedViewController is PinViewController {
            navigationContorller.dismiss(animated: true, completion: nil)
        }
        registerUserInteractor?.handleCreatedPin(registerUserEntity: registerUserEntity)
    }
}
