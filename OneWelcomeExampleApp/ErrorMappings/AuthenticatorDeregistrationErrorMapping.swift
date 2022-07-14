//
// Copyright (c) 2022 OneWelcome. All rights reserved.
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

class AuthenticatorDeregistrationErrorMapping {
    let title = "Authenticator Deregistration error"
    
    func mapError(_ error: Error) -> AppError {
        switch error.code {
        case ONGAuthenticatorDeregistrationError.deregistrationErrorUserNotAuthenticated.rawValue:
            let errorDescription = "A user must be authenticated in order to deregister an authenticator."
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: "Try authenticate user.")

        case ONGAuthenticatorDeregistrationError.deregistrationErrorDeregisteredLocally.rawValue:
            let errorDescription = "Authenticator was deregister only locally."
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: "")

        default:
            return AppError(errorDescription: "Something went wrong.")
        }
    }
}
