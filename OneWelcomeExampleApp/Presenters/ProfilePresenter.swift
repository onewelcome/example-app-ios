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

typealias ProfilePresenterProtocol = ProfileInteractorToPresenterProtocol & ProfileViewToPresenterProtocol

protocol ProfileInteractorToPresenterProtocol: AnyObject {
    func presentProfileView()
}

protocol ProfileViewToPresenterProtocol: AnyObject {
    func popToDashboardView()
    func popToProfileView()
    func setupDisconnectPresenter()
    func setupChangePinPresenter()
    func setupFetchDeviceListPresenter()
    func setupIdToken()
    func updateView()
    func setupRefreshStatelessSessionWebPresenter()
}

class ProfilePresenter: ProfileInteractorToPresenterProtocol {
    private let navigationController: UINavigationController
    private let profileViewController: ProfileViewController
    private let profileInteractor: ProfileInteractorProtocol
    
    init(_ profileViewController: ProfileViewController,
         navigationController: UINavigationController,
         profileInteractor: ProfileInteractorProtocol) {
        self.profileViewController = profileViewController
        self.navigationController = navigationController
        self.profileInteractor = profileInteractor
    }

    func presentProfileView() {
        navigationController.pushViewController(profileViewController, animated: true)
    }
}

extension ProfilePresenter: ProfileViewToPresenterProtocol {
    func setupIdToken() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupIdTokenPresenter()
    }
    
    func popToDashboardView() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.popToDashboardView()
    }

    func popToProfileView() {
        navigationController.popToViewController(profileViewController, animated: true)
    }

    func setupDisconnectPresenter() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupDisconnectPresenter()
    }

    func setupChangePinPresenter() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupChangePinPresenter()
    }

    func setupFetchDeviceListPresenter() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupFetchDeviceListPresenter()
    }
    
    func setupRefreshStatelessSessionWebPresenter() {
        SharedUserClient.instance.refreshStatelessSession { error in
            guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
            
            if let error {
                let message = AppError(errorDescription: error.localizedDescription)
                appRouter.errorPresenter.showErrorAlert(error: message)
            } else {
                let message = AppError(title: "Success",
                                       errorDescription: "Stateless session refreshed.",
                                       recoverySuggestion: "")
                appRouter.errorPresenter.showErrorAlert(error: message)
            }
        }
    }
    
    func updateView() {
        profileViewController.setProfileName(profileInteractor.profileName)
        profileViewController.updateView()
    }
}
