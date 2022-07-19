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

import Swinject
import UIKit

typealias LazyWindow = Lazy<UIWindow>

class RouterAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AppRouterProtocol.self) { resolver in
            AppRouter(window: resolver.resolve(LazyWindow.self)!,
                      startupPresenter: resolver.resolve(StartupPresenterProtocol.self)!,
                      welcomePresenter: resolver.resolve(WelcomePresenterProtocol.self)!,
                      dashboardPresenter: resolver.resolve(DashboardPresenterProtocol.self)!,
                      errorPresenter: resolver.resolve(ErrorPresenterProtocol.self)!,
                      authenticatorsPresenter: resolver.resolve(AuthenticatorsPresenterProtocol.self)!,
                      profilePresenter: resolver.resolve(ProfilePresenterProtocol.self)!,
                      mobileAuthPresenter: resolver.resolve(MobileAuthPresenterProtocol.self)!,
                      disconnectPresenter: resolver.resolve(DisconnectPresenterProtocol.self)!,
                      changePinPresenter: resolver.resolve(ChangePinPresenterProtocol.self)!,
                      pendingMobileAuthPresenter: resolver.resolve(PendingMobileAuthPresenterProtocol.self)!,
                      fetchDeviceListPresenter: resolver.resolve(FetchDeviceListPresenterProtocol.self)!,
                      appDetailsPresenter: resolver.resolve(AppDetailsPresenterProtocol.self)!,
                      appToWebPresenter: resolver.resolve(AppToWebPresenterProtocol.self)!)
        }.inObjectScope(.container)
    }
}
