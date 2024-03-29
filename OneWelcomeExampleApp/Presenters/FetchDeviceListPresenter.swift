//
// Copyright © 2022 OneWelcome. All rights reserved.
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

typealias FetchDeviceListPresenterProtocol = FetchDeviceListInteractorToPresenterProtocol

protocol FetchDeviceListInteractorToPresenterProtocol: AnyObject {
    func presentDeviceList(_ deviceList: [Device])
    func setupDeviceListPresenter()
    func fetchDeviceListFailed(_ error: AppError)
}

class FetchDeviceListPresenter: FetchDeviceListPresenterProtocol {
    let navigationController: UINavigationController
    let fetchDeviceListInteractor: FetchDeviceListInteractorProtocol
    var profilePresenter: ProfilePresenterProtocol

    init(fetchDeviceListInteractor: FetchDeviceListInteractorProtocol, profilePresenter: ProfilePresenterProtocol, navigationController: UINavigationController) {
        self.fetchDeviceListInteractor = fetchDeviceListInteractor
        self.navigationController = navigationController
        self.profilePresenter = profilePresenter
    }

    func setupDeviceListPresenter() {
        fetchDeviceListInteractor.fetchDeviceList()
    }

    func presentDeviceList(_ deviceList: [Device]) {
        let deviceListViewController = DeviceListViewController()
        deviceListViewController.deviceList = deviceList
        deviceListViewController.delegate = self
        navigationController.present(deviceListViewController, animated: true, completion: nil)
    }

    func fetchDeviceListFailed(_ error: AppError) {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupErrorAlert(error: error) { [weak self] _ in
            self?.profilePresenter.updateView()
            guard error.shouldLogout else { return }
            self?.navigationController.popToRootViewController(animated: true)
        }
    }
}

extension FetchDeviceListPresenter: DeviceListDelegate {
    func deviceListDidCancel(_ deviceListViewController: DeviceListViewController) {
        deviceListViewController.dismiss(animated: true, completion: nil)
        profilePresenter.updateView()
    }
}
