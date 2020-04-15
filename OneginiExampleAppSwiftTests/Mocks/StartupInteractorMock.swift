//
//  StartupInteractorMock.swift
//  OneginiExampleAppSwiftTests
//
//  Created by Łukasz Łabuński on 10/04/2020.
//  Copyright © 2020 Onegini. All rights reserved.
//

import UIKit

class StartupInteractorMock: StartupInteractorProtocol {
    
    var isOneginiSDKStartupMethodCalled: Bool = false
    var completionMock: (Bool, Error?) = (true, nil)
    
    func oneginiSDKStartup(completion: @escaping (Bool, Error?) -> Void) {
        isOneginiSDKStartupMethodCalled = true
        completion(completionMock.0, completionMock.1)
    }

}
