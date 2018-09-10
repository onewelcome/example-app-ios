//
// Copyright (c) 2018 Onegini. All rights reserved.
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

protocol ChangePinInteractorProtocol {
    func changePin()
    func handlePin()
}

class ChangePinInteractor: NSObject {
    weak var changePinPresenter: ChangePinInteractorToPresenterProtocol?
    var changePinEntity = ChangePinEntity()

    fileprivate func mapErrorFromPinChallenge(_ challenge: ONGPinChallenge) {
        if let error = challenge.error {
            changePinEntity.pinError = ErrorMapper().mapError(error, pinChallenge: challenge)
        } else {
            changePinEntity.pinError = nil
        }
    }

    fileprivate func mapErrorFromCreatePinChallenge(_ challenge: ONGCreatePinChallenge) {
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

    func handleCreatePin() {
        guard let pinChallenge = changePinEntity.createPinChallenge else { return }
        if let pin = changePinEntity.pin {
            pinChallenge.sender.respond(withCreatedPin: pin, challenge: pinChallenge)
        } else {
            pinChallenge.sender.cancel(pinChallenge)
        }
    }

    func handleLogin() {
        guard let pinChallenge = changePinEntity.loginPinChallenge else { return }
        if let pin = changePinEntity.pin {
            pinChallenge.sender.respond(withPin: pin, challenge: pinChallenge)
        } else {
            pinChallenge.sender.cancel(pinChallenge)
        }
    }
}

extension ChangePinInteractor: ChangePinInteractorProtocol {
    func changePin() {
        ONGUserClient.sharedInstance().changePin(self)
    }
}

extension ChangePinInteractor: ONGChangePinDelegate {
    func userClient(_: ONGUserClient, didReceive challenge: ONGPinChallenge) {
        changePinEntity.loginPinChallenge = challenge
        changePinEntity.pinLength = 5
        mapErrorFromPinChallenge(challenge)
        changePinPresenter?.presentLoginPinView(changePinEntity: changePinEntity)
    }

    func userClient(_: ONGUserClient, didReceive challenge: ONGCreatePinChallenge) {
        changePinEntity.createPinChallenge = challenge
        changePinEntity.pinLength = Int(challenge.pinLength)
        mapErrorFromCreatePinChallenge(challenge)
        changePinPresenter?.presentCreatePinView(changePinEntity: changePinEntity)
    }

    func userClient(_: ONGUserClient, didFailToChangePinForUser _: ONGUserProfile, error: Error) {
        changePinEntity.createPinChallenge = nil
        let mappedError = ErrorMapper().mapError(error)
        if error.code == ONGGenericError.actionCancelled.rawValue {
            changePinPresenter?.presentProfileView()
        } else if error.code == ONGGenericError.userDeregistered.rawValue {
            changePinPresenter?.popToWelcomeViewWithError(mappedError)
        } else {
            changePinPresenter?.changePinActionFailed(mappedError)
        }
    }

    func userClient(_: ONGUserClient, didChangePinForUser _: ONGUserProfile) {
        changePinEntity.createPinChallenge = nil
        changePinPresenter?.presentProfileView()
    }
}
