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

class MobileAuthEnrollmentErrorDomainMapping {
    func mapError(_ error: Error) -> AppError {
        let title = "Mobile auth enrollment error"

        switch error.code {
        case ONGMobileAuthEnrollmentError.userNotAuthenticated.rawValue:
            let errorDescription = "No user is currently authenticated."
            let recoverySuggestion = "Please authenticate user and try again."
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: recoverySuggestion)

        case ONGMobileAuthEnrollmentError.deviceAlreadyEnrolled.rawValue:
            let errorDescription = "The device is already enrolled for mobile authentication."
            let recoverySuggestion = "Please authenticate user and try again."
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: recoverySuggestion)

        case ONGMobileAuthEnrollmentError.enrollmentNotAvailable.rawValue:
            let errorDescription = "Mobile authentication enrollment is not available."
            let recoverySuggestion = ""
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: recoverySuggestion)

        case ONGMobileAuthEnrollmentError.userAlreadyEnrolled.rawValue:
            let errorDescription = "The user is already enrolled for mobile authentication on another device."
            let recoverySuggestion = "Please disable mobile authentication on the other device and try again."
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: recoverySuggestion)

        case ONGMobileAuthEnrollmentError.notEnrolled.rawValue:
            let errorDescription = "The user is not enrolled for mobile authentication."
            let recoverySuggestion = "Enroll for mobile authentication."
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: recoverySuggestion)

        default:
            return AppError(errorDescription: "Something went wrong.")
        }
    }
}
