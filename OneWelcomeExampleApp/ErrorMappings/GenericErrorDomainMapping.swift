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

class GenericErrorDomainMapping {
    func mapError(_ error: Error) -> AppError {
        switch error.code {
        case ONGGenericError.networkConnectivityFailure.rawValue, ONGGenericError.serverNotReachable.rawValue:
            return AppError(title: "Connection error", errorDescription: "Failed to connect to the server.")
        case ONGGenericError.userDeregistered.rawValue:
            return AppError(title: "User error", errorDescription: "The users account was deregistered from the device.", recoverySuggestion: "Please try to register user again.")
        case ONGGenericError.deviceDeregistered.rawValue:
            return AppError(title: "Device error", errorDescription: "All users were disconnected from the device.", recoverySuggestion: "Please try to register user again.")
        case ONGGenericError.outdatedOS.rawValue:
            return AppError(title: "OS error", errorDescription: "Your iOS version is no longer accepted by the application.", recoverySuggestion: "Please try to update your iOS.")
        case ONGGenericError.outdatedApplication.rawValue:
            return AppError(title: "Application error", errorDescription: "Your application version is outdated.", recoverySuggestion: "Please try to update your application.")
        case ONGGenericError.unrecoverableDataState.rawValue:
            return AppError(title: "Data storage error",
                            errorDescription: "The data storage is corrupted and cannot be recovered or cleared.",
                            recoverySuggestion: "Please remove the application manually and reinstall.")
        default:
            return AppError(errorDescription: "Something went wrong.")
        }
    }
}
