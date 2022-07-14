//
// Copyright (c) 2022 OneWelcome. All rights reserved.
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

protocol FetchDeviceListInteractorProtocol: AnyObject {
    func fetchDeviceList()
}

class FetchDeviceListInteractor: FetchDeviceListInteractorProtocol {
    weak var fetchDeviceListPresenter: FetchDeviceListInteractorToPresenterProtocol?
    let decoder = JSONDecoder()
    private var userClient: UserClient {
        return SharedUserClient.instance
    }
    
    func fetchDeviceList() {
        let request = ResourceRequestFactory.makeResourceRequest(path: "devices", method: .get)
        userClient.sendAuthenticatedRequest(request) { response, error in
            if let error = error {
                let mappedError = ErrorMapper().mapError(error)
                self.fetchDeviceListPresenter?.fetchDeviceListFailed(mappedError)
            } else {
                if let data = response?.data,
                   let deviceList = try? self.decoder.decode(Devices.self, from: data) {
                    self.fetchDeviceListPresenter?.presentDeviceList(deviceList.devices)
                }
            }
        }
    }
}

struct Devices: Codable {
    var devices: [Device]
}

struct Device: Codable {
    var name: String
    var id: String
    var application: String
}
