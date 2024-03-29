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

class DashboardViewController: UIViewController {
    @IBOutlet private weak var app2webButton: TransitionButton!
    @IBOutlet private weak var profileNameLabel: UILabel!
    weak var dashboardViewToPresenterProtocol: DashboardViewToPresenterProtocol?
    var userProfileName: String?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileNameLabel.text = userProfileName
        makeProfileNameLabelTappable()
    }

    @IBAction func logoutPressed(_: Any) {
        dashboardViewToPresenterProtocol?.logout()
    }

    @IBAction func authenticatorsPressed(_: Any) {
        dashboardViewToPresenterProtocol?.presentAuthenticatorsView()
    }

    @IBAction func profilesPressed(_: Any) {
        dashboardViewToPresenterProtocol?.presentProfileView()
    }

    @IBAction func mobileAuthPressed(_: Any) {
        dashboardViewToPresenterProtocol?.presentMobileAuthView()
    }
    
    @IBAction func appToWebPressed(_ sender: Any) {
        app2webButton.startAnimation()
        dashboardViewToPresenterProtocol?.presetAppToWebView()
    }
    
    func updateView() {
        app2webButton.stopAnimation()
    }
    
    @objc func profileNameTapped() {
        dashboardViewToPresenterProtocol?.dashboard()
    }
    
    func makeProfileNameLabelTappable() {
        let gest = UITapGestureRecognizer(target: self, action: #selector(profileNameTapped))
        profileNameLabel.addGestureRecognizer(gest)
        profileNameLabel.isUserInteractionEnabled = true
    }
}
