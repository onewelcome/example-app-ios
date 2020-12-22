//  Copyright © 2020 Onegini. All rights reserved.

import OneginiSDKiOS

class Startup {

    func oneginiSDKStartup(completion: @escaping (Bool) -> Void) {
        ONGClientBuilder().build()
        ONGClient.sharedInstance().start { result, error in
            completion(result)
        }
    }
    
}
