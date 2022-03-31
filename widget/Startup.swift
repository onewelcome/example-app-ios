//  Copyright © 2020 Onegini. All rights reserved.

import OneginiSDKiOS

class Startup {

    func oneginiSDKStartup(completion: @escaping (Bool) -> Void) {
        //TODO: take proper values
        let configuration = Configuration(certificates: [],
                                          configuration: [:],
                                          jailbreakDetection: true,
                                          debugDetection: true,
                                          debugLogs: true)
        let client = ClientBuilder().build(configuration: configuration)
        
        client.start { success, error in
            completion(success)
        }
    }
}
