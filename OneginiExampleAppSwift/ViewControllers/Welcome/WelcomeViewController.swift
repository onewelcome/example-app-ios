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

import BetterSegmentedControl
import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet var segmentView: BetterSegmentedControl!
    @IBOutlet var tabView: UIView!

    var loginViewController: LoginViewController
    var registerUserViewController: RegisterUserViewController
    var welcomePresenterProtocol: WelcomePresenterProtocol

    init(welcomePresenterProtocol: WelcomePresenterProtocol) {
        self.welcomePresenterProtocol = welcomePresenterProtocol
        loginViewController = welcomePresenterProtocol.setupLoginView()
        registerUserViewController = welcomePresenterProtocol.setupRegisterUserView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        welcomePresenterProtocol.setupSegmentView(welcomeViewController: self)
        navigationController?.navigationBar.isHidden = true
    }

    func setupViewWithProfiles() {
        segmentView.isHidden = false
        segmentView.titles = ["Log in", "Sign Up"]
        let customSubview = UIView(frame: CGRect(x: 0, y: 40, width: 100, height: 1.0))
        customSubview.backgroundColor = UIColor.gray
        customSubview.layer.cornerRadius = 2.0
        customSubview.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        segmentView.addSubviewToIndicator(customSubview)
        displayLognViewController()
    }

    func setupViewWithoutProfiles() {
        segmentView.isHidden = true
        displayRegisterUserViewController()
    }

    func displayLognViewController() {
        addChildViewController(loginViewController)
        tabView.addSubview(loginViewController.view)
        loginViewController.view.frame = tabView.bounds
    }

    func displayRegisterUserViewController() {
        addChildViewController(registerUserViewController)
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
