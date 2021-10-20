//  Copyright © 2021 Onegini. All rights reserved.

import UIKit
import Swinject

protocol LazyWindowPresenterProtocol {
    var instance: UIWindow { get }
    
    func setUp()
    func setRootViewController(to viewController: UIViewController?)
}

struct LazyWindowPresenter: LazyWindowPresenterProtocol {
    let window: Lazy<UIWindow>

    var instance: UIWindow {
        return window.instance
    }
    
    func setUp() {
        instance.backgroundColor = UIColor.white
        instance.makeKeyAndVisible()
    }
    
    func setRootViewController(to viewController: UIViewController?) {
        instance.rootViewController = viewController
    }
}
