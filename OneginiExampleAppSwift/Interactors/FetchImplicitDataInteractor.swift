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
import OneginiSDKiOS

protocol FetchImplicitDataInteractorProtocol: AnyObject {
    func fetchImplicitResources(profile: UserProfile, completion: @escaping (String?, AppError?) -> Void)
}

class FetchImplicitDataInteractor: FetchImplicitDataInteractorProtocol {
    private var userClient: UserClient {
        return SharedUserClient.instance
    }
    
    func fetchImplicitResources(profile: UserProfile, completion: @escaping (String?, AppError?) -> Void) {
        if isProfileImplicitlyAuthenticated(profile) {
            implicitResourcesRequest { userIdDecorated, error in
                if let userIdDecorated = userIdDecorated {
                    completion(userIdDecorated, nil)
                } else if let error = error {
                    completion(nil, error)
                }
            }
        } else {
            authenticateUserImplicitly(profile) { error in
                if error == nil {
                    self.implicitResourcesRequest { userIdDecorated, error in
                        if let userIdDecorated = userIdDecorated {
                            completion(userIdDecorated, nil)
                        } else if let error = error {
                            completion(nil, error)
                        }
                    }
                } else {
                    if let error = error {
                        completion(nil, error)
                    }
                }
            }
        }
    }

    fileprivate func isProfileImplicitlyAuthenticated(_ profile: UserProfile) -> Bool {
        userClient.implicitlyAuthenticatedUserProfile?.isEqual(to: profile) ?? false
    }

    fileprivate func authenticateUserImplicitly(_ profile: UserProfile, completion: @escaping (AppError?) -> Void) {
        userClient.implicitlyAuthenticate(user: profile, with: nil) { error in
            completion(error.flatMap { ErrorMapper().mapError($0) })
        }
    }

    fileprivate func implicitResourcesRequest(completion: @escaping (String?, AppError?) -> Void) {
        let implicitRequest = ResourceRequestFactory.makeResourceRequest(path: "user-id-decorated", method: .get)
        userClient.sendImplicitRequest(implicitRequest) { response, error in
            if let error = error {
                let mappedError = ErrorMapper().mapError(error)
                completion(nil, mappedError)
            } else {
                if let data = response?.data {
                    if let responseData = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                       let userIdDecorated = responseData["decorated_user_id"] {
                        completion(userIdDecorated, nil)
                    }
                }
            }
        }
    }
}
