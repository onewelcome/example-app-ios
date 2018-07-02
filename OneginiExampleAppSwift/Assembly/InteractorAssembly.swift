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
        container.register(RegisterUserInteractorProtocol.self) { _ in RegisterUserInteractor() }
            .initCompleted { (r, c) in
                let registerUserInteractor = c as! RegisterUserInteractor
                registerUserInteractor.registerUserPresenter = r.resolve(RegisterUserPresenterProtocol.self)
        }
        container.register(DashboardInteractorProtocol.self) { _ in DashboardInteractor() }
            .initCompleted { (r, c) in
                let dashboardInteractor = c as! DashboardInteractor
                dashboardInteractor.dashboardPresenter = r.resolve(DashboardPresenterProtocol.self)
        }
        container.register(LoginInteractorProtocol.self) { _ in LoginInteractor() }
    }
}
