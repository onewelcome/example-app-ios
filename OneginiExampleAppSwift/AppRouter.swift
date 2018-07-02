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

protocol AppRouterProtocol {
    var startupPresenter: StartupPresenterProtocol? { get set }
    var welcomePresenter: WelcomePresenterProtocol? { get set }
    var dashboardPresenter: DashboardPresenterProtocol? { get set }
    
    func setupStartupPresenter()
    func setupWelcomePresenter()
    func setupDashboardPresenter()
}

class AppRouter: AppRouterProtocol {
    
    var startupPresenter: StartupPresenterProtocol?
    var welcomePresenter: WelcomePresenterProtocol?
    var dashboardPresenter: DashboardPresenterProtocol?
    
    func setupStartupPresenter() {
        guard let startupPresenter = AppAssembly.shared.resolver.resolve(StartupPresenterProtocol.self) else { fatalError() }
        self.startupPresenter = startupPresenter
        startupPresenter.oneigniSDKStartup()
    }
    
    func setupWelcomePresenter() {
        guard let welcomePresenter = AppAssembly.shared.resolver.resolve(WelcomePresenterProtocol.self) else { fatalError() }
        self.welcomePresenter = welcomePresenter
        welcomePresenter.presentWelcomeView()
    }
    
    func setupDashboardPresenter() {
        guard let dashboardPresenter = AppAssembly.shared.resolver.resolve(DashboardPresenterProtocol.self) else { fatalError() }
        self.dashboardPresenter = dashboardPresenter
        dashboardPresenter.presentDashboardView()
    }
}
