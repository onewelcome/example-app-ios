//  Copyright © 2023 OneWelcome. All rights reserved.

class FetchResourceErrorDomainMapping {
    func mapError(_ error: Error) -> AppError {
        switch error.code {
        case FetchResourceError.userNotAuthenticated.rawValue:
            return AppError(errorDescription: "No user is currently authenticated, possibly due to the fact that the access token has expired.",
                            recoverySuggestion: "Please login again.",
                            shouldLogout: true)
        default:
            return AppError(errorDescription: "Something went wrong.",
                            recoverySuggestion: "Please try again.")
        }
    }
}
