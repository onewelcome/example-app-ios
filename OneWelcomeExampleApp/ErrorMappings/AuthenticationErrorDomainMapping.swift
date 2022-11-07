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

class AuthenticationErrorDomainMapping {
    let title = "Authentication error"

    func mapErrorWithPinChallenge(pinChallenge: PinChallenge) -> AppError {
        let remainingFailureCount = String(describing: pinChallenge.remainingFailureCount)
        let errorDescription = "PIN you've entered is invalid."
        let recoverySuggestion = "You have still \(remainingFailureCount) attempts left."
        return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: recoverySuggestion)
    }

    func mapErrorWithCustomInfo(_ customInfo: CustomInfo) -> AppError {
        if customInfo.status >= 4000 && customInfo.status < 5000 {
            let message = "Authentication failed"
            return AppError(title: title, errorDescription: message)
        } else {
            return AppError(errorDescription: "Something went wrong.")
        }
    }

    func mapError(_ error: Error) -> AppError {
        switch error.code {
        case AuthenticationError.authenticatorDeregistered.rawValue:
            let message = "The Authenticator has been deregistered."
            let recoverySuggestion = "Please register used authenticator and try again."
            return AppError(title: title, errorDescription: message, recoverySuggestion: recoverySuggestion)

        case AuthenticationError.authenticatorInvalid.rawValue:
            let message = "The authenticator that you provided is invalid."
            let recoverySuggestion = "It may not exist, please verify whether you have supplied the correct authenticator."
            return AppError(title: title, errorDescription: message, recoverySuggestion: recoverySuggestion)

        case AuthenticationError.touchIDAuthenticatorFailure.rawValue:
            let message = "Authentication with the biometric authenticator has failed."
            return AppError(title: title, errorDescription: message)

        default:
            return AppError(errorDescription: "Something went wrong.")
        }
    }
}
