//
// Copyright (c) 2018 Onegini. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


import UIKit

protocol FetchImplicitDataInteractorProtocol {
    func fetchImplicitResources(profile: ONGUserProfile)
}

class FetchImplicitDataInteractor: FetchImplicitDataInteractorProtocol {
    
    weak var loginPresenter: LoginInteractorToPresenterProtocol?
    
    func fetchImplicitResources(profile: ONGUserProfile) {
        if isProfileImplicitlyAuthenticated(profile) {
            implicitResourcesRequest { userIdDecorated in
                self.loginPresenter?.presentImplicitData(data: userIdDecorated)
            }
        } else {
            authenticateUserImplicitly(profile) { success in
                if success {
                    self.implicitResourcesRequest { userIdDecorated in
                        self.loginPresenter?.presentImplicitData(data: userIdDecorated)
                    }
                }
            }
        }
    }
    
    fileprivate func isProfileImplicitlyAuthenticated(_ profile: ONGUserProfile) -> Bool {
        let implicitlyAuthenticatedProfile = ONGUserClient.sharedInstance().implicitlyAuthenticatedUserProfile()
        
        return implicitlyAuthenticatedProfile != nil && implicitlyAuthenticatedProfile == profile
    }
    
    fileprivate func authenticateUserImplicitly(_ profile: ONGUserProfile, completion:@escaping (Bool) -> Void) {
        ONGUserClient.sharedInstance().implicitlyAuthenticateUser(profile, scopes: nil) { success, error in
            if !success {
                print(error)
            }
            completion(success)

        }
    }
    
    fileprivate func implicitResourcesRequest(completion:@escaping (String) -> Void) {
        let implicitRequest = ONGResourceRequest(path: "resources/user-id-decorated", method: "GET")
        ONGUserClient.sharedInstance().fetchImplicitResource(implicitRequest) { response, error in
            if let error = error {
                print(error)
            } else {
                if let data = response?.data {
                    if let responseData = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: String],
                        let userIdDecorated = responseData["decorated_user_id"] {
                            completion(userIdDecorated)
                    }
                }
            }
        }
    }

}
