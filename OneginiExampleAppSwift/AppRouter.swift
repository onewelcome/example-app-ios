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

protocol AppRouterProtocol: class {
    var startupPresenter: StartupPresenterProtocol { get }
    var welcomePresenter: WelcomePresenterProtocol { get }
    var dashboardPresenter: DashboardPresenterProtocol { get }
    var errorPresenter: ErrorPresenterProtocol { get }

    func popToWelcomeView()
    func setupStartupPresenter()
    func setupWelcomePresenter()
    func setupDashboardPresenter()
    func setupErrorAlert(error: Error, title: String)
    func setupErrorAlertWithRetry(error: Error, title: String, retryHandler: @escaping ((UIAlertAction) -> Void))
}

class AppRouter: AppRouterProtocol {
    var startupPresenter: StartupPresenterProtocol
    var welcomePresenter: WelcomePresenterProtocol
    var dashboardPresenter: DashboardPresenterProtocol
    var errorPresenter: ErrorPresenterProtocol

    init(startupPresenter: StartupPresenterProtocol,
         welcomePresenter: WelcomePresenterProtocol,
         dashboardPresenter: DashboardPresenterProtocol,
         errorPresenter: ErrorPresenterProtocol) {
        self.startupPresenter = startupPresenter
        self.welcomePresenter = welcomePresenter
        self.dashboardPresenter = dashboardPresenter
        self.errorPresenter = errorPresenter
    }
    
    func popToWelcomeView() {
        welcomePresenter.popToWelcomeViewController()
    }

    func setupStartupPresenter() {
        startupPresenter.oneigniSDKStartup()
    }

    func setupWelcomePresenter() {
        welcomePresenter.presentWelcomeView()
    }

    func setupDashboardPresenter() {
        dashboardPresenter.presentDashboardView()
    }

    func setupErrorAlert(error: Error, title: String) {
        errorPresenter.showErrorAlert(error: error, title: title)
    }

    func setupErrorAlertWithRetry(error: Error, title: String, retryHandler: @escaping ((UIAlertAction) -> Void)) {
        errorPresenter.showErrorAlertWithRetryAction(error: error, title: title, retryHandler: retryHandler)
    }
}
