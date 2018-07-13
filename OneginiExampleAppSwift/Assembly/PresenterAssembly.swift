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
        container.register(StartupPresenterProtocol.self) { r in
            StartupPresenter(startupInteractor: r.resolve(StartupInteractorProtocol.self)!, navigationController: r.resolve(UINavigationController.self)!)
        }

        container.register(WelcomePresenterProtocol.self) { r in
            WelcomePresenter(loginPresenter: r.resolve(LoginPresenterProtocol.self)!,
                             registerUserPresenter: r.resolve(RegisterUserPresenterProtocol.self)!,
                             navigationController: r.resolve(UINavigationController.self)!)
        }

        container.register(RegisterUserPresenterProtocol.self) { r in
            RegisterUserPresenter(registerUserInteractor: r.resolve(RegisterUserInteractorProtocol.self)!,
                                  navigationController: r.resolve(UINavigationController.self)!)
        }

        container.register(LoginPresenterProtocol.self) { r in
            LoginPresenter(loginInteractor: r.resolve(LoginInteractorProtocol.self)!)
        }

        container.register(DashboardPresenterProtocol.self) { r in
            DashboardPresenter(logoutInteractor: r.resolve(LogoutInteractorProtocol.self)!, navigationController: r.resolve(UINavigationController.self)!)
        }

        container.register(ErrorPresenterProtocol.self) { r in
            ErrorPresenter(navigationController: r.resolve(UINavigationController.self)!)
        }

        container.register(UINavigationController.self) { _ in UINavigationController() }.inObjectScope(.container)
    }
}
