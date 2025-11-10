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

class ErrorMapper {
    func mapError(_ error: Error, pinChallenge: PinChallenge? = nil, customInfo: CustomInfo? = nil) -> AppError {
        switch error.domain {
        case ErrorDomains.generic:
            return GenericErrorDomainMapping().mapError(error)
        case ErrorDomains.pinValidation:
            return PinValidationErrorDomainMapping().mapError(error)
        case ErrorDomains.authentication:
            return AuthenticationErrorDomainMapping().mapError(error, pinChallenge: pinChallenge, customInfo: customInfo)
        case ErrorDomains.authenticatorRegistration:
            return AuthenticatorRegistrationErrorDomainMapping().mapError(error, customInfo: customInfo)
        case ErrorDomains.authenticatorDeregistration:
            return AuthenticatorDeregistrationErrorMapping().mapError(error)
        case ErrorDomains.mobileAuthEnrollment:
            return MobileAuthEnrollmentErrorDomainMapping().mapError(error)
        case ErrorDomains.fetchResource:
            return FetchResourceErrorDomainMapping().mapError(error)
        case ErrorDomains.fetchImplicitResource:
            return FetchImplicitResourceErrorDomainMapping().mapError(error)
        case ErrorDomains.appToWebSingleSignOn:
            return AppToWebSingleSignOnErrorDomainMapping().mapError(error)
        case ErrorDomains.changePin:
            return ChangePinErrorDomainMapping().mapError(error)
        case ErrorDomains.registration:
            return RegistrationErrorDomainMapping().mapError(error)
        case ErrorDomains.mobileAuthRequest:
            return MobileAuthRequestErrorDomainMapping().mapError(error)
        default:
            return AppError(errorDescription: "Something went wrong.")
        }
    }
}
