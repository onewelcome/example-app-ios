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

import Swinject

class InteractorAssembly: Assembly {
    func assemble(container: Container) {
        container.register(StartupInteractorProtocol.self) { _ in StartupInteractor() }
        container.register(LoginInteractorProtocol.self) { _ in LoginInteractor() }
            .initCompleted { resolver, instance in
                let loginInteractor = instance as! LoginInteractor
                loginInteractor.delegate = resolver.resolve(LoginPresenterProtocols.self)!
            }
        container.register(RegisterUserInteractorProtocol.self) { _ in RegisterUserInteractor() }
            .initCompleted { resolver, instance in
                let registerUserInteractor = instance as! RegisterUserInteractor
                registerUserInteractor.registerUserPresenter = resolver.resolve(RegisterUserPresenterProtocol.self)
            }
        container.register(LogoutInteractorProtocol.self) { _ in LogoutInteractor() }
            .initCompleted { resolver, instance in
                let logoutInteractor = instance as! LogoutInteractor
                logoutInteractor.dashboardPresenter = resolver.resolve(DashboardPresenterProtocol.self)
            }
        container.register(DisconnectInteractorProtocol.self) { _ in DisconnectInteractor() }
            .initCompleted { resolver, instance in
                let disconnectInteractor = instance as! DisconnectInteractor
                disconnectInteractor.disconnectPresenter = resolver.resolve(DisconnectPresenterProtocol.self)
            }
        container.register(ChangePinInteractorProtocol.self) { _ in ChangePinInteractor() }
            .initCompleted { resolver, instance in
                let changePinInteractor = instance as! ChangePinInteractor
                changePinInteractor.changePinPresenter = resolver.resolve(ChangePinPresenterProtocol.self)
            }
        container.register(MobileAuthInteractorProtocol.self) { _ in MobileAuthInteractor() }
        container.register(AuthenticatorsInteractorProtocol.self) { _ in AuthenticatorsInteractor() }
            .initCompleted { resolver, instance in
                let authenticatorsInteractor = instance as! AuthenticatorsInteractor
                authenticatorsInteractor.authenticatorsPresenter = resolver.resolve(AuthenticatorsPresenterProtocol.self)
            }

        container.register(MobileAuthInteractorProtocol.self) { _ in MobileAuthInteractor() }
            .initCompleted { resolver, instance in
                let mobileAuthInteractor = instance as! MobileAuthInteractor
                mobileAuthInteractor.mobileAuthPresenter = resolver.resolve(MobileAuthPresenterProtocol.self)
            }

        container.register(FetchDeviceListInteractorProtocol.self) { _ in FetchDeviceListInteractor() }
            .initCompleted { resolver, instance in
                let fetchDeviceListInteractor = instance as! FetchDeviceListInteractor
                fetchDeviceListInteractor.fetchDeviceListPresenter = resolver.resolve(FetchDeviceListPresenterProtocol.self)
            }

        container.register(AppDetailsInteractorProtocol.self) { _ in AppDetailsInteractor() }
            .initCompleted { resolver, instance in
                let appDetailsInteractor = instance as! AppDetailsInteractor
                appDetailsInteractor.appDetailsPresenter = resolver.resolve(AppDetailsPresenterProtocol.self)
            }

        container.register(FetchImplicitDataInteractorProtocol.self) { _ in FetchImplicitDataInteractor() }
        
        container.register(AppToWebInteractorProtocol.self) { _ in AppToWebInteractor() }
    }
}
