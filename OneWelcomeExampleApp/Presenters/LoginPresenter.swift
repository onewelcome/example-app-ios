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
import OneginiSDKiOS

typealias LoginPresenterProtocols = LoginPresenterProtocol & LoginViewDelegate & LoginInteractorDelegate

protocol LoginPresenterProtocol: AnyObject {
    func update()
    func updateSelectedProfile(_ profile: UserProfile)
    var profiles: [UserProfile] { get set }
    func setupLoginView() -> LoginViewController
    func presentImplicitData(data: String)
    func fetchImplicitDataFailed(_ error: AppError)
}

protocol LoginPresenterDelegate: AnyObject {
    func loginPresenter(_ loginPresenter: LoginPresenterProtocol, didLoginUser profile: UserProfile)
    func loginPresenter(_ loginPresenter: LoginPresenterProtocol, didFailToLoginUser profile: UserProfile, withError error: AppError)
}

class LoginPresenter: LoginPresenterProtocol {
    
    var loginInteractor: LoginInteractorProtocol
    var profiles = [UserProfile]()
    let navigationController: UINavigationController
    let fetchImplicitDataInteractor: FetchImplicitDataInteractorProtocol
    var loginViewController: LoginViewController
    var pinViewController: PinViewController?
    
    init(loginInteractor: LoginInteractorProtocol,
         fetchImplicitDataInteractor: FetchImplicitDataInteractorProtocol,
         navigationController: UINavigationController,
         loginViewController: LoginViewController) {
        self.loginInteractor = loginInteractor
        self.navigationController = navigationController
        self.loginViewController = loginViewController
        self.fetchImplicitDataInteractor = fetchImplicitDataInteractor
    }
    
    func updateSelectedProfile(_ profile: UserProfile) {
        loginViewController.selectedProfile = profile
    }
    
    func update() {
        reloadProfiles()
        if !profiles.isEmpty {
            updateView()
        }
    }
    
    func setupLoginView() -> LoginViewController {
        loginViewController.profiles = loginInteractor.userProfiles
        return loginViewController
    }

    func reloadProfiles() {
        profiles = loginInteractor.userProfiles
        loginViewController.profiles = profiles
    }
    
    func updateView() {
        if let profile = loginViewController.selectedProfile, profiles.contains(where: { $0.isEqual(to: profile) }) {
            loginViewController.reloadAuthenticators()
            if let index = loginViewController.profiles.firstIndex(where: { $0.isEqual(to: profile) }) {
                loginViewController.selectProfile(index: index)
            }
        } else {
            loginViewController.selectProfile(index: 0)
            loginViewController.reloadAuthenticators()
        }
    }

    func presentImplicitData(data: String) {
        loginViewController.implicitData.text = data
    }

    func fetchImplicitDataFailed(_ error: AppError) {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.setupErrorAlert(error: error)
    }
}

extension LoginPresenter: LoginInteractorDelegate {
    func loginInteractor(_ loginInteractor: LoginInteractorProtocol, didAskForPin loginEntity: LoginEntity) {
        if let error = loginEntity.pinError {
            let errorDescription = "\(error.errorDescription) \(error.recoverySuggestion)"
            pinViewController?.setupErrorLabel(errorDescription: errorDescription)
        } else {
            pinViewController = PinViewController(mode: .login, entity: loginEntity, viewToPresenterProtocol: self)
            navigationController.present(pinViewController!, animated: true, completion: nil)
        }
    }
    
    func loginInteractor(_ loginInteractor: LoginInteractorProtocol, didAskForPassword loginEntity: LoginEntity) {
        let passwordViewController = PasswordAuthenticatorViewController(mode: .login, entity: loginEntity, viewToPresenterProtocol: self)
        passwordViewController.modalPresentationStyle = .overCurrentContext
        navigationController.present(passwordViewController, animated: false, completion: nil)
    }
    
    func loginInteractor(_ loginInteractor: LoginInteractorProtocol, didLoginUser profile: UserProfile) {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        navigationController.dismiss(animated: false, completion: nil)
        appRouter.setupDashboardPresenter(authenticatedUserProfile: profile)
    }
    
    func loginInteractor(_ loginInteractor: LoginInteractorProtocol, didFailToLoginUser profile: UserProfile, withError error: AppError) {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        navigationController.dismiss(animated: false, completion: nil)
        appRouter.updateWelcomeView(selectedProfile: profile)
        appRouter.setupErrorAlert(error: error)
    }
    
    func loginInteractor(_ loginInteractor: LoginInteractorProtocol, didCancelLoginUser profile: UserProfile) {
        navigationController.dismiss(animated: false, completion: nil)
    }
}

extension LoginPresenter: LoginViewDelegate {
    func profilesInLoginView(_ loginView: UIViewController) -> [UserProfile] {
        return loginInteractor.userProfiles
    }

    func loginView(_ loginView: UIViewController, didLoginProfile profile: UserProfile, withAuthenticator authenticator: Authenticator?) {
        loginInteractor.login(profile: profile, authenticator: authenticator)
    }

    func loginView(_ loginView: UIViewController, authenticatorsForProfile profile: UserProfile) -> [Authenticator] {
        return loginInteractor.authenticators(profile: profile)
    }
    
    func loginView(_ loginView: UIViewController, implicitDataForProfile profile: UserProfile, completion: @escaping (String?) -> Void) {
        fetchImplicitDataInteractor.fetchImplicitResources(profile: profile) { (implicitData, _) in
            guard let implicitData = implicitData else {
                completion(nil)
                // Commented because of Bug in Token server, sometimes is returned 401
//                guard let error = error else { return }
//                guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
//                appRouter.setupErrorAlert(error: error)
                return
            }
            completion(implicitData)
        }
    }
}

extension LoginPresenter: PinViewToPresenterProtocol {
    func handlePinPolicy(pin: String, completion: (Error?) -> Void) {
        // TODO: implement if needed
    }
    
    func handlePin() {
        loginInteractor.handleLogin()
    }
}

extension LoginPresenter: PasswordAuthenticatorViewToPresenterProtocol {
    func handlePassword() {
        loginInteractor.handlePasswordAuthenticatorLogin()
    }
}
