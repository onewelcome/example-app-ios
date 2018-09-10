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

typealias MobileAuthPresenterProtocol = MobileAuthInteractorToPresenterProtocol & MobileAuthViewToPresenterProtocol

protocol MobileAuthInteractorToPresenterProtocol: class {
    func presentMobileAuthView()
    func mobileAuthEnrolled()
    func pushMobileAuthEnrolled()
    func enrollMobileAuthFailed(_ error: AppError)
    func enrollPushMobileAuthFailed(_ error: AppError)
    func presentPinView(mobileAuthEntity: MobileAuthEntity)
    func mobileAuthenticationHandled()
    func mobileAuthenticationFailed(_ error: AppError, completion: @escaping (UIAlertAction) -> Void)
    func mobileAuthenticationCancelled()
}

protocol MobileAuthViewToPresenterProtocol: class {
    func popToDashboardView()
    func enrollForMobileAuth()
    func registerForPushMobileAuth()
    func isUserEnrolledForMobileAuth() -> Bool
    func isUserEnrolledForPushMobileAuth() -> Bool
}

protocol PushMobileAuthEntrollmentProtocol: class {
    func enrollForPushMobileAuth(deviceToken: Data)
    func enrollForPushMobileAuthFailed(_ error: AppError)
}

class MobileAuthPresenter: MobileAuthInteractorToPresenterProtocol {
    let navigationController: UINavigationController
    let mobileAuthInteractor: MobileAuthInteractorProtocol
    let mobileAuthViewController: MobileAuthViewController
    var pinViewController: PinViewController?

    init(_ mobileAuthViewController: MobileAuthViewController, navigationController: UINavigationController, mobileAuthInteractor: MobileAuthInteractorProtocol) {
        self.navigationController = navigationController
        self.mobileAuthInteractor = mobileAuthInteractor
        self.mobileAuthViewController = mobileAuthViewController
    }

    func presentMobileAuthView() {
        navigationController.pushViewController(mobileAuthViewController, animated: true)
    }

    func mobileAuthEnrolled() {
        mobileAuthViewController.stopEnrollMobileAuthAnimation(succeed: true)
    }

    func pushMobileAuthEnrolled() {
        mobileAuthViewController.stopEnrollPushMobileAuthAnimation(succeed: true)
    }

    func enrollMobileAuthFailed(_ error: AppError) {
        mobileAuthViewController.stopEnrollMobileAuthAnimation(succeed: false)
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupErrorAlert(error: error)
    }

    func enrollPushMobileAuthFailed(_ error: AppError) {
        mobileAuthViewController.stopEnrollPushMobileAuthAnimation(succeed: false)
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupErrorAlert(error: error)
    }
    
    func presentPinView(mobileAuthEntity: MobileAuthEntity) {
        if let error = mobileAuthEntity.pinError {
            let errorDescription = "\(error.errorDescription) \(error.recoverySuggestion)"
            pinViewController?.setupErrorLabel(errorDescription: errorDescription)
        } else {
            pinViewController = PinViewController(mode: .login, entity: mobileAuthEntity, viewToPresenterProtocol: self)
            navigationController.present(pinViewController!, animated: true)
        }
    }
    
    func mobileAuthenticationHandled() {
        navigationController.dismiss(animated: true, completion: nil)
    }
    
    func mobileAuthenticationFailed(_ error: AppError, completion: @escaping (UIAlertAction) -> Void) {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        navigationController.dismiss(animated: true, completion: nil)
        appRouter.setupErrorAlert(error: error, okButtonHandler: completion)
    }
    
    func mobileAuthenticationCancelled() {
        navigationController.dismiss(animated: true, completion: nil)
    }

}

extension MobileAuthPresenter: MobileAuthViewToPresenterProtocol {
    func popToDashboardView() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.popToDashboardView()
    }

    func enrollForMobileAuth() {
        mobileAuthInteractor.enrollForMobileAuth()
    }

    func registerForPushMobileAuth() {
        mobileAuthInteractor.registerForPushMessages { succeed in
            if succeed {
                DispatchQueue.main.async(execute: {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.pushMobileAuthEnrollment = self
                    UIApplication.shared.registerForRemoteNotifications()
                })
            }
        }
    }

    func isUserEnrolledForMobileAuth() -> Bool {
        return mobileAuthInteractor.isUserEnrolledForMobileAuth()
    }

    func isUserEnrolledForPushMobileAuth() -> Bool {
        return mobileAuthInteractor.isUserEnrolledForPushMobileAuth()
    }
}

extension MobileAuthPresenter: PushMobileAuthEntrollmentProtocol {
    
    func enrollForPushMobileAuth(deviceToken: Data) {
        mobileAuthInteractor.enrollForPushMobileAuth(deviceToken: deviceToken)
    }

    func enrollForPushMobileAuthFailed(_ error: AppError) {
        enrollForPushMobileAuthFailed(error)
    }

}

extension MobileAuthPresenter: PinViewToPresenterProtocol {
    func handlePin() {
        mobileAuthInteractor.handlePinMobileAuth()
    }
}
