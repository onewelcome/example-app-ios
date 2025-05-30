//  Copyright © 2025 OneWelcome. All rights reserved.

import Foundation

class MobileAuthRequestErrorDomainMapping {
    func mapError(_ error: Error) -> AppError {
        let title = "Mobile auth request error"
        
        switch ONGMobileAuthRequestError(rawValue: error.code) {
        case .notFound:
            let errorDescription = "The user not found for mobile authentication."
            let recoverySuggestion = "Enroll for mobile authentication."
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: recoverySuggestion)
        case .userDisenrolled:
            let errorDescription = "The user was disenrolled for mobile authentication."
            let recoverySuggestion = "Enroll for mobile authentication."
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: recoverySuggestion)
        case .notEnrolled:
            let errorDescription = "The user is not enrolled for mobile authentication."
            let recoverySuggestion = "Enroll for mobile authentication."
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: recoverySuggestion)
            
        case .userNotAuthenticated:
            let errorDescription = "No user is currently authenticated."
            let recoverySuggestion = "Please authenticate user and try again."
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: recoverySuggestion)
            
        case .notHandleable:
            let errorDescription = "The mobile authentication request cannot be handled."
            let recoverySuggestion = "Please authenticate user and try again."
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: recoverySuggestion)
            
        case .alreadyHandled:
            let errorDescription = "The provided mobile authentication request is already being handled."
            let recoverySuggestion = "Please authenticate user and try again."
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: recoverySuggestion)
            
        default:
            return AppError(errorDescription: "Something went wrong.")
        }
    }
}
