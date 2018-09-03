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
    var window: UIWindow { get set }
    var startupPresenter: StartupPresenterProtocol { get }
    var welcomePresenter: WelcomePresenterProtocol { get }
    var dashboardPresenter: DashboardPresenterProtocol { get }
    var errorPresenter: ErrorPresenterProtocol { get }
    var authenticatorsPresenter: AuthenticatorsPresenterProtocol { get }
    var profilePresenter: ProfilePresenterProtocol { get }
    var mobileAuthPresenter: MobileAuthPresenterProtocol { get }
    var disconnectPresenter: DisconnectPresenterProtocol { get }
    var pendingMobileAuthPresenter: PendingMobileAuthPresenterProtocol { get }
    
    func popToDashboardView()
    func popToWelcomeViewWithLogin(profile: ONGUserProfile)
    func popToWelcomeViewControllerWithRegisterUser()
    func popToWelcomeViewController()
    func popToProfileView()

    func setupErrorAlert(error: AppError)
    func setupErrorAlertWithRetry(error: AppError, retryHandler: @escaping ((UIAlertAction) -> Void))

    func setupStartupPresenter()
    func setupWelcomePresenter()
    func setupDashboardPresenter(authenticatedUserProfile: ONGUserProfile)
    func setupAuthenticatorsPresenter()
    func setupProfilePresenter()
    func setupMobileAuthPresenter()
    func setupDisconnectPresenter()
    func setupChangePinPresenter()
    func setupTabBar()
}

class AppRouter: NSObject, AppRouterProtocol {
    var window: UIWindow
    
    var tabBarController = AppAssembly.shared.resolver.resolve(TabBarController.self)
    var navigationController = AppAssembly.shared.resolver.resolve(UINavigationController.self)
    
    var startupPresenter: StartupPresenterProtocol
    var welcomePresenter: WelcomePresenterProtocol
    var dashboardPresenter: DashboardPresenterProtocol
    var errorPresenter: ErrorPresenterProtocol
    var authenticatorsPresenter: AuthenticatorsPresenterProtocol
    var profilePresenter: ProfilePresenterProtocol
    var mobileAuthPresenter: MobileAuthPresenterProtocol
    var disconnectPresenter: DisconnectPresenterProtocol
    var changePinPresenter: ChangePinPresenterProtocol
    var pendingMobileAuthPresenter: PendingMobileAuthPresenterProtocol

    init(window: UIWindow,
         startupPresenter: StartupPresenterProtocol,
         welcomePresenter: WelcomePresenterProtocol,
         dashboardPresenter: DashboardPresenterProtocol,
         errorPresenter: ErrorPresenterProtocol,
         authenticatorsPresenter: AuthenticatorsPresenterProtocol,
         profilePresenter: ProfilePresenterProtocol,
         mobileAuthPresenter: MobileAuthPresenterProtocol,
         disconnectPresenter: DisconnectPresenterProtocol,
         changePinPresenter: ChangePinPresenterProtocol,
         pendingMobileAuthPresenter: PendingMobileAuthPresenterProtocol) {
        self.window = window
        self.window.backgroundColor = UIColor.white
        self.window.makeKeyAndVisible()
        self.startupPresenter = startupPresenter
        self.welcomePresenter = welcomePresenter
        self.dashboardPresenter = dashboardPresenter
        self.errorPresenter = errorPresenter
        self.authenticatorsPresenter = authenticatorsPresenter
        self.profilePresenter = profilePresenter
        self.mobileAuthPresenter = mobileAuthPresenter
        self.disconnectPresenter = disconnectPresenter
        self.changePinPresenter = changePinPresenter
        self.pendingMobileAuthPresenter = pendingMobileAuthPresenter
    }

    func popToDashboardView() {
        dashboardPresenter.popToDashboardView()
    }

    func popToWelcomeViewWithLogin(profile: ONGUserProfile) {
        welcomePresenter.popToWelcomeViewControllerWithLogin(profile: profile)
    }

    func popToWelcomeViewControllerWithRegisterUser() {
        welcomePresenter.popToWelcomeViewControllerWithRegisterUser()
    }

    func popToWelcomeViewController() {
        welcomePresenter.popToWelcomeViewController()
    }

    func popToProfileView() {
        profilePresenter.popToProfileView()
    }

    func setupErrorAlert(error: AppError) {
        errorPresenter.showErrorAlert(error: error)
    }

    func setupErrorAlertWithRetry(error: AppError, retryHandler: @escaping ((UIAlertAction) -> Void)) {
        errorPresenter.showErrorAlertWithRetryAction(error: error, retryHandler: retryHandler)
    }

    func setupStartupPresenter() {
        window.rootViewController = startupPresenter.startupViewController
        startupPresenter.oneigniSDKStartup()
    }
    
    func setupTabBar() {
        navigationController?.viewControllers = [welcomePresenter.welcomeViewController]
        tabBarController?.setup(navigationController: navigationController!, pendingMobileAuthViewController: pendingMobileAuthPresenter.viewDelegate, delegate: self)
        welcomePresenter.presentWelcomeView()
        window.rootViewController = tabBarController
    }

    func setupWelcomePresenter() {
        welcomePresenter.presentWelcomeView()
    }

    func setupDashboardPresenter(authenticatedUserProfile: ONGUserProfile) {
        dashboardPresenter.presentDashboardView(authenticatedUserProfile: authenticatedUserProfile)
    }

    func setupAuthenticatorsPresenter() {
        authenticatorsPresenter.presentAuthenticatorsView()
    }

    func setupProfilePresenter() {
        profilePresenter.presentProfileView()
    }

    func setupMobileAuthPresenter() {
        mobileAuthPresenter.presentMobileAuthView()
    }

    func setupDisconnectPresenter() {
        disconnectPresenter.presentDisconnectAlert()
    }

    func setupChangePinPresenter() {
        changePinPresenter.startChangePinFlow()
    }
}

extension AppRouter : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return viewController != tabBarController.selectedViewController
    }
}
