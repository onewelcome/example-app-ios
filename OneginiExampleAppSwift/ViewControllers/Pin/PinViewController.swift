//
// Copyright (c) 2016 Onegini. All rights reserved.
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

protocol PinViewControllerEntityProtocol {
    var pin: String? { get set }
    var createPinChallenge: ONGCreatePinChallenge? { get }
    var createPinError: Error? { get }
}

enum PINEntryMode {
    case login
    case registration
    case registrationConfirm
}

class PinViewController: UIViewController {
    
    @IBOutlet weak var pinSlotsView: UIView!
    @IBOutlet weak var backKey: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    let pinDot = #imageLiteral(resourceName: "pinDot")
    let pinDotSelected = #imageLiteral(resourceName: "pinDotSelected")
    
    var mode: PINEntryMode
    
    var registerUserEntity: PinViewControllerEntityProtocol
    let registerUserViewToPresenterProtocol: RegisterUserViewToPresenterProtocol
    
    var pinSlots = Array<UIView>()
    var pinEntry = Array<String>()
    var pinEntryToVerify = Array<String>()
    
    init(mode: PINEntryMode, registerUserEntity: PinViewControllerEntityProtocol, registerUserViewToPresenterProtocol: RegisterUserViewToPresenterProtocol) {
        self.mode = mode
        self.registerUserEntity = registerUserEntity
        self.registerUserViewToPresenterProtocol = registerUserViewToPresenterProtocol
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backKey.isHidden = true
        setupTitleLabel()
        buildPinSlots()
    }
    
    @IBAction func keyPressed(_ key: UIButton) {
        if pinEntry.count >= pinSlots.count {
            return
        }
        pinEntry.append("\(key.tag)")
        evaluatePinState()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        registerUserEntity.pin = nil
        registerUserViewToPresenterProtocol.handleCreatePinRegistrationChallenge(registerUserEntity: registerUserEntity)
    }
    
    @IBAction func backKeyPressed(_ sender: Any) {
        pinEntry.removeLast()
        updatePinStateRepresentation()
    }
    
    func buildPinSlots() {
        guard let challenge = registerUserEntity.createPinChallenge else { return }
        let pinLength = Int(challenge.pinLength)
        let pinSlotMargin = CGFloat(integerLiteral: 40)
        let pinSlotWidth = CGFloat(integerLiteral: 15)
        let offsetX = (pinSlotsView.frame.width - ((CGFloat(integerLiteral:pinLength) * pinSlotWidth) + (CGFloat(integerLiteral:pinLength - 1) * pinSlotMargin))) / CGFloat(integerLiteral:2)
        var pinSlotsArray = Array<UIView>()
        for index in 0...(pinLength - 1) {
            let indexFloat = CGFloat(integerLiteral: index)
            let pinSlotFrame = CGRect(x: offsetX + indexFloat * (pinSlotWidth + pinSlotMargin), y: 0, width: pinSlotWidth, height: CGFloat(integerLiteral: 15))
            let pinSlotView = pinSlotWithFrame(pinSlotFrame)
            pinSlotsArray.append(pinSlotView)
            pinSlotsView.addSubview(pinSlotView)
        }
        pinSlots.append(contentsOf: pinSlotsArray)
    }
    
    func pinSlotWithFrame(_ frame: CGRect) -> UIView {
        let imageView = UIImageView(frame: frame)
        imageView.image = pinDot
        return imageView
    }
    
    func updatePinStateRepresentation() {
        for pinSlot in pinSlots {
            pinSlot.subviews.forEach { $0.removeFromSuperview() }
        }
        
        for index in 0...pinEntry.count {
            if index < pinEntry.count {
                let slot = pinSlots[index]
                let selectedDot = UIImageView(image: pinDotSelected)
                slot.addSubview(selectedDot)
            }
        }
        
        if pinEntry.count == 0 {
            backKey.isHidden = true
        } else {
            backKey.isHidden = false
        }
    }
    
    func reset() {
        for index in 0...(pinEntry.count - 1) {
            pinEntry[index] = "#"
        }
        pinEntry = Array<String>()
        setupTitleLabel()
        updatePinStateRepresentation()
    }
    
    func evaluatePinState() {
        updatePinStateRepresentation()
        
        if pinEntry.count == pinSlots.count {
            let pincode = pinEntry.joined()
            switch mode {
            case .registration:
                pinEntryToVerify = pinEntry
                mode = .registrationConfirm
                reset()
                break
            case .registrationConfirm:
                let pincodeConfirm = pinEntryToVerify.joined()
                if pincode == pincodeConfirm {
                    registerUserEntity.pin = pincode
                    registerUserViewToPresenterProtocol.handleCreatePinRegistrationChallenge(registerUserEntity: registerUserEntity)
                } else {
                    mode = .registration
                    reset()
                    setupErrorLabel(errorDescription:"The confirmation PIN does not match.")
                }
                break
            case .login:
                break
            }
        }
    }
    
    func setupTitleLabel() {
        switch mode {
        case .login:
            titleLabel.text = "Please enter your PIN code"
        case .registration:
            titleLabel.text = "Please create your PIN code"
        case .registrationConfirm:
            titleLabel.text = "Please confirm your PIN code"
        }
        setupErrorLabel(errorDescription: "")
    }
    
    func setupErrorLabel(errorDescription: String) {
        errorLabel.text = errorDescription
    }
}
