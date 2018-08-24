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

class ViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(StartupViewController.self) { _ in StartupViewController() }
        container.register(LoginViewController.self) { _ in LoginViewController() }
            .initCompleted { resolver, loginViewController in
                loginViewController.loginViewToPresenterProtocol = resolver.resolve(LoginPresenterProtocol.self)!
            }
        container.register(RegisterUserViewController.self) { resolver, identityProviders in
            RegisterUserViewController(registerUserViewToPresenterProtocol: resolver.resolve(RegisterUserPresenterProtocol.self)!, identityProviders: identityProviders)
        }

        container.register(WelcomeViewController.self) { _ in WelcomeViewController() }
            .initCompleted { resolver, welcomeViewController in
                welcomeViewController.welcomePresenterProtocol = resolver.resolve(WelcomePresenterProtocol.self)!
            }

        container.register(DashboardViewController.self) { _ in DashboardViewController() }
            .initCompleted { resolver, dashboardViewController in
                dashboardViewController.dashboardViewToPresenterProtocol = resolver.resolve(DashboardPresenterProtocol.self)!
            }

        container.register(ProfileViewController.self) { _ in ProfileViewController() }
            .initCompleted { resolver, profileViewController in
                profileViewController.profileViewToPresenterProtocol = resolver.resolve(ProfilePresenterProtocol.self)!
            }
        container.register((UIViewController & PendingMobileAuthPresenterViewDelegate).self) { _ in PendingMobileAuthViewController() }
            .initCompleted { resolver, pendingMobileAuthViewController in
                pendingMobileAuthViewController.pendingMobileAuthPresenter = resolver.resolve(PendingMobileAuthPresenterProtocol.self)!
            }
    }
}
