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

protocol PendingMobileAuthPresenterProtocol: class {
    var viewDelegate: UIViewController & PendingMobileAuthPresenterViewDelegate { get set }

    func reloadPendingMobileAuth()
    func handlePendingMobileAuth(_ pendingTransaction: PendingMobileAuthRequest)
}

protocol PendingMobileAuthPresenterViewDelegate: class {
    var pendingMobileAuths: Array<PendingMobileAuthRequest> { get set }
    var pendingMobileAuthPresenter: PendingMobileAuthPresenterProtocol? { get set }
}

class PendingMobileAuthPresenter: PendingMobileAuthPresenterProtocol {
    var viewDelegate: UIViewController & PendingMobileAuthPresenterViewDelegate
    var mobileAuthInteractor: MobileAuthInteractorProtocol

    init(pendingMobileAuthViewController: (UIViewController & PendingMobileAuthPresenterViewDelegate), mobileAuthInteractor: MobileAuthInteractorProtocol) {
        viewDelegate = pendingMobileAuthViewController
        self.mobileAuthInteractor = mobileAuthInteractor
    }

    func reloadPendingMobileAuth() {
        mobileAuthInteractor.fetchPendingTransactions { pendingMobileAuths, error in
            if let error = error {
                guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
                appRouter.setupErrorAlert(error: error)
            } else if let pendingMobileAuths = pendingMobileAuths {
                self.viewDelegate.pendingMobileAuths = pendingMobileAuths
            }
        }
    }

    func handlePendingMobileAuth(_ pendingTransaction: PendingMobileAuthRequest) {
        mobileAuthInteractor.handlePendingMobileAuth(pendingTransaction)
    }
}
