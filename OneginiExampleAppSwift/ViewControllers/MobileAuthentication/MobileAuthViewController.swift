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

import UIKit
import TransitionButton

class MobileAuthViewController: UIViewController {

    let mobileAuthViewToPresenterProtocol: MobileAuthViewToPresenterProtocol
    
    @IBOutlet weak var enrollMobileAuthButton: TransitionButton!
    @IBOutlet weak var enrollPushMobileAuthButton: TransitionButton!
    
    init(_ mobileAuthViewToPresenterProtocol: MobileAuthViewToPresenterProtocol) {
        self.mobileAuthViewToPresenterProtocol = mobileAuthViewToPresenterProtocol
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func enrollMobileAuth(_ sender: Any) {
        enrollMobileAuthButton.startAnimation()
        self.view.isUserInteractionEnabled = false
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
                                                                                                                                                                             
            sleep(3) // 3: Call enroll for mobile auth method from OneginiSDK
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.enrollMobileAuthButton.stopAnimation(animationStyle: .normal, completion: {
                    self.enrollMobileAuthButton.setTitle("Enrolled", for: .disabled)
                    self.enrollMobileAuthButton.isEnabled = false
                    self.view.isUserInteractionEnabled = true
                })
            })
        })
    }
    
    @IBAction func enrollPushMobileAuth(_ sender: Any) {
        enrollPushMobileAuthButton.startAnimation()
        self.view.isUserInteractionEnabled = false
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            sleep(3) // 3: Call enroll for push mobile auth method from OneginiSDK
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.enrollPushMobileAuthButton.stopAnimation(animationStyle: .normal, completion: {
                    self.enrollPushMobileAuthButton.setTitle("Enrolled", for: .disabled)
                    self.enrollPushMobileAuthButton.isEnabled = false
                    self.view.isUserInteractionEnabled = true
                })
            })
        })
        
    }
    
    
    @IBAction func backPressed(_ sender: Any) {
        mobileAuthViewToPresenterProtocol.popToDashboardView()
    }
    
}

extension MobileAuthViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
