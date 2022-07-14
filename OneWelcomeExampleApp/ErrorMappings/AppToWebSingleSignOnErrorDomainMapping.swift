//  Copyright © 2022 OneWelcome. All rights reserved.

class AppToWebSingleSignOnErrorDomainMapping {
    func mapError(_ error: Error) -> AppError {
        let title = "App to web error"
        
        switch error.code {
        case ONGAppToWebSingleSignOnError.userNotAuthenticated.rawValue:
            let errorDescription = "No user is currently authenticated."
            let recoverySuggestion = "Please authenticate user and try again."
            return AppError(title: title, errorDescription: errorDescription, recoverySuggestion: recoverySuggestion)
            
        default:
            return AppError(errorDescription: "Something went wrong.")
        }
    }
}
