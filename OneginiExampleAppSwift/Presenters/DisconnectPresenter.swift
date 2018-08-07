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

typealias DisconnectPresenterProtocol = DisconnectInteractorToPresenterProtocol

protocol DisconnectInteractorToPresenterProtocol: class {
    func presentDisconnectAlert()
    func disconnectActionFailed(_ error: AppError)
    func popToWelcomeView()
}

class DisconnectPresenter: DisconnectInteractorToPresenterProtocol {
    let navigationController: UINavigationController
    let disconnectInteractor: DisconnectInteractorProtocol

    init(disconnectInteractor: DisconnectInteractorProtocol, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.disconnectInteractor = disconnectInteractor
    }

    func presentDisconnectAlert() {
        let message = "Are you sure you want to disconnect your profile?"
        let alert = UIAlertController(title: "Disconnect profile", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        let disconnectAction = UIAlertAction(title: "Disconnect", style: .default) { _ in
            self.disconnectInteractor.disconnect()
        }
        alert.addAction(disconnectAction)

        navigationController.present(alert, animated: true, completion: nil)
    }

    func popToWelcomeView() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.popToWelcomeViewControllerDependsOnProfileArray()
    }

    func disconnectActionFailed(_ error: AppError) {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupErrorAlert(error: error)
    }
}
