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

typealias DashboardPresenterProtocol = DashboardInteractorToPresenterProtocol & DashboardViewToPresenterProtocol

protocol DashboardInteractorToPresenterProtocol: class {
    func presentDashboardView()
    func presentWelcomeView()
}

protocol DashboardViewToPresenterProtocol {
    func logout()
}

class DashboardPresenter: DashboardInteractorToPresenterProtocol {
    let navigationController: UINavigationController
    var logoutInteractor: LogoutInteractorProtocol

    init(logoutInteractor: LogoutInteractorProtocol, navigationController: UINavigationController) {
        self.logoutInteractor = logoutInteractor
        self.navigationController = navigationController
    }

    func presentDashboardView() {
        let dashboardViewController = DashboardViewController(self)
        navigationController.pushViewController(dashboardViewController, animated: true)
    }

    func presentWelcomeView() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupWelcomePresenter()
    }
}

extension DashboardPresenter: DashboardViewToPresenterProtocol {
    func logout() {
        logoutInteractor.logout()
    }
}
