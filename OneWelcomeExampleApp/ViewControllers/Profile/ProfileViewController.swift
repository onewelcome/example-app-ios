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
import TransitionButton

class ProfileViewController: UIViewController {
    weak var profileViewToPresenter: ProfileViewToPresenterProtocol?
    @IBOutlet private weak var deviceListButton: TransitionButton!    
    @IBOutlet private weak var profileNameLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileViewToPresenter?.updateView()
    }
    
    @IBAction func backPressed(_: Any) {
        profileViewToPresenter?.popToDashboardView()
    }

    @IBAction func disconnectProfile(_: Any) {
        profileViewToPresenter?.setupDisconnectPresenter()
    }

    @IBAction func deviceList(_: Any) {
        deviceListButton.startAnimation()
        profileViewToPresenter?.setupFetchDeviceListPresenter()
    }
    
    @IBAction func idToken() {
        profileViewToPresenter?.setupIdToken()
    }

    @IBAction func changePassword(_: Any) {
        profileViewToPresenter?.setupChangePinPresenter()
    }
    
    func setProfileName(_ profileName: String?) {
        profileNameLabel.text = profileName
    }
    
    func updateView() {
        deviceListButton.stopAnimation()
    }
}
