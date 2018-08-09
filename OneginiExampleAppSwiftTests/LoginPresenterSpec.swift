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
