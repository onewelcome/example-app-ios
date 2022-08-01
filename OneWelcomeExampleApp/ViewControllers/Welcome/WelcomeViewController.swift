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

import BetterSegmentedControl
import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet var segmentView: BetterSegmentedControl!
    @IBOutlet var tabView: UIView!

    var loginViewController: LoginViewController?
    var registerUserViewController: RegisterUserViewController?
    weak var welcomePresenterProtocol: WelcomePresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSegmentView()
        navigationController?.navigationBar.isHidden = true
        guard let loginViewController = loginViewController else { return }
        if loginViewController.profiles.count > 0 {
            setupViewWithProfiles()
        } else {
            setupViewWithoutProfiles()
        }
    }

    func configureSegmentView() {
        let normalFont = UIFont.systemFont(ofSize: 20)
        let selectedFont = UIFont.boldSystemFont(ofSize: 20)
        let segments = LabelSegment.segments(withTitles: ["Log in", "Sign Up"],
                                             numberOfLines: 1,
                                             normalBackgroundColor: nil,
                                             normalFont: normalFont,
                                             normalTextColor: .appBackgroundReversed,
                                             selectedBackgroundColor: .appBackgroundReversed,
                                             selectedFont: selectedFont,
                                             selectedTextColor: .appBackground)
        segmentView.segments = segments
    }

    func setupViewWithProfiles() {
        segmentView.isHidden = false
        segmentView.setIndex(0)
        displayLognViewController()
    }

    func setupViewWithoutProfiles() {
        segmentView.isHidden = true
        displayRegisterUserViewController()
    }

    func selectSignUp() {
        segmentView.setIndex(1)
    }

    func displayLognViewController() {
        guard let loginViewController = loginViewController else { return }
        addChild(loginViewController)
        tabView.addSubview(loginViewController.view)
        loginViewController.view.frame = tabView.bounds
    }

    func displayRegisterUserViewController() {
        guard let registerUserViewController = registerUserViewController else { return }
        addChild(registerUserViewController)
        tabView.addSubview(registerUserViewController.view)
        registerUserViewController.view.frame = tabView.bounds
    }

    @IBAction func segmentValueChanged(_ sender: BetterSegmentedControl) {
        if sender.index == 0 {
            displayLognViewController()
        } else {
            displayRegisterUserViewController()
        }
    }
}
