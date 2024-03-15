// Copyright © 2024 OneWelcome. All rights reserved.

import UIKit

typealias IdTokenPresenterProtocol = IdTokenInteractorToPresenterProtocol

protocol IdTokenInteractorToPresenterProtocol: AnyObject {
    func presentIdTokenView()
}

class IdTokenPresenter: IdTokenInteractorToPresenterProtocol {
    let navigationController: UINavigationController
    let idTokenInteractor: IdTokenInteractorProtocol
    
    init(idTokenInteractor: IdTokenInteractorProtocol, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.idTokenInteractor = idTokenInteractor
    }

    func presentIdTokenView() {
        let idTokenViewController = IdTokenViewController()
        navigationController.present(idTokenViewController, animated: true) {
            let token = self.idTokenInteractor.fetchIdToken()
            idTokenViewController.updateIdToken(with: token)
        }
    }
}
