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

protocol AppDetailsInteractorProtocol: AnyObject {
    func fetchDeviceResources()
}

class AppDetailsInteractor: AppDetailsInteractorProtocol {
    weak var appDetailsPresenter: AppDetailsInteractorToPresenterProtocol?
    let decoder = JSONDecoder()

    func fetchDeviceResources() {
        authenticateDevice { success, error in
            if success {
                self.deviceResourcesRequest(completion: { applicationDetails, error in
                    if let applicationDetails = applicationDetails {
                        self.appDetailsPresenter?.setupAppDetailsView(applicationDetails)
                    } else if let error = error {
                        self.appDetailsPresenter?.fetchAppDetailsFailed(error)
                    }
                })
            } else if let error = error {
                self.appDetailsPresenter?.fetchAppDetailsFailed(error)
            }
        }
    }

    fileprivate func authenticateDevice(completion: @escaping (Bool, AppError?) -> Void) {
        //TODO:
//        DeviceClient.sharedInstance().authenticateDevice(["application-details"]) { success, error in
//            if let error = error {
//                let mappedError = ErrorMapper().mapError(error)
//                completion(success, mappedError)
//            } else {
//                completion(success, nil)
//            }
//        }
    }

    fileprivate func deviceResourcesRequest(completion: @escaping (ApplicationDetails?, AppError?) -> Void) {
        //TODO:
//        let resourceRequest = ResourceRequest(path: "application-details", method: "GET")
//        DeviceClient.sharedInstance().fetchResource(resourceRequest) { response, error in
//            if let error = error {
//                let mappedError = ErrorMapper().mapError(error)
//                completion(nil, mappedError)
//            } else {
//                if let data = response?.data {
//                    if let appDetails = try? self.decoder.decode(ApplicationDetails.self, from: data) {
//                        completion(appDetails, nil)
//                    }
//                }
//            }
//        }
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
