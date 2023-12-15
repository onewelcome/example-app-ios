//  Copyright © 2023 OneWelcome. All rights reserved.

import Foundation

class RegistrationErrorDomainMapping {
    func mapError(_ error: Error) -> AppError {
        let title = "Registration error"

        switch ONGRegistrationError(rawValue: error.code) {
        case .stateless:
            let errorDescription = "Stateless registration not available for browser based providers."
            let recoverySuggestion = ""
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: recoverySuggestion)
        default:
            return AppError(errorDescription: "Something went wrong.")
        }
    }
}
