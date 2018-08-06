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

import Swinject
import UIKit

protocol WelcomePresenterProtocol: class {
    func setupSegmentView()
    func presentWelcomeView()
    func popToWelcomeViewControllerWithLogin()
    func popToWelcomeViewControllerWithRegisterUser()
    func popToWelcomeViewControllerDependsOnProfileArray()
}

class WelcomePresenter: WelcomePresenterProtocol {
    let navigationController: UINavigationController
    var loginPresenter: LoginPresenterProtocol
    var registerUserPresenter: RegisterUserPresenterProtocol
    var welcomeViewController: WelcomeViewController

    init(_ welcomeViewController: WelcomeViewController, loginPresenter: LoginPresenterProtocol, registerUserPresenter: RegisterUserPresenterProtocol, navigationController: UINavigationController) {
        self.welcomeViewController = welcomeViewController
        self.loginPresenter = loginPresenter
        self.registerUserPresenter = registerUserPresenter
        self.navigationController = navigationController
    }

    func presentWelcomeView() {
        welcomeViewController.loginViewController = loginPresenter.setupLoginView()
        welcomeViewController.registerUserViewController = registerUserPresenter.setupRegisterUserView()
        navigationController.pushViewController(welcomeViewController, animated: false)
    }

    func popToWelcomeViewControllerWithLogin() {
        loginPresenter.reloadProfiles()
        setupSegmentView()
        loginPresenter.selectLastSelectedProfileAndReloadAuthenticators()
        navigationController.popToViewController(welcomeViewController, animated: true)
    }

    func popToWelcomeViewControllerWithRegisterUser() {
        welcomeViewController.selectSignUp()
        navigationController.popToViewController(welcomeViewController, animated: true)
    }
    
    func popToWelcomeViewControllerDependsOnProfileArray() {
        if loginPresenter.profiles.count > 0 {
            popToWelcomeViewControllerWithLogin()
        } else {
            popToWelcomeViewControllerWithRegisterUser()
        }
    }

    func setupSegmentView() {
        if loginPresenter.profiles.count > 0 {
            welcomeViewController.setupViewWithProfiles()
        } else {
            welcomeViewController.setupViewWithoutProfiles()
        }
    }
}
