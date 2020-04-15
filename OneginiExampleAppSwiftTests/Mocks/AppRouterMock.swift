//
//  AppRouterMock.swift
//  OneginiExampleAppSwiftTests
//
//  Created by Łukasz Łabuński on 14/04/2020.
//  Copyright © 2020 Onegini. All rights reserved.
//

import UIKit

class AppRouterMock: AppRouterProtocol {
    
    var startupPresenter: StartupPresenterProtocol
    var welcomePresenter: WelcomePresenterProtocol
    var dashboardPresenter: DashboardPresenterProtocol
    var errorPresenter: ErrorPresenterProtocol
    
    var isSetupStartupPresenterMethodCalled = false
    var isSetupWelcomePresenterMethodCalled = false
    var isSetupDashboardPresenterMethodCalled = false
    var isSetupErrorAlertMethodCalled = false
    var isSetupErrorAlertWithRetryMethodCalled = false

    init(startupPresenter: StartupPresenterProtocol,
         welcomePresenter: WelcomePresenterProtocol,
         dashboardPresenter: DashboardPresenterProtocol,
         errorPresenter: ErrorPresenterProtocol) {
        self.startupPresenter = startupPresenter
        self.welcomePresenter = welcomePresenter
        self.dashboardPresenter = dashboardPresenter
        self.errorPresenter = errorPresenter
    }
    
    func setupStartupPresenter() {
        isSetupStartupPresenterMethodCalled = true
    }
    
    func setupWelcomePresenter() {
        isSetupWelcomePresenterMethodCalled = true
    }
    
    func setupDashboardPresenter() {
        isSetupDashboardPresenterMethodCalled = true
    }
    
    func setupErrorAlert(error: Error, title: String) {
        isSetupErrorAlertMethodCalled = true
    }
    
    func setupErrorAlertWithRetry(error: Error, title: String, retryHandler: @escaping ((UIAlertAction) -> Void)) {
        isSetupErrorAlertWithRetryMethodCalled = true
    }
    

}
