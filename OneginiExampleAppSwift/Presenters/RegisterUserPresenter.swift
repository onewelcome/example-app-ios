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

typealias RegisterUserPresenterProtocol = RegisterUserInteractorToPresenterProtocol & RegisterUserViewToPresenterProtocol & PinViewToPresenterProtocol

protocol RegisterUserInteractorToPresenterProtocol: AnyObject {
    func presentBrowserUserRegistrationView(regiserUserEntity: RegisterUserEntity)
    func presentTwoWayOTPRegistrationView(regiserUserEntity: RegisterUserEntity)
    func presentQRCodeRegistrationView(registerUserEntity: RegisterUserEntity)
    func presentCreatePinView(registerUserEntity: RegisterUserEntity)
    func presentDashboardView(authenticatedUserProfile: UserProfile)
    func registerUserActionFailed(_ error: AppError)
    func registerUserActionCancelled()
}

protocol RegisterUserViewToPresenterProtocol {
    func signUp(_ identityProvider: IdentityProvider?)
    func setupRegisterUserView() -> RegisterUserViewController
    func handleRedirectURL()
    func handleOTPCode()
}

class RegisterUserPresenter: RegisterUserInteractorToPresenterProtocol {
    var registerUserInteractor: RegisterUserInteractorProtocol
    let navigationController: UINavigationController
    let userRegistrationNavigationController: UINavigationController
    var pinViewController: PinViewController?
    var twoWayOTPViewController: TwoWayOTPViewController?
    var qrCodeViewController: QRCodeViewController?

    init(registerUserInteractor: RegisterUserInteractorProtocol, navigationController: UINavigationController, userRegistrationNavigationController: UINavigationController) {
        self.registerUserInteractor = registerUserInteractor
        self.navigationController = navigationController
        self.userRegistrationNavigationController = userRegistrationNavigationController
        self.userRegistrationNavigationController.navigationBar.isHidden = true
    }

    func presentBrowserUserRegistrationView(regiserUserEntity: RegisterUserEntity) {
        let browserViewController = BrowserViewController(registerUserEntity: regiserUserEntity, registerUserViewToPresenterProtocol: self)
        userRegistrationNavigationController.viewControllers = [browserViewController]
        navigationController.present(userRegistrationNavigationController, animated: true)
    }

    func presentTwoWayOTPRegistrationView(regiserUserEntity: RegisterUserEntity) {
        if regiserUserEntity.errorMessage != nil {
            twoWayOTPViewController?.reset()
        } else {
            twoWayOTPViewController = TwoWayOTPViewController(registerUserEntity: regiserUserEntity, registerUserViewToPresenterProtocol: self)
            userRegistrationNavigationController.viewControllers = [twoWayOTPViewController!]
            userRegistrationNavigationController.modalPresentationStyle = .overFullScreen
            navigationController.present(userRegistrationNavigationController, animated: false, completion: nil)
        }
    }

    func presentQRCodeRegistrationView(registerUserEntity: RegisterUserEntity) {
        if let errorMessage = registerUserEntity.errorMessage {
            qrCodeViewController?.setupErrorLabel(errorMessage)
        } else {
            qrCodeViewController = QRCodeViewController(qrCodeViewDelegate: self)
            userRegistrationNavigationController.viewControllers = [qrCodeViewController!]
            userRegistrationNavigationController.modalPresentationStyle = .overFullScreen
            navigationController.present(userRegistrationNavigationController, animated: false, completion: nil)
        }
    }

    func presentCreatePinView(registerUserEntity: RegisterUserEntity) {
        if let error = registerUserEntity.pinError {
            let errorDescription = "\(error.errorDescription) \(error.recoverySuggestion)"
            pinViewController?.setupErrorLabel(errorDescription: errorDescription)
        } else {
            pinViewController = PinViewController(mode: .registration, entity: registerUserEntity, viewToPresenterProtocol: self)
            userRegistrationNavigationController.pushViewController(pinViewController!, animated: true)
        }
    }

    func presentDashboardView(authenticatedUserProfile: UserProfile) {
        navigationController.dismiss(animated: true)
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupDashboardPresenter(authenticatedUserProfile: authenticatedUserProfile)
    }

    func registerUserActionFailed(_ error: AppError) {
        navigationController.dismiss(animated: false)
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupErrorAlert(error: error)
    }

    func registerUserActionCancelled() {
        navigationController.dismiss(animated: false)
    }
}

extension RegisterUserPresenter: RegisterUserViewToPresenterProtocol {
    func setupRegisterUserView() -> RegisterUserViewController {
        let identityProviders = registerUserInteractor.identityProviders
        guard let registerUserViewController = AppAssembly.shared.resolver.resolve(RegisterUserViewController.self, argument: identityProviders) else { fatalError() }
        return registerUserViewController
    }

    func signUp(_ identityProvider: IdentityProvider? = nil) {
        registerUserInteractor.startUserRegistration(identityProvider: identityProvider)
    }

    func handleRedirectURL() {
        registerUserInteractor.handleRedirectURL()
    }

    func handleOTPCode() {
        registerUserInteractor.handleOTPCode()
    }

    
}

extension RegisterUserPresenter: PinViewToPresenterProtocol {
    func handlePin() {
        registerUserInteractor.handleCreatedPin()
    }
}

extension RegisterUserPresenter: QRCodeViewDelegate {
    
    func qrCodeView(_ qrCodeView: UIViewController, didScanQRCode qrCode: String) {
        registerUserInteractor.handleQRCode(qrCode)
    }
    
    func qrCodeView(didCancelQRCodeScan qrCodeView: UIViewController) {
        registerUserInteractor.handleQRCode(nil)
    }
    
}
