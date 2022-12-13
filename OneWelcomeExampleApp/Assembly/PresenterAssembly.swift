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

import Swinject
import UIKit

class PresenterAssembly: Assembly {
    func assemble(container: Container) {

        container.register(StartupPresenterProtocol.self) { resolver in
            StartupPresenter(startupInteractor: resolver.resolve(StartupInteractorProtocol.self)!)
        }

        container.register(WelcomePresenterProtocol.self) { resolver in
            WelcomePresenter(resolver.resolve(WelcomeViewController.self)!,
                             loginPresenter: resolver.resolve(LoginPresenterProtocols.self)!,
                             registerUserPresenter: resolver.resolve(RegisterUserPresenterProtocol.self)!,
                             navigationController: resolver.resolve(UINavigationController.self)!,
                             tabBarController: resolver.resolve(TabBarController.self)!)
        }

        container.register(RegisterUserPresenterProtocol.self) { resolver in
            RegisterUserPresenter(registerUserInteractor: resolver.resolve(RegisterUserInteractorProtocol.self)!,
                                  navigationController: resolver.resolve(UINavigationController.self)!,
                                  userRegistrationNavigationController: UINavigationController())
        }

        container.register(LoginPresenterProtocols.self) { resolver in
            LoginPresenter(loginInteractor: resolver.resolve(LoginInteractorProtocol.self)!,
                           fetchImplicitDataInteractor: resolver.resolve(FetchImplicitDataInteractorProtocol.self)!,
                           navigationController: resolver.resolve(UINavigationController.self)!,
                           loginViewController: resolver.resolve(LoginViewController.self)!)
        }.inObjectScope(.weak)

        container.register(DashboardPresenterProtocol.self) { resolver in
            DashboardPresenter(resolver.resolve(DashboardViewController.self)!,
                               logoutInteractor: resolver.resolve(LogoutInteractorProtocol.self)!,
                               navigationController: resolver.resolve(UINavigationController.self)!)
        }

        container.register(ErrorPresenterProtocol.self) { resolver in
            ErrorPresenter(navigationController: resolver.resolve(UINavigationController.self)!)
        }

        container.register(AuthenticatorsPresenterProtocol.self) { resolver in AuthenticatorsPresenter(resolver.resolve(AuthenticatorsInteractorProtocol.self)!,
                                                                                                       navigationController: resolver.resolve(UINavigationController.self)!,
                                                                                                       authenticatorsViewController: resolver.resolve(AuthenticatorsViewController.self)!) }

        container.register(ProfilePresenterProtocol.self) { resolver in ProfilePresenter(resolver.resolve(ProfileViewController.self)!,
                                                                                         navigationController: resolver.resolve(UINavigationController.self)!, profileInteractor: ProfileInteractor()/*resolver.resolve(ProfileInteractor.self)!*/) }

        container.register(MobileAuthPresenterProtocol.self) { resolver in MobileAuthPresenter(resolver.resolve(MobileAuthViewController.self)!,
                                                                                               navigationController: resolver.resolve(UINavigationController.self)!,
                                                                                               tabBarController: resolver.resolve(TabBarController.self)!,
                                                                                               mobileAuthInteractor: resolver.resolve(MobileAuthInteractorProtocol.self)!) }

        container.register(DisconnectPresenterProtocol.self) { resolver in DisconnectPresenter(disconnectInteractor: resolver.resolve(DisconnectInteractorProtocol.self)!,
                                                                                               navigationController: resolver.resolve(UINavigationController.self)!) }

        container.register(ChangePinPresenterProtocol.self) { resolver in ChangePinPresenter(changePinInteractor: resolver.resolve(ChangePinInteractorProtocol.self)!,
                                                                                             navigationController: resolver.resolve(UINavigationController.self)!,
                                                                                             changePinNavigationController: UINavigationController()) }

        container.register(PendingMobileAuthPresenterProtocol.self) { resolver in
            PendingMobileAuthPresenter(pendingMobileAuthViewController: resolver.resolve((UIViewController & PendingMobileAuthPresenterViewDelegate).self)!,
                                       mobileAuthInteractor: resolver.resolve(MobileAuthInteractorProtocol.self)!) }

        container.register(FetchDeviceListPresenterProtocol.self) { resolver in
            FetchDeviceListPresenter(fetchDeviceListInteractor: resolver.resolve(FetchDeviceListInteractorProtocol.self)!,
                                     navigationController: resolver.resolve(UINavigationController.self)!) }

        container.register(AppDetailsPresenterProtocol.self) { resolver in
            AppDetailsPresenter(resolver.resolve(AppDetailsViewController.self)!,
                                appDetailsInteractor: resolver.resolve(AppDetailsInteractorProtocol.self)!,
                                navigationController: resolver.resolve(UINavigationController.self)!) }
        
        container.register(AppToWebPresenterProtocol.self) { resolver in
            AppToWebPresenter(appToWebInteractorProtocol: resolver.resolve(AppToWebInteractorProtocol.self)!,
                              navigationController: resolver.resolve(UINavigationController.self)!)
        }

        container.register(UINavigationController.self) { _ in UINavigationController() }.inObjectScope(.container)
        container.register(TabBarController.self) { _ in TabBarController() }.inObjectScope(.container)
        container.register(UIWindow.self) { _ in
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.backgroundColor = .appBackground
            window.makeKeyAndVisible()
            return window
        }.inObjectScope(.container)

    }
}
