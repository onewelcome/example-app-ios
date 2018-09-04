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

class PresenterAssembly: Assembly {
    func assemble(container: Container) {
        container.register(StartupPresenterProtocol.self) { resolver in
            StartupPresenter(startupInteractor: resolver.resolve(StartupInteractorProtocol.self)!,
                navigationController: resolver.resolve(UINavigationController.self)!)
        }

        container.register(WelcomePresenterProtocol.self) { resolver in
            WelcomePresenter(resolver.resolve(WelcomeViewController.self)!,
                loginPresenter: resolver.resolve(LoginPresenterProtocol.self)!,
                registerUserPresenter: resolver.resolve(RegisterUserPresenterProtocol.self)!,
                navigationController: resolver.resolve(UINavigationController.self)!)
        }

        container.register(RegisterUserPresenterProtocol.self) { resolver in
            RegisterUserPresenter(registerUserInteractor: resolver.resolve(RegisterUserInteractorProtocol.self)!,
                navigationController: resolver.resolve(UINavigationController.self)!)
        }

        container.register(LoginPresenterProtocol.self) { resolver in
            LoginPresenter(loginInteractor: resolver.resolve(LoginInteractorProtocol.self)!,
                navigationController: resolver.resolve(UINavigationController.self)!,
                loginViewController: resolver.resolve(LoginViewController.self)!)
        }

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
            navigationController: resolver.resolve(UINavigationController.self)!) }

        container.register(MobileAuthPresenterProtocol.self) { resolver in MobileAuthPresenter(resolver.resolve(MobileAuthViewController.self)!,
                                                                                               navigationController: resolver.resolve(UINavigationController.self)!,
                                                                                               mobileAuthInteractor: resolver.resolve(MobileAuthInteractorProtocol.self)!) }

        container.register(DisconnectPresenterProtocol.self) { resolver in DisconnectPresenter(disconnectInteractor: resolver.resolve(DisconnectInteractorProtocol.self)!,
            navigationController: resolver.resolve(UINavigationController.self)!) }

        container.register(ChangePinPresenterProtocol.self) { resolver in ChangePinPresenter(changePinInteractor: resolver.resolve(ChangePinInteractorProtocol.self)!,
            navigationController: resolver.resolve(UINavigationController.self)!) }

        container.register(UINavigationController.self) { _ in UINavigationController() }.inObjectScope(.container)
    }
}
