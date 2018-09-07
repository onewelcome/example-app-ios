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

class AuthenticationErrorDomainMapping {
    func mapError(_ error: Error, remainingFailureCount: UInt) -> AppError {
        switch error.code {
        case ONGAuthenticationError.invalidPin.rawValue:
            let remainingFailureCount = String(describing: remainingFailureCount)
            let errorDescription = "PIN you've entered is invalid."
            let title = "Authentication error"
            let recoverySuggestion = "You have still \(remainingFailureCount) attempts left."
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: recoverySuggestion)

        default:
            return AppError(errorDescription: "Something went wrong.")
        }
    }

    func mapError(_: Error) -> AppError {
        return AppError(errorDescription: "Something went wrong.")
    }
}
