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

protocol AppDetailsInteractorProtocol {
    func fetchDeviceResources()
}

class AppDetailsInteractor: AppDetailsInteractorProtocol {
    
    weak var appDetailsPresenter: AppDetailsInteractorToPresenterProtocol?
    let decoder = JSONDecoder()
    
    func fetchDeviceResources() {
        authenticateDevice { success in
            if success {
                self.deviceResourcesRequest(completion: { applicationDetails in
                    self.appDetailsPresenter?.setupAppDetailsView(applicationDetails)
                })
            }
        }
    }
    
    fileprivate func authenticateDevice(completion:@escaping (Bool) -> Void ) {
        ONGDeviceClient.sharedInstance().authenticateDevice(["application-details"]) { success, error in
            if let error = error {
                print(error)
            } else {
                completion(success)
            }
        }
    }
    
    fileprivate func deviceResourcesRequest(completion: @escaping (ApplicationDetails) -> Void) {
        let resourceRequest = ONGResourceRequest(path: "resources/application-details", method: "GET")
        ONGDeviceClient.sharedInstance().fetchResource(resourceRequest) { response, error in
            if let error = error {
                print(error)
            } else {
                if let data = response?.data {
                    if let appDetails = try? self.decoder.decode(ApplicationDetails.self, from: data) {
                        completion(appDetails)
                    }
                }
            }
        }
    }
}

struct ApplicationDetails: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case appId = "application_identifier"
        case appVersion = "application_version"
        case appPlatform = "application_platform"
    }
    
    let appId: String
    let appVersion: String
    let appPlatform: String
    
}
