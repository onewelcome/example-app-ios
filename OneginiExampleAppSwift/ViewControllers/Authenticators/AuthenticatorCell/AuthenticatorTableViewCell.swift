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

import TransitionButton
import UIKit

class AuthenticatorTableViewCell: UITableViewCell {
    @IBOutlet var preferredLabel: UILabel!
    @IBOutlet var authenticatorName: UILabel!
    @IBOutlet var deregisterButton: TransitionButton!
    @IBOutlet var registerButton: TransitionButton!
    @IBOutlet var setPreferredButton: TransitionButton!

    var selectedRow: ((AuthenticatorTableViewCell) -> Void)?
    weak var authenticatorsViewController: AuthenticatorsViewController?
    var authenticator: ONGAuthenticator?

    func setupCell(_ authenticator: ONGAuthenticator) {
        self.authenticator = authenticator

        authenticatorName.text = authenticator.name

        deregisterButton.isHidden = !authenticator.isRegistered || authenticator.type == .PIN
        registerButton.isHidden = authenticator.isRegistered || authenticator.type == .PIN

        preferredLabel.isHidden = !authenticator.isPreferred
        setPreferredButton.isHidden = !authenticator.isRegistered || authenticator.isPreferred
    }

    @IBAction func register(_: Any) {
        guard let authenticator = authenticator else { return }
        authenticatorsViewController?.registerAuthenticator(authenticator)
    }

    @IBAction func deregister(_: Any) {
        selectedRow?(self)
        guard let authenticator = authenticator else { return }
        deregisterButton.startAnimation()
        isUserInteractionEnabled = false
        authenticatorsViewController?.deregisterAuthenticator(authenticator)
    }

    @IBAction func setPreferredAuthenticator(_: Any) {
        if let authenticator = authenticator {
            authenticatorsViewController?.authenticatorsViewToPresenterProtocol?.setPreferredAuthenticator(authenticator)
            authenticatorsViewController?.authenticatorsViewToPresenterProtocol?.reloadAuthenticators()
        }
    }

    func deregistrationFinished() {
        deregisterButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0.1, completion: {
            self.isUserInteractionEnabled = true
            self.authenticatorsViewController?.authenticatorsViewToPresenterProtocol?.reloadAuthenticators()
        })
    }
}
