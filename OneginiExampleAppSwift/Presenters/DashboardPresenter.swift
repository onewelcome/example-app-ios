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
    func presentDashboardView(authenticatedUserProfile: ONGUserProfile)
    func presentWelcomeView()
    func logoutUserActionFailed(_ error: AppError)
}

protocol DashboardViewToPresenterProtocol: class {
    func logout()
    func presentProfileView()
    func presentAuthenticatorsView()
    func presentMobileAuthView()
    func popToDashboardView()
}

class DashboardPresenter: DashboardInteractorToPresenterProtocol {
    let navigationController: UINavigationController
    var logoutInteractor: LogoutInteractorProtocol
    let dashboardViewController: DashboardViewController
    var authenticatedUserProfile: ONGUserProfile?

    init(_ dashboardViewController: DashboardViewController, logoutInteractor: LogoutInteractorProtocol, navigationController: UINavigationController) {
        self.logoutInteractor = logoutInteractor
        self.dashboardViewController = dashboardViewController
        self.navigationController = navigationController
    }

    func presentDashboardView(authenticatedUserProfile: ONGUserProfile) {
        self.authenticatedUserProfile = authenticatedUserProfile
        dashboardViewController.userProfileName = authenticatedUserProfile.profileId
        navigationController.pushViewController(dashboardViewController, animated: true)
    }

    func presentWelcomeView() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        if let authenticatedUserProfile = authenticatedUserProfile {
            appRouter.popToWelcomeViewWithLogin(profile: authenticatedUserProfile)
        }
    }

    func logoutUserActionFailed(_ error: AppError) {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupErrorAlert(error: error)
    }
}

extension DashboardPresenter: DashboardViewToPresenterProtocol {
    func logout() {
        logoutInteractor.logout()
    }

    func popToDashboardView() {
        navigationController.popToViewController(dashboardViewController, animated: true)
    }

    func presentAuthenticatorsView() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupAuthenticatorsPresenter()
    }

    func presentProfileView() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupProfilePresenter()
    }

    func presentMobileAuthView() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupMobileAuthPresenter()
    }
}
