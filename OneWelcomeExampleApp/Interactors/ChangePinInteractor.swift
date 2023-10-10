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

import UIKit

protocol ChangePinInteractorProtocol: AnyObject {
    func changePin()
    func handlePin()
    func handlePinPolicy(pin: String, completion: @escaping (Error?) -> Void)
}

class ChangePinInteractor: NSObject {
    weak var changePinPresenter: ChangePinInteractorToPresenterProtocol?
    var changePinEntity = ChangePinEntity()
    private var userClient: UserClient {
        return SharedUserClient.instance
    }

    fileprivate func mapErrorFromPinChallenge(_ challenge: PinChallenge) {
        if let error = challenge.error {
            changePinEntity.pinError = ErrorMapper().mapError(error, pinChallenge: challenge)
        } else {
            changePinEntity.pinError = nil
        }
    }

    fileprivate func mapErrorFromCreatePinChallenge(_ challenge: CreatePinChallenge) {
        if let error = challenge.error {
            changePinEntity.pinError = ErrorMapper().mapError(error)
        } else {
            changePinEntity.pinError = nil
        }
    }

    func handlePin() {
        if changePinEntity.createPinChallenge != nil {
            handleCreatePin()
        } else {
            handleLogin()
        }
    }
    
    func handlePinPolicy(pin: String, completion: @escaping (Error?) -> Void) {
        userClient.validatePolicyCompliance(for: pin) { error in
            completion(error)
        }
    }

    func handleCreatePin() {
        guard let pinChallenge = changePinEntity.createPinChallenge else { return }
        if let pin = changePinEntity.pin {
            pinChallenge.sender.respond(with: pin, to: pinChallenge)
        } else {
            pinChallenge.sender.cancel(pinChallenge)
        }
    }

    func handleLogin() {
        guard let pinChallenge = changePinEntity.loginPinChallenge else { return }
        if let pin = changePinEntity.pin {
            pinChallenge.sender.respond(with: pin, to: pinChallenge)
        } else {
            pinChallenge.sender.cancel(pinChallenge)
        }
    }
}

extension ChangePinInteractor: ChangePinInteractorProtocol {
    func changePin() {
        userClient.changePin(delegate: self)
    }
}

extension ChangePinInteractor: ChangePinDelegate {
    func userClient(_ userClient: UserClient, didReceivePinChallenge challenge: PinChallenge) {
        changePinEntity.loginPinChallenge = challenge
        changePinEntity.pinLength = 5
        mapErrorFromPinChallenge(challenge)
        changePinPresenter?.presentLoginPinView(changePinEntity: changePinEntity)
    }

    func userClient(_ userClient: UserClient, didReceiveCreatePinChallenge challenge: CreatePinChallenge) {
        changePinEntity.createPinChallenge = challenge
        changePinEntity.pinLength = Int(challenge.pinLength)
        mapErrorFromCreatePinChallenge(challenge)
        changePinPresenter?.presentCreatePinView(changePinEntity: changePinEntity)
    }

    func userClient(_ userClient: UserClient, didFailToChangePinForUser _: UserProfile, error: Error) {
        changePinEntity.createPinChallenge = nil
        let mappedError = ErrorMapper().mapError(error)
        switch GenericError(rawValue: error.code) {
        case .actionCancelled:
            changePinPresenter?.presentProfileView()
        case .userDeregistered:
            changePinPresenter?.popToWelcomeViewWithError(mappedError)
        default:
            changePinPresenter?.changePinActionFailed(mappedError)
        }
    }

    func userClient(_ userClient: UserClient, didChangePinForUser _: UserProfile) {
        changePinEntity.createPinChallenge = nil
        changePinPresenter?.presentProfileView()
        changePinPresenter?.presentChangePinAlert()
    }
}
