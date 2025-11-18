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

class AuthenticatorRegistrationErrorDomainMapping {
    func mapError(_ error: Error, customInfo: CustomInfo?) -> AppError {
        if let customInfo = customInfo, error.code == AuthenticatorRegistrationError.customAuthenticatorFailure.rawValue {
            return AuthenticatorRegistrationErrorDomainMapping().mapErrorWithCustomInfo(customInfo)
        } else {
            return AuthenticatorRegistrationErrorDomainMapping().mapError(error)
        }
    }
}

private extension AuthenticatorRegistrationErrorDomainMapping {
    var title: String { "Authenticator Registration error" }

    func mapError(_ error: Error) -> AppError {
        switch AuthenticatorRegistrationError(rawValue: error.code) {
        case .userNotAuthenticated:
            let errorDescription = "A user must be authenticated in order to register an authenticator."
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: "Try authenticate user.", shouldLogout: true)

        case .authenticatorInvalid:
            let errorDescription = "The authenticator that you provided is invalid. It may not exist, please verify whether you have supplied the correct authenticator."
            return AppError(title: title, errorDescription: errorDescription)

        case .customAuthenticatorFailure:
            let errorDescription = "Custom authenticator registration has failed."
            return AppError(title: title, errorDescription: errorDescription)

        default:
            return AppError(errorDescription: "Something went wrong.")
        }
    }

    func mapErrorWithCustomInfo(_ customInfo: CustomInfo) -> AppError {
        if customInfo.status >= 4000 && customInfo.status < 5000 {
            let message = "Authenticator registration failed"
            return AppError(title: title, errorDescription: message)
        } else {
            return AppError(errorDescription: "Something went wrong.")
        }
    }
}
