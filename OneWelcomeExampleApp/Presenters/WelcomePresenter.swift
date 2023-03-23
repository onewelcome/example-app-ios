//
// Copyright © 2022 OneWelcome. All rights reserved.
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

protocol WelcomePresenterProtocol: AnyObject {
    var loginPresenter: LoginPresenterProtocols { get set }
    var registerUserPresenter: RegisterUserPresenterProtocol { get set }
    var welcomeViewController: WelcomeViewController { get set }
    var welcomeInteractor: WelcomeInteractorProtocol { get set }
    
    func presentWelcomeView()
    func popToWelcomeViewController()
    func update(selectedProfile: UserProfile?)
    func handleInterfaceStyleChange(_ style: UIUserInterfaceStyle)
}

class WelcomePresenter: WelcomePresenterProtocol {
    let navigationController: UINavigationController
    let tabBarController: TabBarController
    var loginPresenter: LoginPresenterProtocols
    var registerUserPresenter: RegisterUserPresenterProtocol

    var welcomeViewController: WelcomeViewController
    var welcomeInteractor: WelcomeInteractorProtocol
    
    init(_ welcomeViewController: WelcomeViewController,
         welcomeInteractor: WelcomeInteractorProtocol,
         loginPresenter: LoginPresenterProtocols,
         registerUserPresenter: RegisterUserPresenterProtocol,
         navigationController: UINavigationController,
         tabBarController: TabBarController) {
        self.welcomeViewController = welcomeViewController
        self.welcomeInteractor = welcomeInteractor
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

    func update(selectedProfile: UserProfile?) {
        if let profile = selectedProfile {
            loginPresenter.updateSelectedProfile(profile)
        }
        loginPresenter.update()
        setupSegmentView()
    }

    func setupSegmentView() {
        if !loginPresenter.profiles.isEmpty {
            welcomeViewController.setupViewWithProfiles()
        } else {
            welcomeViewController.setupViewWithoutProfiles()
        }
    }

    func popToWelcomeViewController() {
        navigationController.popToViewController(welcomeViewController, animated: true)
    }
    
    func handleInterfaceStyleChange(_ style: UIUserInterfaceStyle) {
        welcomeInteractor.setIconForMode(style.appIconName)
    }
}

private extension UIUserInterfaceStyle {
    var appIconName: WelcomeInteractor.IconMode {
        switch self {
        case .dark:
            return .dark
        default:
            return .light
        }
    }
}
