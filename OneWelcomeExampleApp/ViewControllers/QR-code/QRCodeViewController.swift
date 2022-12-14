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

import AVFoundation
import UIKit

protocol QRCodeViewDelegate {
    func qrCodeView(_ qrCodeView: UIViewController, didScanQRCode qrCode: String)
    func qrCodeView(didCancelQRCodeScan qrCodeView: UIViewController)
}

class QRCodeViewController: UIViewController {
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var qrCodeView: UIView!

    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!

    private let qrCodeViewDelegate: QRCodeViewDelegate

    init(qrCodeViewDelegate: QRCodeViewDelegate) {
        self.qrCodeViewDelegate = qrCodeViewDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let previewLayer = previewLayer {
            previewLayer.frame = qrCodeView.layer.bounds
            previewLayer.videoGravity = .resizeAspectFill
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        
        setupCaptureSession()
        startSession()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if captureSession?.isRunning == false {
            startSession()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }

    func setupErrorLabel(_ errorMessage: String?) {
        startSession()
        errorLabel.text = errorMessage
        shakeLabel(errorLabel)
    }
    
    @IBAction func cancel(_: Any) {
        qrCodeViewDelegate.qrCodeView(didCancelQRCodeScan: self)
    }
}

extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from _: AVCaptureConnection) {
        captureSession.stopRunning()

        guard let metadataObject = metadataObjects.first,
              let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
              let stringValue = readableObject.stringValue else { return }
        qrCodeViewDelegate.qrCodeView(self, didScanQRCode: stringValue)
    }
}

private extension QRCodeViewController {
    func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        
        captureSession = AVCaptureSession()

        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            //TODO: no handleSetupCaptureSessionFailure() call?
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            handleSetupCaptureSessionFailure()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            handleSetupCaptureSessionFailure()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = qrCodeView.bounds
        previewLayer.videoGravity = .resizeAspectFill
        qrCodeView.layer.addSublayer(previewLayer)
    }
    
    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    func handleSetupCaptureSessionFailure() {
        captureSession = nil
        qrCodeViewDelegate.qrCodeView(didCancelQRCodeScan: self)
    }
    
    func shakeLabel(_ label: UILabel) {
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
