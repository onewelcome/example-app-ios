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
import Dip

protocol WelcomePresenterProtocol {
    func setupSegmentView(welcomeViewController: WelcomeViewController)
    func setupLoginView() -> LoginViewController
    func setupRegisterUserView() -> RegisterUserViewController
    func presentWelcomeView()
}

class WelcomePresenter: WelcomePresenterProtocol {
    let navigationController: UINavigationController
    var loginPresenter: LoginPresenterProtocol
    var registerUserPresenter: RegisterUserPresenterProtocol

    init(loginPresenter: LoginPresenterProtocol, registerUserPresenter: RegisterUserPresenterProtocol, navigationController: UINavigationController) {
        self.loginPresenter = loginPresenter
        self.registerUserPresenter = registerUserPresenter
        self.navigationController = navigationController
    }

    func presentWelcomeView() {
        guard let welcomeViewController = try? container.resolve() as WelcomeViewController else {fatalError()}
        navigationController.pushViewController(welcomeViewController, animated: false)
    }

    func setupLoginView() -> LoginViewController {
        return loginPresenter.setupLoginView()
    }

    func setupRegisterUserView() -> RegisterUserViewController {
        return registerUserPresenter.setupRegisterUserView()
    }

    func setupSegmentView(welcomeViewController: WelcomeViewController) {
        if loginPresenter.profiles.count > 0 {
            welcomeViewController.setupViewWithProfiles()
        } else {
            welcomeViewController.setupViewWithoutProfiles()
        }
    }
}
