//  Copyright © 2022 OneWelcome. All rights reserved.

import UIKit
import WebKit

protocol WebViewDelegate: AnyObject {
    func webView(didCancel webView: UIViewController)
}

class WebViewController: UIViewController {

    var webView: WKWebView!
    var cancelButton: UIButton!
    
    weak var delegate: WebViewDelegate?
    let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .appBackground
        configureCancelButton()
        configureWebView()
    }
    
    func configureWebView() {
        let webConfiguration = WKWebViewConfiguration()
        let webViewFrame = CGRect(x: 0, y: 55, width: view.frame.width, height: view.frame.height - 55)
        webView = WKWebView(frame: webViewFrame, configuration: webConfiguration)
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
        delegate?.webView(didCancel: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
}
