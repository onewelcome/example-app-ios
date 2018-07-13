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

typealias LoginPresenterProtocol = LoginInteractorToPresenterProtocol & LoginViewToPresenterProtocol

protocol LoginInteractorToPresenterProtocol {
}

protocol LoginViewToPresenterProtocol {
    var profiles: Array<ONGUserProfile> { get set }

    func setupLoginView() -> LoginViewController
}

class LoginPresenter: LoginInteractorToPresenterProtocol {
    var loginInteractor: LoginInteractorProtocol
    var profiles = Array<ONGUserProfile>()

    init(loginInteractor: LoginInteractorProtocol) {
        self.loginInteractor = loginInteractor
    }
}

extension LoginPresenter: LoginViewToPresenterProtocol {
    func setupLoginView() -> LoginViewController {
        profiles = Array(loginInteractor.userProfiles())
        let authenticators = loginInteractor.authenticators(profile: profiles[0])
        guard let loginViewController = AppAssembly.shared.resolver.resolve(LoginViewController.self, arguments: profiles, Array(authenticators)) else { fatalError() }
        return loginViewController
    }
}
