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

import UserNotifications

protocol MobileAuthInteractorProtocol: AnyObject {
    func enrollForMobileAuth()
    func enrollForPushMobileAuth(deviceToken: Data)
    func registerForPushMessages(completion: @escaping (Bool) -> Void)
    func isUserEnrolledForMobileAuth() -> Bool
    func isUserEnrolledForPushMobileAuth() -> Bool
    func handlePinMobileAuth()
    func fetchPendingTransactions(completion: @escaping ([PendingMobileAuthRequest]?, AppError?) -> Void)
    func handleMobileAuth()
    func handleCustomAuthenticatorMobileAuth()
    func handlePendingMobileAuth(_ pendingTransaction: PendingMobileAuthRequest)
    func handleOTPMobileAuth(_ otp: String)
}

class MobileAuthInteractor: NSObject, MobileAuthInteractorProtocol {
    weak var mobileAuthPresenter: MobileAuthInteractorToPresenterProtocol?
    var mobileAuthQueue = MobileAuthQueue()
    var mobileAuthEntity = MobileAuthEntity()
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    private var userClient: UserClient {
        return SharedUserClient.instance
    }

    func isUserEnrolledForMobileAuth() -> Bool {
        guard let userProfile = userClient.authenticatedUserProfile else { return false }
        return userClient.isMobileAuthEnrolled(for: userProfile)
    }

    func isUserEnrolledForPushMobileAuth() -> Bool {
        guard let userProfile = userClient.authenticatedUserProfile else { return false }
        return userClient.isPushMobileAuthEnrolled(for: userProfile)
    }
    
    func enrollForMobileAuth() {
        userClient.enrollMobileAuth { error in
            guard let error = error else {
                self.mobileAuthPresenter?.mobileAuthEnrolled()
                return
            }
            let mappedError = ErrorMapper().mapError(error)
            self.mobileAuthPresenter?.enrollMobileAuthFailed(mappedError)
        }
    }

    func enrollForPushMobileAuth(deviceToken: Data) {
        userClient.enrollPushMobileAuth(with: deviceToken) { error in
            guard let error = error else {
                self.mobileAuthPresenter?.pushMobileAuthEnrolled()
                return
            }
            let mappedError = ErrorMapper().mapError(error)
            self.mobileAuthPresenter?.enrollPushMobileAuthFailed(mappedError)
        }
    }

    func fetchPendingTransactions(completion: @escaping ([PendingMobileAuthRequest]?, AppError?) -> Void) {
        userClient.pendingPushMobileAuthRequests { [weak self] requests, error in
            var badgeNumber = 0
            if let error = error {
                let appError = ErrorMapper().mapError(error)
                completion(nil, appError)
            } else if let requests = requests {
                badgeNumber = requests.count
                completion(requests, nil)
            } else {
                completion([], nil)
            }
            
            self?.mobileAuthPresenter?.updateApplicationIconBadge(to: badgeNumber)
        }
    }

    func registerForPushMessages(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge]) { permissionGranted, error in
            if error != nil {
                let error = AppError(title: "Push mobile auth enrollment error", errorDescription: "Something went wrong.")
                self.mobileAuthPresenter?.enrollPushMobileAuthFailed(error)
            }
            completion(permissionGranted)
        }
    }

    func handlePinMobileAuth() {
        guard let pinChallenge = mobileAuthEntity.pinChallenge else { fatalError() }
        if let pin = mobileAuthEntity.pin {
            pinChallenge.sender.respond(with: pin, to: pinChallenge)
        } else {
            pinChallenge.sender.cancel(pinChallenge)
        }
    }

    func handleMobileAuth() {
        if mobileAuthEntity.authenticatorType == .biometric {
            handleBiometricMobileAuth()
        } else if mobileAuthEntity.authenticatorType == .confirmation {
            handleConfirmationMobileAuth()
        } else if mobileAuthEntity.authenticatorType == .pin {
            handlePinConfirmationMobileAuth()
        }
    }

    fileprivate func handlePinConfirmationMobileAuth() {
        guard let pinChallenge = mobileAuthEntity.pinChallenge else { fatalError() }
        if mobileAuthEntity.cancelled {
            pinChallenge.sender.cancel(pinChallenge)
        } else {
            mobileAuthPresenter?.dismiss()
            mobileAuthPresenter?.presentPinView(mobileAuthEntity: mobileAuthEntity)
        }
    }

    fileprivate func handleBiometricMobileAuth() {
        guard let biometricChallenge = mobileAuthEntity.biometricChallenge else { fatalError() }
        if mobileAuthEntity.cancelled {
            biometricChallenge.sender.cancel(biometricChallenge)
        } else {
            biometricChallenge.sender.respond(with: "User authentication", to: biometricChallenge)
        }
    }

    fileprivate func handleConfirmationMobileAuth() {
        guard let confirmation = mobileAuthEntity.confirmation else { fatalError() }
        if mobileAuthEntity.cancelled {
            confirmation(false)
        } else {
            confirmation(true)
        }
    }

    func handleCustomAuthenticatorMobileAuth() {
        guard let customAuthChallenge = mobileAuthEntity.customAuthChallenge else { fatalError() }
        if mobileAuthEntity.cancelled {
            customAuthChallenge.sender.cancel(customAuthChallenge, underlyingError: nil)
        } else {
            customAuthChallenge.sender.respond(with: mobileAuthEntity.data, to: customAuthChallenge)
        }
    }

    func handlePendingMobileAuth(_ pendingTransaction: PendingMobileAuthRequest) {
        userClient.handlePendingMobileAuthRequest(pendingTransaction, delegate: self)
    }

    func handleOTPMobileAuth(_ otp: String) {
        userClient.handleOTPMobileAuthRequest(otp: otp, delegate: self)
    }

    fileprivate func handlePushMobileAuthenticationRequest(userInfo: [AnyHashable: Any]) {
        guard let pendingTransaction = userClient.pendingMobileAuthRequest(from: userInfo) else { return }
        let mobileAuthRequest = PendingMobileAuthRequestContainter(delegate: self, pendingTransaction: pendingTransaction)
        mobileAuthQueue.enqueue(mobileAuthRequest)
    }

    fileprivate func mapErrorFromChallenge(_ challenge: PinChallenge) {
        if let error = challenge.error,
            error.code != ONGAuthenticationError.touchIDAuthenticatorFailure.rawValue,
            error.code != ONGAuthenticationError.customAuthenticatorFailure.rawValue {
            mobileAuthEntity.pinError = ErrorMapper().mapError(error, pinChallenge: challenge)
        } else {
            mobileAuthEntity.pinError = nil
        }
    }
}

extension MobileAuthInteractor: MobileAuthRequestDelegate {
    func userClient(_ userClient: UserClient, didReceiveConfirmation confirmation: @escaping (Bool) -> Void, for request: MobileAuthRequest) {
        mobileAuthEntity.message = request.message
        mobileAuthEntity.userProfile = request.userProfile
        mobileAuthEntity.authenticatorType = .confirmation
        mobileAuthEntity.confirmation = confirmation
        mobileAuthPresenter?.presentConfirmationView(mobileAuthEntity: mobileAuthEntity)
    }

    func userClient(_ userClient: UserClient, didReceivePinChallenge challenge: PinChallenge, for request: MobileAuthRequest) {
        mobileAuthEntity.pinChallenge = challenge
        mobileAuthEntity.pinLength = 5
        mapErrorFromChallenge(challenge)
        mobileAuthEntity.authenticatorType = .pin
        mobileAuthEntity.message = request.message
        mobileAuthEntity.userProfile = challenge.userProfile
        if challenge.error?.code == ONGAuthenticationError.touchIDAuthenticatorFailure.rawValue
            || challenge.error?.code == ONGAuthenticationError.customAuthenticatorFailure.rawValue {
            mobileAuthPresenter?.dismiss()
            mobileAuthPresenter?.presentPinView(mobileAuthEntity: mobileAuthEntity)
        } else {
            mobileAuthPresenter?.presentConfirmationView(mobileAuthEntity: mobileAuthEntity)
        }
    }

    func userClient(_ userClient: UserClient, didReceiveBiometricChallenge challenge: BiometricChallenge, for request: MobileAuthRequest) {
        mobileAuthEntity.biometricChallenge = challenge
        mobileAuthEntity.authenticatorType = .biometric
        mobileAuthEntity.message = request.message
        mobileAuthEntity.userProfile = challenge.userProfile
        mobileAuthPresenter?.presentConfirmationView(mobileAuthEntity: mobileAuthEntity)
    }

    func userClient(_ userClient: UserClient, didReceiveCustomAuthFinishAuthenticationChallenge challenge: CustomAuthFinishAuthenticationChallenge, for request: MobileAuthRequest) {
        mobileAuthEntity.customAuthChallenge = challenge
        mobileAuthEntity.userProfile = challenge.userProfile
        mobileAuthEntity.message = request.message
        mobileAuthPresenter?.presentPasswordAuthenticatorView(mobileAuthEntity: mobileAuthEntity)
    }

    func userClient(_ userClient: UserClient, didFailToHandleRequest request: MobileAuthRequest, authenticator: Authenticator?, error: Error) {
        mobileAuthEntity = MobileAuthEntity()
        if error.code == ONGGenericError.actionCancelled.rawValue {
            mobileAuthPresenter?.dismiss()
            mobileAuthQueue.dequeue()
        } else {
            let mappedError = ErrorMapper().mapError(error)
            let isUserLoggedIn = userClient.authenticatedUserProfile?.isEqual(to: request.userProfile) ?? false
            mobileAuthPresenter?.mobileAuthenticationFailed(mappedError, isUserLoggedIn: isUserLoggedIn, completion: { _ in
                self.mobileAuthQueue.dequeue()
            })
        }
    }
    
    func userClient(_ userClient: any UserClient, didFailToHandleOTPMobileAuthRequest otp: String, error: any Error) {
        mobileAuthEntity = MobileAuthEntity()
        if error.code == ONGGenericError.actionCancelled.rawValue {
            mobileAuthPresenter?.dismiss()
            mobileAuthQueue.dequeue()
        } else {
            let mappedError = ErrorMapper().mapError(error)
            let isUserLoggedIn = false
            mobileAuthPresenter?.mobileAuthenticationFailed(mappedError, isUserLoggedIn: isUserLoggedIn, completion: { _ in
                self.mobileAuthQueue.dequeue()
            })
        }
    }

    func userClient(_ userClient: UserClient, didHandleRequest request: MobileAuthRequest, authenticator: Authenticator?, info customAuthenticatorInfo: CustomInfo?) {
        mobileAuthEntity = MobileAuthEntity()
        mobileAuthPresenter?.dismiss()
        mobileAuthQueue.dequeue()
        mobileAuthPresenter?.presentConfirmationAlert()
    }
}

extension MobileAuthInteractor: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        handlePushMobileAuthenticationRequest(userInfo: response.notification.request.content.userInfo)
        completionHandler()
    }

    func userNotificationCenter(_: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        handlePushMobileAuthenticationRequest(userInfo: notification.request.content.userInfo)
        completionHandler(.sound)
    }
}

struct PendingMobileAuthRequestContainter {
    let pendingTransaction: PendingMobileAuthRequest?
    let otp: String?
    let delegate: MobileAuthRequestDelegate

    init(delegate: MobileAuthRequestDelegate, pendingTransaction: PendingMobileAuthRequest? = nil, otp: String? = nil) {
        self.delegate = delegate
        self.pendingTransaction = pendingTransaction
        self.otp = otp
    }
}
