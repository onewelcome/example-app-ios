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

import Swinject
import UIKit

typealias StartupPresenterProtocol = StartupInteractorToPresenterProtocol

protocol StartupInteractorToPresenterProtocol {
    func oneigniSDKStartup()
    var startupViewController: StartupViewController { get set }
}

class StartupPresenter: StartupInteractorToPresenterProtocol {
    var startupViewController: StartupViewController
    let oneginiStartupPresenter: ONGStartupPresenter

    init() {
        guard let startupViewController = AppAssembly.shared.resolver.resolve(StartupViewController.self) else { fatalError() }
        self.startupViewController = startupViewController
        oneginiStartupPresenter = ONGStartupPresenter()
        oneginiStartupPresenter.delegate = self
    }

    func oneigniSDKStartup() {
        startupViewController.state = .loading
        oneginiStartupPresenter.startStartup(with: Config())
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

extension StartupPresenter: ONGStartupPresenterDelegate {
    
    func startupPresenter(_ startupPresenter: ONGStartupPresenter, didFailStartupSDK error: Error) {
        startupViewController.state = .loaded
        let appError = ErrorMapper().mapError(error)
        let errorAlert = self.createErrorAlert(error: appError, retryHandler: { _ in
            self.oneigniSDKStartup()
        })
        startupViewController.present(errorAlert, animated: true, completion: nil)
    }

    func startupPresenter(didStartSDK startupPresenter: ONGStartupPresenter) {
        startupViewController.state = .loaded
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupTabBar()
    }

}

class Config: Configuration {
    var certificates: [String] = ["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"]

    var configuration: [String: String] = ["ONGAppIdentifier": "ExampleApp",
        "ONGAppPlatform": "ios",
        "ONGAppVersion": "5.0.0",
        "ONGAppBaseURL": "https://onegini-msp-snapshot.test.onegini.io",
        "ONGResourceBaseURL": "https://onegini-msp-snapshot.test.onegini.io/resources",
        "ONGRedirectURL": "oneginiexample://loginsuccess"]

    var jailbreakDetection: Bool? = false

    var debugDetection: Bool? = false

    var debugLogs: Bool? = true


}
