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

class ProfileViewController: UIViewController {
    weak var profileViewToPresenter: ProfileViewToPresenterProtocol?
    
    @IBOutlet private weak var profileNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileViewToPresenter?.update()
    }
    
    @IBAction func backPressed(_: Any) {
        profileViewToPresenter?.popToDashboardView()
    }

    @IBAction func disconnectProfile(_: Any) {
        profileViewToPresenter?.setupDisconnectPresenter()
    }

    @IBAction func deviceList(_: Any) {
        profileViewToPresenter?.setupFetchDeviceListPresenter()
    }

    @IBAction func changePassword(_: Any) {
        profileViewToPresenter?.setupChangePinPresenter()
    }
    
    func setProfileName(_ profileName: String?) {
        profileNameLabel.text = profileName
    }
}
