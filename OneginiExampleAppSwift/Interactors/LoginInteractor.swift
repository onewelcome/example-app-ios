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

public protocol LoginInteractorProtocol {
    func userProfiles() -> Set<ONGUserProfile>
    func authenticators(profile: ONGUserProfile) -> Set<ONGAuthenticator>
}

class LoginInteractor: LoginInteractorProtocol {

    func userProfiles() -> Set<ONGUserProfile> {
        return ONGUserClient.sharedInstance().userProfiles()
    }
    
    func authenticators(profile: ONGUserProfile) -> Set<ONGAuthenticator> {
        return ONGUserClient.sharedInstance().allAuthenticators(forUser: profile)
    }
    
}
