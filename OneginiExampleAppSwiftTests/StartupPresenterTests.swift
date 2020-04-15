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

import Nimble
import Quick

class StartupPresenterTests: QuickSpec {
    override func spec() {
        describe("StartupPresenter") {
            var startupPresenter: StartupPresenter?
            var startupInteractor: StartupInteractorMock?
            var navigationController: UINavigationController?
            var router: AppRouterMock?
            beforeEach {
                router = try? container.resolve() as AppRouterProtocol as! AppRouterMock
                startupInteractor = StartupInteractorMock()
                navigationController = UINavigationController()
                startupPresenter = StartupPresenter(startupInteractor: startupInteractor!, navigationController: navigationController!)
            }
            it("should present startup view controller") {
                startupPresenter?.oneigniSDKStartup()
                expect(navigationController?.visibleViewController).to(beAKindOf(StartupViewController.self))
            }
            it("should call oneginiSDKStartup method on startup intercator") {
                startupPresenter?.oneigniSDKStartup()
                expect(startupInteractor?.isOneginiSDKStartupMethodCalled).to(beTrue())
            }
            context("when startup interactor complete with success") {
                beforeEach {
                    startupInteractor?.completionMock = (true, nil)
                }
                it("should setup welcome presenter") {
                    startupPresenter?.oneigniSDKStartup()
                    expect(router?.isSetupWelcomePresenterMethodCalled).to(beTrue())
                }
            }
            context("when startup interactor complete with error") {
                beforeEach {
                    let error = NSError()
                    startupInteractor?.completionMock = (false, error)
                }
                it("should setup error with retry button") {
                    startupPresenter?.oneigniSDKStartup()
                    expect(router?.isSetupErrorAlertWithRetryMethodCalled).to(beTrue())
                }
            }
        }
    }
}
