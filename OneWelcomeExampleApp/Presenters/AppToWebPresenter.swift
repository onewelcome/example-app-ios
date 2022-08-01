//  Copyright © 2022 OneWelcome. All rights reserved.

import UIKit

protocol AppToWebPresenterProtocol {
    func presentSingleSignOn()
}

class AppToWebPresenter: AppToWebPresenterProtocol {
    
    var appToWebInteractor: AppToWebInteractorProtocol
    let navigationController: UINavigationController

    init(appToWebInteractorProtocol: AppToWebInteractorProtocol, navigationController: UINavigationController) {
        self.appToWebInteractor = appToWebInteractorProtocol
        self.navigationController = navigationController
    }
    
    func presentSingleSignOn() {
        appToWebInteractor.appToWebSingleSignOn { (url, error) in
            if let url = url {
                let webView = WebViewController(url: url)
                webView.delegate = self
                self.navigationController.present(webView, animated: true, completion: nil)
            } else if let error = error {
                guard let appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self) else { fatalError() }
                appRouter.setupErrorAlert(error: error)
            }
        }
    }
}

extension AppToWebPresenter: WebViewDelegate {
    
    func webView(didCancel webView: UIViewController) {
        navigationController.dismiss(animated: true, completion: nil)
    }

}
