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
import WebKit

protocol BrowserViewControllerEntityProtocol {
    var browserRegistrationChallenge: BrowserRegistrationChallenge? { get }
    var registrationUserURL: URL? { get }
    var redirectURL: URL? { get set }
    var pin: String? { get set }
}

class BrowserViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!
    var cancelButton: UIButton!

    var registerUserEntity: BrowserViewControllerEntityProtocol
    let registerUserViewToPresenterProtocol: RegisterUserViewToPresenterProtocol

    init(registerUserEntity: BrowserViewControllerEntityProtocol, registerUserViewToPresenterProtocol: RegisterUserViewToPresenterProtocol) {
        self.registerUserEntity = registerUserEntity
        self.registerUserViewToPresenterProtocol = registerUserViewToPresenterProtocol
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .appBackground
        configureCancelButton()
        configureWebView()
        let presentationController = navigationController?.presentationController ?? presentationController
        presentationController?.delegate = self
    }

    func configureWebView() {
        let webConfiguration = WKWebViewConfiguration()
        let webViewFrame = CGRect(x: 0, y: 55, width: view.frame.width, height: view.frame.height - 55)
        webView = WKWebView(frame: webViewFrame, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        view.addSubview(webView)
    }

    func configureCancelButton() {
        let cancelButtonFrame = CGRect(x: view.frame.width - 70, y: 30, width: 70, height: 25)
        cancelButton = UIButton(frame: cancelButtonFrame)
        let cancelButtonStringAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Helvetica Neue", size: 17)!,
            .foregroundColor: UIColor.appMain,
        ]
        let cancelButtonString = NSAttributedString(string: "Cancel", attributes: cancelButtonStringAttributes)
        cancelButton.setTitleColor(.label, for: .normal)
        cancelButton.setAttributedTitle(cancelButtonString, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        view.addSubview(cancelButton)
    }

    @objc func cancelButtonPressed() {
        registerUserEntity.redirectURL = nil
        registerUserViewToPresenterProtocol.handleRedirectURL()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let registrationUserURL = registerUserEntity.registrationUserURL else { return }
        let urlRequest = URLRequest(url: registrationUserURL)
        webView.load(urlRequest)
    }
}

extension BrowserViewController: WKNavigationDelegate {
    func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url,
            let oneginiConfig = OneginiConfigModel.configuration() as? [String: String],
            let redirectUrl = oneginiConfig["ONGRedirectURL"] else {
            decisionHandler(.allow)
            return
        }
        if url.absoluteString.hasPrefix(redirectUrl) {
            registerUserEntity.redirectURL = url
            registerUserViewToPresenterProtocol.handleRedirectURL()
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

extension BrowserViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        cancelButtonPressed()
    }
}
