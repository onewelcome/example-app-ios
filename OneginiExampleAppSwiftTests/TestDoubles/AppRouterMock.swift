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

@testable import OneginiExampleAppSwift
import UIKit

class AppRouterMock: AppRouterProtocol {
    var popToWelcomeViewWithLoginCalled = false
    func popToWelcomeViewWithLogin() {
        popToWelcomeViewWithLoginCalled = true
    }

    var popToWelcomeViewControllerWithRegisterUserCalled = false
    func popToWelcomeViewControllerWithRegisterUser() {
        popToWelcomeViewControllerWithRegisterUserCalled = true
    }

    func setupStartupPresenter() {}

    func setupWelcomePresenter() {}

    var setupDashboardPresenterCalled = false
    func setupDashboardPresenter() {
        setupDashboardPresenterCalled = true
    }

    var setupErrorAlertCalled = false
    func setupErrorAlert(error _: AppError) {
        setupErrorAlertCalled = true
    }

    func setupErrorAlertWithRetry(error _: AppError, retryHandler _: @escaping ((UIAlertAction) -> Void)) {}
}
