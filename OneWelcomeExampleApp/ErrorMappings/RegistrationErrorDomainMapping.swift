//  Copyright © 2023 OneWelcome. All rights reserved.

import Foundation

class RegistrationErrorDomainMapping {
    func mapError(_ error: Error) -> AppError {
        let title = "Registration error"

        switch RegistrationError(rawValue: error.code) {
        default:
            return AppError(errorDescription: "Something went wrong.")
        }
    }
}
