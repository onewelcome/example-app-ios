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

import Quick
import Nimble
@testable import OneginiExampleAppSwift

class PinViewControllerEntityStub : PinViewControllerEntityProtocol {
    var pin: String?
    
    var pinError: AppError?
    
    var pinLength: Int?
}

class UserProfileS : NSObject & UserProfileProtocol {
    var profileId: String
    init(profileId: String) {
        self.profileId = profileId
    }
}

class AuthenticatorS : NSObject & AuthenticatorProtocol {
    var identifier: String
    
    var name: String
    
    var type: ONGAuthenticatorType
    
    var isRegistered: Bool
    
    var isPreferred: Bool
    
    init(identifier : String, name : String, type : ONGAuthenticatorType, isRegistered : Bool, isPreferred : Bool) {
        self.identifier = identifier
        self.name = name
        self.type = type
        self.isRegistered = isRegistered
        self.isPreferred = isPreferred
    }
}

class LoginInteractorMock : LoginInteractorProtocol {
    func userProfiles() -> Array<NSObject & UserProfileProtocol> {
        return [UserProfileS(profileId: "profile1")]
    }
    
    func authenticators(profile: NSObject & UserProfileProtocol) -> Array<NSObject & AuthenticatorProtocol> {
        return [AuthenticatorS(identifier: "authenticator1", name: "authenticator1", type: ONGAuthenticatorType.PIN, isRegistered: true, isPreferred: true)]
    }
    var loginCalled = false
    func login(profile: NSObject & UserProfileProtocol) {
        loginCalled = true
    }
    var handleLoginCalled = false
    func handleLogin(loginEntity: PinViewControllerEntityProtocol) {
        handleLoginCalled = true
    }
}

class LoginViewControllerMock : UIViewController & LoginPresenterToViewProtocol {

    var authenticators: Array<NSObject & AuthenticatorProtocol> = []
    
    var profiles: Array<NSObject & UserProfileProtocol> = [UserProfileStub("profile1"), UserProfileStub("profile2")]
    
    var selectedProfile: NSObject & UserProfileProtocol = UserProfileStub("profile1")
    var selectProfileCalled = false
    func selectProfile(index: Int) {
        selectProfileCalled = true
    }
    
    var loginViewToPresenterProtocol: LoginViewToPresenterProtocol?
}

class AppRouterMock : AppRouterProtocol {
    var popToWelcomeViewWithLoginCalled = false
    func popToWelcomeViewWithLogin() {
        popToWelcomeViewWithLoginCalled = true
    }
    var popToWelcomeViewControllerWithRegisterUserCalled = false
    func popToWelcomeViewControllerWithRegisterUser() {
        popToWelcomeViewControllerWithRegisterUserCalled = true
    }
    
    func setupStartupPresenter() {
        
    }
    
    func setupWelcomePresenter() {
    }
    var setupDashboardPresenterCalled = false
    func setupDashboardPresenter() {
        setupDashboardPresenterCalled = true
    }
    var setupErrorAlertCalled = false
    func setupErrorAlert(error: AppError) {
        setupErrorAlertCalled = true
    }
    
    func setupErrorAlertWithRetry(error: AppError, retryHandler: @escaping ((UIAlertAction) -> Void)) {
    }
}

class NavigationControllerMock : UINavigationController {
    var pushViewControllerCalled = false
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewControllerCalled = true
    }
}

class LoginPresenterSpec: QuickSpec {
    override func spec() {
        describe("LoginPresenter") {
            var loginPresenter : LoginPresenter!
            let loginInteractor = LoginInteractorMock()
            let navigationController = NavigationControllerMock()
            let loginViewController = LoginViewControllerMock()
            let appRouterStub = AppRouterMock()
            beforeEach {
                loginPresenter = LoginPresenter(loginInteractor: loginInteractor, navigationController: navigationController, loginViewController: loginViewController)
                loginPresenter.appRouterDelegate = appRouterStub
            }
            describe("LoginInteractorToPresenterProtocol", {
                describe("presentPinView", {
                    it("should push pin on navigation controller") {
                        let loginEntity = LoginEntity();
                        loginPresenter.presentPinView(loginEntity: loginEntity)
                        expect(navigationController.pushViewControllerCalled).toEventually(equal(true))
                    }
                })
                describe("presentDashboard", {
                    it("should push pin on navigation controller") {
                        loginPresenter.presentDashboardView()
                        expect(appRouterStub.setupDashboardPresenterCalled).toEventually(equal(true))
                    }
                })
                describe("loginActionFailed", {
                    it("should pop to welcome view with login") {
                        let appError = AppError(errorDescription: "error")
                        loginPresenter.loginActionFailed(appError)
                        expect(appRouterStub.popToWelcomeViewWithLoginCalled).toEventually(equal(true))
                    }
                    it("should present error"){
                        let appError = AppError(errorDescription: "error")
                        loginPresenter.loginActionFailed(appError)
                        expect(appRouterStub.setupErrorAlertCalled).toEventually(equal(true))
                    }
                })
                describe("loginActionCancelled", {
                    it("should pop to welcome view with login") {
                        let appError = AppError(errorDescription: "error")
                        loginPresenter.loginActionFailed(appError)
                        expect(appRouterStub.popToWelcomeViewWithLoginCalled).toEventually(equal(true))
                    }
                })
            })
            describe("LoginViewToPresenterProtocol") {
                describe("setupLoginView") {
                    it("should set authenticators") {
//                        let loginViewController = loginPresenter.setupLoginView()
//                        let interactorAuthenticators = loginInteractor.authenticators(profile: loginInteractor.userProfiles()[0])
//                        equal(interactorAuthenticators)
//                        expect(loginViewController.authenticators).toEventually(equal(interactorAuthenticators))
                    }
                    it("should set profiles") {
//                        let loginViewController = loginPresenter.setupLoginView()
//                        let interactorProfiles = loginInteractor.userProfiles()
//                        expect(loginViewController.profiles).toEventually(beIdenticalTo(interactorProfiles as [Equatable]))
                    }
                }
                describe("login") {
                    it("should login") {
                        let userProfile = UserProfileStub("profile")
                        loginPresenter.login(profile: userProfile)
                        expect(loginInteractor.loginCalled).toEventually(equal(true))
                    }
                }
                describe("reloadAuthenticators") {
                    it("should set authenticators") {
                        let userProfile = UserProfileStub("profile")
                        loginPresenter.reloadAuthenticators(userProfile)
                        expect(loginViewController.authenticators).toEventuallyNot(beNil())
                    }
                }
            }
            describe("ParentToChildPresenterProtocol") {
                describe("reloadProfiles") {
                    it("should set profiles") {
                        loginPresenter.reloadProfiles()
                    }
                }
                describe("selectLastSelectedProfileAndReloadAuthenticators") {
                    context("with 2 profiles in login viewcontroller") {
                        beforeEach {
                            let userProfile1 = UserProfileStub("profile1")
                            let userProfile2 = UserProfileStub("profile2")
                            loginViewController.selectedProfile = userProfile1
                            loginViewController.profiles = [userProfile1, userProfile2]
                        }
                        it("should select last selected profile and reload authenticators") {
                            loginPresenter.selectLastSelectedProfileAndReloadAuthenticators()
                            expect(loginViewController.selectProfileCalled).toEventually(equal(true))
                        }
                    }
                }
            }
            describe("PinViewToPresenterProtocol") {
                describe("handlePin") {
                    it("should handle login") {
                        loginPresenter.handlePin(entity: PinViewControllerEntityStub())
                        expect(loginInteractor.handleLoginCalled).toEventually(equal(true))
                    }
                }
            }
        }
    }
}
