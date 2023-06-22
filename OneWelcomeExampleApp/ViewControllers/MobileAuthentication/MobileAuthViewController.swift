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
import TransitionButton
import UIKit

extension UIButton {
    func makeDisabled(_ disable: Bool) {
        self.alpha = !disable ? 1.0 : 0.5
        self.isEnabled = !disable
    }
}

class MobileAuthViewController: UIViewController {
    weak var mobileAuthViewToPresenterProtocol: MobileAuthViewToPresenterProtocol?

    @IBOutlet var enrollMobileAuthButton: TransitionButton!
    @IBOutlet var enrollPushMobileAuthButton: TransitionButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        enrollMobileAuthButton.setTitle("Enrolled", for: .disabled)
        enrollPushMobileAuthButton.setTitle("Enrolled", for: .disabled)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let mobileAuthViewToPresenterProtocol = mobileAuthViewToPresenterProtocol else { return }
        
        enrollMobileAuthButton.makeDisabled(mobileAuthViewToPresenterProtocol.isUserEnrolledForMobileAuth())
        enrollPushMobileAuthButton.makeDisabled(mobileAuthViewToPresenterProtocol.isUserEnrolledForPushMobileAuth())
    }

    @IBAction func enrollMobileAuth(_: Any) {
        enrollMobileAuthButton.startAnimation()
        view.isUserInteractionEnabled = false
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            self.mobileAuthViewToPresenterProtocol?.enrollForMobileAuth()
        })
    }

    @IBAction func enrollPushMobileAuth(_: Any) {
        enrollPushMobileAuthButton.startAnimation()
        view.isUserInteractionEnabled = false
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            self.mobileAuthViewToPresenterProtocol?.registerForPushMobileAuth()
        })
    }

    @IBAction func backPressed(_: Any) {
        mobileAuthViewToPresenterProtocol?.popToDashboardView()
    }
    
    @IBAction func scanQRCode(_ sender: Any) {
        mobileAuthViewToPresenterProtocol?.presentQRCodeScanner()
    }
    
    func stopEnrollPushMobileAuthAnimation(succeed: Bool) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.enrollPushMobileAuthButton.stopAnimation(animationStyle: .normal, completion: {
                self.view.isUserInteractionEnabled = true
                self.enrollPushMobileAuthButton.makeDisabled(false)
                if succeed {
                    self.enrollPushMobileAuthButton.makeDisabled(true)
                }
            })
        })
    }

    func stopEnrollMobileAuthAnimation(succeed: Bool) {
        DispatchQueue.main.async(execute: { () -> Void in
            self.enrollMobileAuthButton.stopAnimation(animationStyle: .normal, completion: {
                self.view.isUserInteractionEnabled = true
                self.enrollMobileAuthButton.makeDisabled(false)
                if succeed {
                    self.enrollMobileAuthButton.makeDisabled(true)
                }
            })
        })
    }
}

extension MobileAuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
