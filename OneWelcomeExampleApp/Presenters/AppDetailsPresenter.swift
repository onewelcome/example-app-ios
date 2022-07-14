//
// Copyright (c) 2022 OneWelcome. All rights reserved.
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

typealias AppDetailsPresenterProtocol = AppDetailsInteractorToPresenterProtocol & AppDetailsViewToPresenterProtocol

protocol AppDetailsInteractorToPresenterProtocol: AnyObject {
    var appDetailsViewController: AppDetailsViewController { get set }

    func setupAppDetailsView(_ appDetails: ApplicationDetails)
    func fetchAppDetailsFailed(_ error: AppError)
}

protocol AppDetailsViewToPresenterProtocol: AnyObject {
    func reloadAppDetails()
}

class AppDetailsPresenter: AppDetailsInteractorToPresenterProtocol {
    let navigationController: UINavigationController
    let appDetailsInteractor: AppDetailsInteractorProtocol
    var appDetailsViewController: AppDetailsViewController

    init(_ appDetailsViewController: AppDetailsViewController, appDetailsInteractor: AppDetailsInteractorProtocol, navigationController: UINavigationController) {
        self.appDetailsInteractor = appDetailsInteractor
        self.navigationController = navigationController
        self.appDetailsViewController = appDetailsViewController
    }

    func setupAppDetailsView(_ appDetails: ApplicationDetails) {
        appDetailsViewController.applicationDetails = appDetails
    }

    func fetchAppDetailsFailed(_ error: AppError) {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupErrorAlert(error: error)
    }
}

extension AppDetailsPresenter: AppDetailsViewToPresenterProtocol {
    func reloadAppDetails() {
        appDetailsInteractor.fetchDeviceResources()
    }
}
