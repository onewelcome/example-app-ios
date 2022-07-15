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

typealias ChangePinPresenterProtocol = ChangePinInteractorToPresenterProtocol

protocol ChangePinInteractorToPresenterProtocol: AnyObject {
    func startChangePinFlow()
    func presentLoginPinView(changePinEntity: ChangePinEntity)
    func presentCreatePinView(changePinEntity: ChangePinEntity)
    func presentProfileView()
    func presentChangePinAlert()
    func changePinActionFailed(_ error: AppError)
    func popToWelcomeViewWithError(_ error: AppError)
}

class ChangePinPresenter: ChangePinInteractorToPresenterProtocol {
    let navigationController: UINavigationController
    let changePinNavigationController: UINavigationController
    let changePinInteractor: ChangePinInteractorProtocol
    var authenticationPinViewController: PinViewController?
    var registrationPinViewController: PinViewController?

    init(changePinInteractor: ChangePinInteractorProtocol, navigationController: UINavigationController, changePinNavigationController: UINavigationController) {
        self.navigationController = navigationController
        self.changePinInteractor = changePinInteractor
        self.changePinNavigationController = changePinNavigationController
        self.changePinNavigationController.navigationBar.isHidden = true
    }

    func startChangePinFlow() {
        changePinInteractor.changePin()
    }

    func presentLoginPinView(changePinEntity: ChangePinEntity) {
        if let error = changePinEntity.pinError {
            let errorDescription = "\(error.errorDescription) \(error.recoverySuggestion)"
            authenticationPinViewController?.setupErrorLabel(errorDescription: errorDescription)
        } else {
            authenticationPinViewController = PinViewController(mode: .login, entity: changePinEntity, viewToPresenterProtocol: self)
            changePinNavigationController.viewControllers = [authenticationPinViewController!]
            navigationController.present(changePinNavigationController, animated: true)
        }
    }

    func presentCreatePinView(changePinEntity: ChangePinEntity) {
        if let error = changePinEntity.pinError {
            let errorDescription = "\(error.errorDescription) \(error.recoverySuggestion)"
            registrationPinViewController?.setupErrorLabel(errorDescription: errorDescription)
        } else {
            registrationPinViewController = PinViewController(mode: .registration, entity: changePinEntity, viewToPresenterProtocol: self)
            changePinNavigationController.pushViewController(registrationPinViewController!, animated: false)
        }
    }
    
    func presentChangePinAlert() {
        let message = "Your password has been changed successfully."
        let alert = UIAlertController(title: "Change Pin", message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defaultAction)

        navigationController.present(alert, animated: true, completion: nil)
    }

    func presentProfileView() {
        navigationController.dismiss(animated: true)
    }

    func popToWelcomeViewWithError(_ error: AppError) {
        navigationController.dismiss(animated: true)
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.updateWelcomeView(selectedProfile: nil)
        appRouter.popToWelcomeView()
        appRouter.setupErrorAlert(error: error)
    }

    func changePinActionFailed(_ error: AppError) {
        navigationController.dismiss(animated: true)
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupErrorAlert(error: error)
    }
}

extension ChangePinPresenter: PinViewToPresenterProtocol {
    func handlePin() {
        changePinInteractor.handlePin()
    }
}
