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

protocol DisconnectInteractorProtocol: AnyObject {
    func disconnect()
}

class DisconnectInteractor: DisconnectInteractorProtocol {
    weak var disconnectPresenter: DisconnectInteractorToPresenterProtocol?
    private var userClient: UserClient {
        return SharedUserClient.instance
    }
    
    func disconnect() {
        guard let profile = userClient.authenticatedUserProfile else {
            let mappedError = AppError(title: "Disconnect", errorDescription: "Disconnect is not allowed for stateless user.", recoverySuggestion: "Please logout.")
            self.disconnectPresenter?.disconnectActionFailed(mappedError)
            return
        }
        userClient.deregister(user: profile) { error in
            if let error = error {
                let mappedError = ErrorMapper().mapError(error)
                self.disconnectPresenter?.disconnectActionFailed(mappedError)
            } else {
                self.disconnectPresenter?.popToWelcomeView()
            }
        }
    }
    
}
