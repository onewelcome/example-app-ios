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

import UIKit
import Swinject

class PresenterAssembly: Assembly {
    func assemble(container: Container) {
        container.register(RegisterUserPresenterProtocol.self) { r in
            let registerUserPresenter = RegisterUserPresenter()
            registerUserPresenter.registerUserInteractor = r.resolve(RegisterUserInteractorProtocol.self)!
            return registerUserPresenter
        }
        container.register(StartupPresenterProtocol.self) { _ in StartupPresenter() }
        container.register(WelcomePresenterProtocol.self) { r in
            let welcomePresenter = WelcomePresenter()
            welcomePresenter.loginPresenter = r.resolve(LoginPresenterProtocol.self)!
            welcomePresenter.registerUserPresenter = r.resolve(RegisterUserPresenterProtocol.self)!
            return welcomePresenter
        }
        
        
        container.register(RegisterUserViewToPresenterProtocol.self) { _ in RegisterUserPresenter() }
        container.register(LoginPresenterProtocol.self) { r in
            let loginPresenter = LoginPresenter()
            loginPresenter.loginInteractor = r.resolve(LoginInteractorProtocol.self)!
            return loginPresenter
        }
        
        container.register(DashboardPresenterProtocol.self) { r in
            let dashboardPresenter = DashboardPresenter()
            dashboardPresenter.dashboardInteractor = r.resolve(DashboardInteractorProtocol.self)!
            return dashboardPresenter
        }
    }
}
