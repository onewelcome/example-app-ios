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

import SkyFloatingLabelTextField
import UIKit

enum PasswordAuthenticatorMode: String {
    case register = "Register"
    case login = "Login"
    case mobileAuth = "Confirm"
}

protocol PasswordAuthenticatorEntityProtocol {
    var data: String { get set }
    var cancelled: Bool { get set }
    var message: String? { get set }
}

protocol PasswordAuthenticatorViewToPresenterProtocol: class {
    func handlePassword()
}

class PasswordAuthenticatorViewController: UIViewController {
    @IBOutlet var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var message: UILabel!

    unowned let viewToPresenterProtocol: PasswordAuthenticatorViewToPresenterProtocol
    let mode: PasswordAuthenticatorMode
    var entity: PasswordAuthenticatorEntityProtocol

    init(mode: PasswordAuthenticatorMode, entity: PasswordAuthenticatorEntityProtocol, viewToPresenterProtocol: PasswordAuthenticatorViewToPresenterProtocol) {
        self.mode = mode
        self.entity = entity
        self.viewToPresenterProtocol = viewToPresenterProtocol
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.setTitle(mode.rawValue, for: .normal)
        message.text = entity.message
        var title = ""
        if mode == .login {
            title = "Login with password"
        } else if mode == .mobileAuth {
            title = "Confirm push with password"
        } else if mode == .register {
            title = "Create password"
        }
        titleLabel.text = title
    }

    @IBAction func cancel(_: Any) {
        entity.cancelled = true
        viewToPresenterProtocol.handlePassword()
    }

    @IBAction func submit(_: Any) {
        entity.data = passwordTextField.text ?? ""
        viewToPresenterProtocol.handlePassword()
    }
}
