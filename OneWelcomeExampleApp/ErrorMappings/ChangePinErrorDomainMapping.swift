//  Copyright © 2023 OneWelcome. All rights reserved.

import Foundation

class ChangePinErrorDomainMapping {
    func mapError(_ error: Error) -> AppError {
        let title = "Change PIN error"

        switch ChangePinError(rawValue: error.code) {
        case .statelessUser:
            let errorDescription = "Changing PIN is not allowed for stateless user."
            let recoverySuggestion = ""
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: recoverySuggestion)
        default:
            return AppError(errorDescription: "Something went wrong.")
        }
    }
}
