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

protocol PasswordAuthenticatorViewToPresenterProtocol: AnyObject {
    func handlePassword()
}

class PasswordAuthenticatorViewController: UIViewController {
    @IBOutlet private var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet private var submitButton: UIButton!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var message: UILabel!
    
    private unowned let viewToPresenterProtocol: PasswordAuthenticatorViewToPresenterProtocol
    private let mode: PasswordAuthenticatorMode
    private var entity: PasswordAuthenticatorEntityProtocol
    private let inputValidator: StringValidator
    
    init(mode: PasswordAuthenticatorMode,
         entity: PasswordAuthenticatorEntityProtocol,
         viewToPresenterProtocol: PasswordAuthenticatorViewToPresenterProtocol,
         inputValidator: StringValidator = NotEmptyInputValidator()) {
        self.mode = mode
        self.entity = entity
        self.viewToPresenterProtocol = viewToPresenterProtocol
        self.inputValidator = inputValidator
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
        submitButton.isEnabled = false
    }

    @IBAction func cancel(_: Any) {
        entity.cancelled = true
        viewToPresenterProtocol.handlePassword()
    }

    @IBAction func submit(_: Any) {
        guard let input = passwordTextField.text, inputValidator.isValid(input) else { return }
        entity.data = input
        viewToPresenterProtocol.handlePassword()
    }
    
    @IBAction func passwordTextFieldEditingChanged(_ sender: Any) {
        let validPassword = passwordTextField.text.flatMap { inputValidator.isValid($0) } ?? false
        submitButton.isEnabled = validPassword
        passwordTextField.errorMessage = validPassword ? nil : "Invalid password"
    }
}

protocol StringValidator {
    func isValid(_ input: String) -> Bool
}

class NotEmptyInputValidator: StringValidator {
    func isValid(_ input: String) -> Bool {
        return !input.isEmpty
    }
}
