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

protocol PinViewControllerEntityProtocol {
    var pin: String? { get set }
    var pinError: AppError? { get }
    var pinLength: Int? { get }
}

protocol PinViewToPresenterProtocol: class {
    func handlePin(entity: PinViewControllerEntityProtocol)
}

enum PINEntryMode {
    case login
    case registration
    case registrationConfirm
}

class PinViewController: UIViewController {
    @IBOutlet var pinSlotsView: UIView!
    @IBOutlet var backKey: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var errorLabel: UILabel!

    let pinDot = #imageLiteral(resourceName: "pinDot")
    let pinDotSelected = #imageLiteral(resourceName: "pinDotSelected")

    var mode: PINEntryMode
    var entity: PinViewControllerEntityProtocol
    unowned let viewToPresenterProtocol: PinViewToPresenterProtocol

    var pinSlots = Array<UIView>()
    var pinEntry = Array<String>()
    var pinEntryToVerify = Array<String>()

    init(mode: PINEntryMode, entity: PinViewControllerEntityProtocol, viewToPresenterProtocol: PinViewToPresenterProtocol) {
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

    @IBAction func cancelButtonPressed(_: Any) {
        entity.pin = nil
        viewToPresenterProtocol.handlePin(entity: entity)
    }

    @IBAction func backKeyPressed(_: Any) {
        pinEntry.removeLast()
        updatePinStateRepresentation()
    }

    func buildPinSlots() {
        guard let pinLength = entity.pinLength else { return }
        let pinSlotMargin = CGFloat(integerLiteral: 40)
        let pinSlotWidth = CGFloat(integerLiteral: 15)
        let offsetX = (pinSlotsView.frame.width - ((CGFloat(integerLiteral: pinLength) * pinSlotWidth) + (CGFloat(integerLiteral: pinLength - 1) * pinSlotMargin))) / CGFloat(integerLiteral: 2)
        var pinSlotsArray = Array<UIView>()
        for index in 0 ... (pinLength - 1) {
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

        for index in 0 ... pinEntry.count {
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
        for index in 0 ... (pinEntry.count - 1) {
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
                    entity.pin = pincode
                    viewToPresenterProtocol.handlePin(entity: entity)
                } else {
                    mode = .registration
                    reset()
                    errorLabel.text = "The confirmation PIN does not match."
                }
                break
            case .login:
                entity.pin = pincode
                viewToPresenterProtocol.handlePin(entity: entity)
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
        errorLabel.text = ""
    }

    func setupErrorLabel(errorDescription: String) {
        if mode == .registrationConfirm {
            mode = .registration
        }
        reset()
        errorLabel.text = errorDescription
    }
}
