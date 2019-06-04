//  Copyright © 2019 Onegini. All rights reserved.

import UIKit
import WebKit

protocol WebViewDelegate: class {
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
        view.backgroundColor = UIColor.white
        configureCancelButton()
        configureWebView()
    }
    
    func configureWebView() {
        let webConfiguration = WKWebViewConfiguration()
        let webViewFrame = CGRect(x: 0, y: 55, width: view.frame.width, height: view.frame.height - 55)
        webView = WKWebView(frame: webViewFrame, configuration: webConfiguration)
        view.addSubview(webView)
    }
    
    func configureCancelButton() {
        let cancelButtonFrame = CGRect(x: view.frame.width - 70, y: 30, width: 70, height: 25)
        cancelButton = UIButton(frame: cancelButtonFrame)
        let cancelButtonStringAttributes: [NSAttributedStringKey: Any] = [
            .font: UIFont(name: "Helvetica Neue", size: 17)!,
            .foregroundColor: UIColor(red: 0 / 255, green: 113 / 255, blue: 155 / 255, alpha: 1),
        ]
        let cancelButtonString = NSAttributedString(string: "Cancel", attributes: cancelButtonStringAttributes)
        cancelButton.setTitleColor(UIColor.black, for: .normal)
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
