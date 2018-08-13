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
    
    @IBOutlet weak var preferredLabel: UILabel!
    @IBOutlet var authenticatorName: UILabel!
    @IBOutlet weak var deregisterButton: TransitionButton!
    @IBOutlet weak var registerButton: TransitionButton!
    
    var selectedRow: ((AuthenticatorTableViewCell) -> Void)?
    weak var authenticatorsViewController: AuthenticatorsViewController?
    var authenticator: ONGAuthenticator?
    
    func setupCell(_ authenticator: ONGAuthenticator) {
        self.authenticator = authenticator
        
        authenticatorName.text = authenticator.name
        
        deregisterButton.isHidden = !authenticator.isRegistered || authenticator.type == .PIN
        registerButton.isHidden = authenticator.isRegistered || authenticator.type == .PIN
        
        preferredLabel.isHidden = !authenticator.isPreferred
    }
    
    
    @IBAction func register(_ sender: Any) {
        guard let authenticator = authenticator else { return }
        authenticatorsViewController?.registerAuthenticator(authenticator)
    }
    
    @IBAction func deregister(_ sender: Any) {
        selectedRow?(self)
        guard let authenticator = authenticator else { return }
        deregisterButton.startAnimation()
        self.authenticatorsViewController?.deregisterAuthenticator(authenticator)
    }
    
    func deregistrationFinished() {
        self.deregisterButton.stopAnimation(animationStyle: .normal, revertAfterDelay: 0, completion: {
            self.authenticatorsViewController?.authenticatorsViewToPresenterProtocol?.reloadAuthenticators()
        })
    }
    

}