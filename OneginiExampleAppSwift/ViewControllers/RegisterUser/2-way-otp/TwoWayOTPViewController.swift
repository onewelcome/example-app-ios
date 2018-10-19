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

protocol TwoWayOTPEntityProtocol {
    var responseCode: String? { get set }
    var challengeCode: String? { get set }
    var cancelled: Bool { get set }
    var errorMessage: String? { get set }
}

class TwoWayOTPViewController: UIViewController {
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var challengeCode: UILabel!
    @IBOutlet var responseCode: SkyFloatingLabelTextField!

    var registerUserEntity: TwoWayOTPEntityProtocol
    let registerUserViewToPresenterProtocol: RegisterUserViewToPresenterProtocol

    init(registerUserEntity: TwoWayOTPEntityProtocol, registerUserViewToPresenterProtocol: RegisterUserViewToPresenterProtocol) {
        self.registerUserEntity = registerUserEntity
        self.registerUserViewToPresenterProtocol = registerUserViewToPresenterProtocol
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        challengeCode.text = registerUserEntity.challengeCode
    }

    func reset() {
        if let errorMessage = registerUserEntity.errorMessage {
            errorLabel.text = errorMessage
        }
        challengeCode.text = registerUserEntity.challengeCode
        responseCode.text = ""
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func submit(_: Any) {
        registerUserEntity.responseCode = responseCode.text
        registerUserViewToPresenterProtocol.handleOTPCode()
    }

    @IBAction func cancel(_: Any) {
        registerUserEntity.cancelled = true
        registerUserViewToPresenterProtocol.handleOTPCode()
    }
}
