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
import Swinject

typealias StartupPresenterProtocol = StartupInteractorToPresenterProtocol

protocol StartupInteractorToPresenterProtocol {
    func oneigniSDKStartup()
}

class StartupPresenter : StartupInteractorToPresenterProtocol {
    
    let navigationController = AppNavigationController.shared
    var startUpInteractor: StartupInteractorProtocol?
    
    func oneigniSDKStartup() {
        guard let startupViewController = AppAssembly.shared.resolver.resolve(StartupViewController.self) else { fatalError() }
        navigationController.pushViewController(startupViewController, animated: false)
        startupViewController.state = .loading
        
        guard let startupInteractor = AppAssembly.shared.resolver.resolve(StartupInteractorProtocol.self) else { fatalError() }
        startupInteractor.oneginiSDKStartup { (result, error) in
            startupViewController.state = .loaded
            if let error = error {
                ErrorPresenter().showErrorAlertWithRetryAction(error: error, title: "", retryHandler: { _ in
                    self.navigationController.viewControllers.removeLast()
                    self.oneigniSDKStartup()
                })
            } else {
                self.presentWelcomeView()
            }
        }
    }
    
    func presentWelcomeView() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupWelcomePresenter()
    }
    
}
