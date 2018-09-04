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

protocol MobileAuthInteractorProtocol {
    func enrollForMobileAuth()
    func enrollForPushMobileAuth()
    func isUserEnrolledForMobileAuth() -> Bool
    func isUserEnrolledForPushMobileAuth() -> Bool
}

class MobileAuthInteractor: MobileAuthInteractorProtocol {

    weak var mobileAuthPresenter: MobileAuthInteractorToPresenterProtocol?
    
    func isUserEnrolledForMobileAuth() -> Bool {
        let userClient = ONGUserClient.sharedInstance()
        if let userProfile = userClient.authenticatedUserProfile() {
            return userClient.isUserEnrolled(forMobileAuth: userProfile)
        }
        return false
    }
    
    func isUserEnrolledForPushMobileAuth() -> Bool {
        let userClient = ONGUserClient.sharedInstance()
        if let userProfile = userClient.authenticatedUserProfile() {
            return userClient.isUserEnrolled(forPushMobileAuth: userProfile)
        }
        return false
    }
    
    func enrollForMobileAuth() {
        ONGUserClient.sharedInstance().enroll { enrolled, error in
            if enrolled {
                self.mobileAuthPresenter?.mobileAuthEnrolled()
            } else {
                if let error = error {
                    let mappedError = ErrorMapper().mapError(error)
                    self.mobileAuthPresenter?.enrollMobileAuthFailed(mappedError)
                }
            }
        }
    }
    
    func enrollForPushMobileAuth() {
        ONGUserClient.sharedInstance().enroll { enrolled, error in
            if enrolled {
                self.mobileAuthPresenter?.pushMobileAuthEnrolled()
            } else {
                if let error = error {
                    let mappedError = ErrorMapper().mapError(error)
                    self.mobileAuthPresenter?.enrollPushMobileAuthFailed(mappedError)
                }
            }
        }
    }
    
}
