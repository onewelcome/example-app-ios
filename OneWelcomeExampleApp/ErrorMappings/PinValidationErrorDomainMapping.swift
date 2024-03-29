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

class PinValidationErrorDomainMapping {
    func mapError(_ error: Error) -> AppError {
        let title = "Pin validation error"
        let recoverySuggestion = "Try a different one"

        switch error.code {
        case ONGPinValidationError.pinBlackListed.rawValue:
            let errorDescription = "PIN you've entered is blacklisted."
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: recoverySuggestion)

        case ONGPinValidationError.pinShouldNotBeASequence.rawValue:
            let errorDescription = "PIN you've entered appears to be a sequence."
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: recoverySuggestion)

        case ONGPinValidationError.wrongPinLength.rawValue:
            let requiredLength = String(describing: error.userInfo[ONGPinValidationErrorRequiredLengthKey]!)
            let errorDescription = "PIN has to be of \(requiredLength) characters length."
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: recoverySuggestion)

        case ONGPinValidationError.pinShouldNotUseSimilarDigits.rawValue:
            let maxSimilarDigits = String(describing: error.userInfo[ONGPinValidationErrorMaxSimilarDigitsKey]!)
            let errorDescription = "PIN should not use more that \(maxSimilarDigits) similar digits."
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: recoverySuggestion)

        default:
            return AppError(errorDescription: "Something went wrong.")
        }
    }
}
