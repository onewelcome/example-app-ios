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

protocol QRCodeViewDelegate: AnyObject {
    func qrCodeView(_ qrCodeView: UIViewController, didScanQRCode qrCode: String)
    func qrCodeView(didCancelQRCodeScan qrCodeView: UIViewController)
}

class QRCodeViewController: UIViewController {
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var qrCodeView: UIView!
    
    weak var delegate: QRCodeViewDelegate?
    weak var qrCodePresenter: QRCodePresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        
        qrCodePresenter?.setupCaptureSession(in: qrCodeView)
        qrCodePresenter?.startSession()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        qrCodePresenter?.startSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        qrCodePresenter?.stopSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        qrCodePresenter?.setupCaptureSession(in: qrCodeView)
    }

    func setupErrorLabel(_ errorMessage: String?) {
        qrCodePresenter?.startSession()
        errorLabel.text = errorMessage
        shake(errorLabel)
    }
    
    @IBAction func cancel(_: Any) {
        qrCodePresenter?.cancel()
    }
}

private extension QRCodeViewController {
    func shake(_ label: UILabel) {
        let key = "position"
        let animation: CABasicAnimation = {
            let animation = CABasicAnimation(keyPath: key)
            animation.duration = 0.1
            animation.repeatCount = 2
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: label.center.x - 10, y: label.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: label.center.x + 10, y: label.center.y))
            return animation
        }()
        
        label.layer.add(animation, forKey: key)
    }
}
