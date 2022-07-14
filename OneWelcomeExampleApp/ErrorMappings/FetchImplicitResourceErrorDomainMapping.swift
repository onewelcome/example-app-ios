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

class FetchImplicitResourceErrorDomainMapping: NSObject {
    func mapError(_ error: Error) -> AppError {
        let title = "Fetching implicit resource error"

        switch error.code {
        case ONGFetchResourceImplicitlyError.implicitResourceErrorUserNotAuthenticatedImplicitly.rawValue:
            let errorDescription = "A selected user isn't currently authenticated implicitly."
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: "Try select this user one more time.")

        default:
            return AppError(errorDescription: "Something went wrong.")
        }
    }
}
