//  Copyright © 2023 OneWelcome. All rights reserved.

import AVFoundation
import UIKit

protocol QRCodePresenterProtocol: AnyObject {
    func setupErrorLabel(text: String)
    func present(with navigationController: UINavigationController, delegate: QRCodeViewDelegate)
    func setupCaptureSession(in view: UIView)
    func startSession()
    func stopSession()
    func cancel()
}

class QRCodePresenter: NSObject, QRCodePresenterProtocol {
    private let qrCodeViewController: QRCodeViewController
    private let navigationController: UINavigationController
    private var captureSession: AVCaptureSession?
    private var previewLayer: AVCaptureVideoPreviewLayer!

    init(qrCodeViewController: QRCodeViewController, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.qrCodeViewController = qrCodeViewController
    }
    
    func present(with navigationController: UINavigationController, delegate: QRCodeViewDelegate) {
        if self.navigationController == navigationController {
            navigationController.present(qrCodeViewController, animated: true, completion: nil)
        } else {
            navigationController.viewControllers = [qrCodeViewController]
            navigationController.modalPresentationStyle = .overFullScreen
            self.navigationController.present(navigationController, animated: false, completion: nil)
        }
        qrCodeViewController.delegate = delegate
    }
    
    func setupCaptureSession(in qrCodeView: UIView) {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        let captureSession = AVCaptureSession()
        self.captureSession = captureSession

        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            handleSetupCaptureSessionFailure()
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

            metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
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
        guard let captureSession, !captureSession.isRunning else { return }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }
    
    func stopSession() {
        guard let captureSession, captureSession.isRunning else { return }
        
        captureSession.stopRunning()
    }
    
    func cancel() {
        stopSession()
        qrCodeViewController.delegate?.qrCodeView(didCancelQRCodeScan: qrCodeViewController)
    }
    
    func setupErrorLabel(text: String) {
        qrCodeViewController.setupErrorLabel(text)
    }
    
    func handleSetupCaptureSessionFailure() {
        captureSession = nil
        qrCodeViewController.delegate?.qrCodeView(didCancelQRCodeScan: qrCodeViewController)
    }
}

extension QRCodePresenter: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from _: AVCaptureConnection) {
        stopSession()

        guard let metadataObject = metadataObjects.first,
              let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
              let stringValue = readableObject.stringValue else { return }
        qrCodeViewController.delegate?.qrCodeView(qrCodeViewController, didScanQRCode: stringValue)
    }
}
