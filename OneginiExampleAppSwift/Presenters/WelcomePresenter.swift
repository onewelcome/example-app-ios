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
    var loginPresenter: LoginPresenterProtocol { get set }
    var registerUserPresenter: RegisterUserPresenterProtocol { get set }
    var welcomeViewController: WelcomeViewController { get set }
    
    func setupSegmentView()
    func presentWelcomeView()
    func popToWelcomeViewControllerWithLogin(profile: ONGUserProfile)
    func popToWelcomeViewControllerWithRegisterUser()
    func popToWelcomeViewController()
}

class WelcomePresenter: WelcomePresenterProtocol {
    let navigationController: UINavigationController
    let tabBarController: TabBarController
    var loginPresenter: LoginPresenterProtocol
    var registerUserPresenter: RegisterUserPresenterProtocol
    var welcomeViewController: WelcomeViewController

    init(_ welcomeViewController: WelcomeViewController,
         loginPresenter: LoginPresenterProtocol,
         registerUserPresenter: RegisterUserPresenterProtocol,
         navigationController: UINavigationController,
         tabBarController: TabBarController) {
        self.welcomeViewController = welcomeViewController
        self.loginPresenter = loginPresenter
        self.registerUserPresenter = registerUserPresenter
        self.navigationController = navigationController
        self.tabBarController = tabBarController
    }

    func presentWelcomeView() {
        welcomeViewController.loginViewController = loginPresenter.setupLoginView()
        welcomeViewController.registerUserViewController = registerUserPresenter.setupRegisterUserView()
        tabBarController.selectedIndex = 0
    }

    func popToWelcomeViewControllerWithLogin(profile: ONGUserProfile) {
        loginPresenter.reloadProfiles()
        loginPresenter.updateSelectedProfile(profile)
        setupSegmentView()
        loginPresenter.updateView()
        navigationController.popToViewController(welcomeViewController, animated: true)
    }

    func popToWelcomeViewControllerWithRegisterUser() {
        welcomeViewController.selectSignUp()
        navigationController.popToViewController(welcomeViewController, animated: true)
    }

    func popToWelcomeViewController() {
        loginPresenter.reloadProfiles()
        setupSegmentView()
        if loginPresenter.profiles.count > 0 {
            loginPresenter.updateView()
            navigationController.popToViewController(welcomeViewController, animated: true)
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
