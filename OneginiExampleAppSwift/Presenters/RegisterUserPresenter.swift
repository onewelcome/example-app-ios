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

protocol RegisterUserInteractorToPresenterProtocol: class {
    func presentBrowserUserRegistrationView(regiserUserEntity: RegisterUserEntity)
    func presentTwoWayOTPRegistrationView(regiserUserEntity: RegisterUserEntity)
    func presentQRCodeRegistrationView(registerUserEntity: RegisterUserEntity)
    func presentCreatePinView(registerUserEntity: RegisterUserEntity)
    func presentDashboardView(authenticatedUserProfile: ONGUserProfile)
    func registerUserActionFailed(_ error: AppError)
    func registerUserActionCancelled()
}

protocol RegisterUserViewToPresenterProtocol {
    func signUp(_ identityProvider: ONGIdentityProvider?)
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
    
    let oneginiRegisterUserPresenter = ONGRegisterUserPresenter()
    var registerUserViewController: RegisterUserViewController? = nil
    
    init(registerUserInteractor: RegisterUserInteractorProtocol, navigationController: UINavigationController, userRegistrationNavigationController: UINavigationController) {
        self.registerUserInteractor = registerUserInteractor
        self.navigationController = navigationController
        self.userRegistrationNavigationController = userRegistrationNavigationController
        self.userRegistrationNavigationController.navigationBar.isHidden = true
        oneginiRegisterUserPresenter.viewSource = self
        oneginiRegisterUserPresenter.delegate = self
    }

    func presentBrowserUserRegistrationView(regiserUserEntity: RegisterUserEntity) {}

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

    func presentCreatePinView(registerUserEntity: RegisterUserEntity) {}

    func presentDashboardView(authenticatedUserProfile: ONGUserProfile) {
        
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
        let identityProviders = registerUserInteractor.identityProviders()
        guard let registerUserViewController = AppAssembly.shared.resolver.resolve(RegisterUserViewController.self, argument: identityProviders) else { fatalError() }
        self.registerUserViewController = registerUserViewController
        oneginiRegisterUserPresenter.setupUserRegistration()
        return registerUserViewController
    }

    func signUp(_ identityProvider: ONGIdentityProvider? = nil) {}

    func handleRedirectURL() {
        registerUserInteractor.handleRedirectURL()
    }

    func handleOTPCode() {
        registerUserInteractor.handleOTPCode()
    }

    
}

extension RegisterUserPresenter: PinViewToPresenterProtocol {
    func handlePin() {}
}

extension RegisterUserPresenter: QRCodeViewDelegate {

    func qrCodeView(_ qrCodeView: UIViewController, didScanQRCode qrCode: String) {
        registerUserInteractor.handleQRCode(qrCode)
    }

    func qrCodeView(didCancelQRCodeScan qrCodeView: UIViewController) {
        registerUserInteractor.handleQRCode(nil)
    }

}

extension RegisterUserPresenter: ONGRegisterUserPresenterViewSource {
    
    func registerUserPresenter(pinViewControllerFor registerUserPresenter: ONGRegisterUserPresenter) -> ONGPinViewController {
        return PinViewController(mode: .registration)
    }
    
    
    func registerUserPresenter(registerUserViewControllerFor registerUserPresenter: ONGRegisterUserPresenter) -> ONGRegisterUserViewController {
        return registerUserViewController!
    }
    
}

extension RegisterUserPresenter: ONGRegisterUserPresenterDelegate {
    
    func registerUserPresenter(_ registerUserPresenter: ONGRegisterUserPresenter, didUserRegistrationFailed error: Error) {
        navigationController.dismiss(animated: false)
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        let mappedError = ErrorMapper().mapError(error)
        appRouter.setupErrorAlert(error: mappedError)
    }
    
    func registerUserPresenter(_ registerUserPresenter: ONGRegisterUserPresenter, didUserRegistrationSucceeded userProfile: ONGUserProfile, info: ONGCustomInfo?) {
        navigationController.dismiss(animated: true)
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupDashboardPresenter(authenticatedUserProfile: userProfile)
    }
    
    func registerUserPresenter(_ registerUserPresenter: ONGRegisterUserPresenter, presentPinViewController: ONGPinViewController) {
        userRegistrationNavigationController.pushViewController(presentPinViewController, animated: true)
    }
    
    func registerUserPresenter(_ registerUserPresenter: ONGRegisterUserPresenter, presentSafariViewController: ONGSafariViewController) {
        userRegistrationNavigationController.viewControllers = [presentSafariViewController]
        navigationController.present(userRegistrationNavigationController, animated: true)
    }
    
    func registerUserPresenterDidCancelUserRegistration(_ registerUserPresenter: ONGRegisterUserPresenter) {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func registerUserPresenter(_ registerUserPresenter: ONGRegisterUserPresenter, presentRegisterUserViewController: ONGRegisterUserViewController) {
        
    }
}
