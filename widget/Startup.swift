//  Copyright © 2020 OneWelcome. All rights reserved.

import OneginiSDKiOS

class Startup {

    func oneginiSDKStartup(completion: @escaping (Bool) -> Void) {
        ClientBuilder().buildAndWaitForProtectedData { client in
            client.start { error in
                completion(error == nil)
            }
        }
    }
}
