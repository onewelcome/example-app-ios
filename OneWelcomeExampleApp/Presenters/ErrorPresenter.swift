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

protocol ErrorPresenterProtocol {
    func showErrorAlert(error: AppError)
    func showErrorAlert(error: AppError, okButtonHandler: ((UIAlertAction) -> Void)?)
    func showErrorAlertWithRetryAction(error: AppError, retryHandler: @escaping ((UIAlertAction) -> Void))
}

extension ErrorPresenterProtocol {
    func showErrorAlert(error: AppError) {
        showErrorAlert(error: error, okButtonHandler: nil)
    }
}

class ErrorPresenter: ErrorPresenterProtocol {
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func showErrorAlert(error: AppError, okButtonHandler: ((UIAlertAction) -> Void)? = nil) {
        let message = "\(error.errorDescription) \n \(error.recoverySuggestion)"
        let alert = UIAlertController(title: error.title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: okButtonHandler)
        alert.addAction(okAction)
        navigationController.present(alert, animated: true, completion: nil)
    }

    func showErrorAlertWithRetryAction(error: AppError, retryHandler: @escaping ((UIAlertAction) -> Void)) {
        let message = "\(error.errorDescription) \n \(error.recoverySuggestion)"
        let alert = UIAlertController(title: error.title, message: message, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .cancel, handler: retryHandler)
        alert.addAction(retryAction)
        navigationController.present(alert, animated: true, completion: nil)
    }
}
