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
        case ONGGenericErrorDomain:
            return GenericErrorDomainMapping().mapError(error)
        case ONGPinValidationErrorDomain:
            return PinValidationErrorDomainMapping().mapError(error)
        case ONGAuthenticationErrorDomain:
            return AuthenticationErrorDomainMapping().mapError(error, pinChallenge: pinChallenge, customInfo: customInfo)
        case ONGAuthenticatorRegistrationErrorDomain:
            return AuthenticatorRegistrationErrorDomainMapping().mapError(error, customInfo: customInfo)
        case ONGAuthenticatorDeregistrationErrorDomain:
            return AuthenticatorDeregistrationErrorMapping().mapError(error)
        case ONGMobileAuthEnrollmentErrorDomain:
            return MobileAuthEnrollmentErrorDomainMapping().mapError(error)
        case ONGFetchResourceErrorDomain:
            return FetchResourceErrorDomainMapping().mapError(error)
        case ONGFetchImplicitResourceErrorDomain:
            return FetchImplicitResourceErrorDomainMapping().mapError(error)
        case ONGAppToWebSingleSignOnErrorDomain:
            return AppToWebSingleSignOnErrorDomainMapping().mapError(error)
        case ONGChangePinErrorDomain:
            return ChangePinErrorDomainMapping().mapError(error)
        case ONGRegistrationErrorDomain:
            return RegistrationErrorDomainMapping().mapError(error)
        case ONGMobileAuthRequestErrorDomain:
            return MobileAuthRequestErrorDomainMapping().mapError(error)
        default:
            return AppError(errorDescription: "Something went wrong.")
        }
    }
}
