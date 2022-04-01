//  Copyright © 2020 Onegini. All rights reserved.

import UIKit
import OneginiSDKiOS

class ResourceGateway {
    private let userClient: UserClient = sharedUserClient() //TODO: pass in init
    
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
        userClient.implicitlyAuthenticateUser(userProfile: profile, scopes: nil) { success, _ in
            completion(success)
        }
    }

    fileprivate func implicitResourcesRequest(completion: @escaping (String?) -> Void) {
        let implicitRequest = ResourceRequest(path: "user-id-decorated", method: .get)
        
        userClient.fetchImplicitResource(request: implicitRequest) { response, error in
            guard let data = response?.data,
                  let responseJsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                  let responseData = responseJsonData else {
                      completion(nil)
                      return
                  }
            let userIdDecorated = responseData["decorated_user_id"]
            completion(userIdDecorated)
        }
    }
}
