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
import Swinject

protocol WelcomePresenterProtocol {
    func setupSegmentView(welcomeViewController: WelcomeViewController)
    func setupLoginView() -> LoginViewController
    func setupRegisterUserView() -> RegisterUserViewController
    func presentWelcomeView()
}

class WelcomePresenter: WelcomePresenterProtocol {

    fileprivate let navigationContorller = AppNavigationController.shared
    var loginPresenter: LoginPresenterProtocol?
    var registerUserPresenter: RegisterUserPresenterProtocol?
    
    func presentWelcomeView() {
        guard let welcomeViewController = AppAssembly.shared.resolver.resolve(WelcomeViewController.self, argument: self) else { fatalError() }
        navigationContorller.pushViewController(welcomeViewController, animated: false)
    }
    
    func setupLoginView() -> LoginViewController {
        guard let loginPresenter = loginPresenter else { fatalError() }
        return loginPresenter.setupLoginView()
    }
    
    func setupRegisterUserView() -> RegisterUserViewController {
        guard let registerUserPresenter = registerUserPresenter else { fatalError() }
        return registerUserPresenter.setupRegisterUserView()
    }
    
    func setupSegmentView(welcomeViewController: WelcomeViewController) {
        guard let loginPresenter = loginPresenter else { fatalError() }
        if loginPresenter.profiles.count > 0 {
            welcomeViewController.setupViewWithProfiles()
        } else {
            welcomeViewController.setupViewWithoutProfiles()
        }
    }
    
}
