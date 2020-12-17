//  Copyright © 2020 Onegini. All rights reserved.

import UIKit
import OneginiSDKiOS

class ResourceGateway {
    
    func fetchImplicitResources(profile: ONGUserProfile, completion: @escaping (String?) -> Void) {
        if isProfileImplicitlyAuthenticated(profile) {
            implicitResourcesRequest { userIdDecorated in
                completion(userIdDecorated)
            }
        } else {
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
    }

    fileprivate func isProfileImplicitlyAuthenticated(_ profile: ONGUserProfile) -> Bool {
        let implicitlyAuthenticatedProfile = ONGUserClient.sharedInstance().implicitlyAuthenticatedUserProfile()
        return implicitlyAuthenticatedProfile != nil && implicitlyAuthenticatedProfile == profile
    }

    fileprivate func authenticateUserImplicitly(_ profile: ONGUserProfile, completion: @escaping (Bool) -> Void) {
        ONGUserClient.sharedInstance().implicitlyAuthenticateUser(profile, scopes: nil) { success, error in
            completion(success)
        }
    }

    fileprivate func implicitResourcesRequest(completion: @escaping (String?) -> Void) {
        let implicitRequest = ONGResourceRequest(path: "user-id-decorated", method: "GET")
        ONGUserClient.sharedInstance().fetchImplicitResource(implicitRequest) { response, error in
            guard let data = response?.data,
                  let responseData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] else {
                completion(nil)
                return
            }
            let userIdDecorated = responseData["decorated_user_id"]
            completion(userIdDecorated)
        }
    }

}
