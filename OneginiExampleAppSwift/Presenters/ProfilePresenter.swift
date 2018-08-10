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

typealias ProfilePresenterProtocol = ProfileInteractorToPresenterProtocol & ProfileViewToPresenterProtocol

protocol ProfileInteractorToPresenterProtocol: class {
    func presentProfileView()
}

protocol ProfileViewToPresenterProtocol {
    func popToDashboardView()
}

class ProfilePresenter: ProfileInteractorToPresenterProtocol {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func presentProfileView() {
        let profileViewController = ProfileViewController(self)
        navigationController.pushViewController(profileViewController, animated: true)
    }
}


extension ProfilePresenter: ProfileViewToPresenterProtocol {
    
    func popToDashboardView() {
        guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
        appRouter.popToDashboardView()
    }
    
}
