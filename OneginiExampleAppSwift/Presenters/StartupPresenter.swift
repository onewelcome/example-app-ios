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

typealias StartupPresenterProtocol = StartupInteractorToPresenterProtocol

protocol StartupInteractorToPresenterProtocol {
    func oneigniSDKStartup()
    var startupViewController: StartupViewController { get set }
}

class StartupPresenter: StartupInteractorToPresenterProtocol {
    var startupInteractor: StartupInteractorProtocol
    var startupViewController: StartupViewController

    init(startupInteractor: StartupInteractorProtocol) {
        self.startupInteractor = startupInteractor
        guard let startupViewController = AppAssembly.shared.resolver.resolve(StartupViewController.self) else { fatalError() }
        self.startupViewController = startupViewController
    }

    func oneigniSDKStartup() {
        startupViewController.state = .loading
        startupInteractor.oneginiSDKStartup { _, error in
            self.startupViewController.state = .loaded
            if let error = error {
                let errorAlert = self.createErrorAlert(error: error, retryHandler: { _ in
                    self.oneigniSDKStartup()
                })
                self.startupViewController.present(errorAlert, animated: true, completion: nil)
            } else {
                guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
                appRouter.setupTabBar()
            }
        }
    }

    func createErrorAlert(error: AppError, retryHandler: @escaping ((UIAlertAction) -> Void)) -> UIAlertController {
        let message = "\(error.errorDescription) \n \(error.recoverySuggestion)"
        let alert = UIAlertController(title: error.title, message: message, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .cancel, handler: retryHandler)
        alert.addAction(retryAction)
        return alert
    }

    func presentWelcomeView() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupWelcomePresenter()
    }
}
