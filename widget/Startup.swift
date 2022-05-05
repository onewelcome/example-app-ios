//  Copyright © 2020 Onegini. All rights reserved.

import OneginiSDKiOS

class Startup {

    func oneginiSDKStartup(completion: @escaping (Bool) -> Void) {
        ClientBuilder().build().start { error in
            completion(error == nil)
        }
    }
}
