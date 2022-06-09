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

protocol AppDetailsInteractorProtocol: AnyObject {
    func fetchDeviceResources()
}

class AppDetailsInteractor: AppDetailsInteractorProtocol {
    weak var appDetailsPresenter: AppDetailsInteractorToPresenterProtocol?
    let decoder = JSONDecoder()
    private var deviceClient: DeviceClient {
        return SharedDeviceClient.instance
    }
    
    func fetchDeviceResources() {
        authenticateDevice { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.deviceResourcesRequest { applicationDetails, error in
                    if let applicationDetails = applicationDetails {
                        self.appDetailsPresenter?.setupAppDetailsView(applicationDetails)
                    } else if let error = error {
                        self.appDetailsPresenter?.fetchAppDetailsFailed(error)
                    }
                }
                return
            }
            self.appDetailsPresenter?.fetchAppDetailsFailed(error)
        }
    }

    fileprivate func authenticateDevice(completion: @escaping (AppError?) -> Void) {
        deviceClient.authenticateDevice(with: ["application-details"]) { error in
            completion(error.flatMap { ErrorMapper().mapError($0) })
        }
    }

    fileprivate func deviceResourcesRequest(completion: @escaping (ApplicationDetails?, AppError?) -> Void) {
        let resourceRequest = ResourceRequestFactory.makeResourceRequest(path: "application-details")
        deviceClient.sendRequest(resourceRequest) { response, error in
            if let error = error {
                let mappedError = ErrorMapper().mapError(error)
                completion(nil, mappedError)
            } else {
                if let data = response?.data {
                    if let appDetails = try? self.decoder.decode(ApplicationDetails.self, from: data) {
                        completion(appDetails, nil)
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
