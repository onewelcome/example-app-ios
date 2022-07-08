//  Copyright © 2020 Onegini. All rights reserved.

import UIKit
import OneginiSDKiOS

class ResourceGateway {
    private var userClient: UserClient {
        return SharedUserClient.instance
    }

    func fetchImplicitResources(profile: UserProfile, completion: @escaping (String?) -> Void) {
        authenticateUserImplicitly(profile) { success in
            if success {
                self.implicitResourcesRequest { userIdDecorated in
                    completion(userIdDecorated)
                }
            } else {
                completion(nil)
            }
        }
    }

    fileprivate func authenticateUserImplicitly(_ profile: UserProfile, completion: @escaping (Bool) -> Void) {
        userClient.implicitlyAuthenticate(user: profile, with: nil) { error in
            completion(error == nil)
        }
    }

    fileprivate func implicitResourcesRequest(completion: @escaping (String?) -> Void) {
        let implicitRequest = ResourceRequestFactory.makeResourceRequest(path: "user-id-decorated")
        userClient.sendImplicitRequest(implicitRequest) { response, error in
            guard let data = response?.data,
                  let responseJsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else {
                      completion(nil)
                      return
                  }
            let userIdDecorated = responseJsonData?["decorated_user_id"]
            completion(userIdDecorated)
        }
    }
}
