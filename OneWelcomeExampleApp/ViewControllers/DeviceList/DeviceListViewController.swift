//
// Copyright © 2022 OneWelcome. All rights reserved.
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

protocol DeviceListDelegate: AnyObject {
    func deviceList(didCancel deviceListViewController: DeviceListViewController)
}

class DeviceListViewController: UIViewController {
    private let callClassName = String(describing: DeviceTableViewCell.self)
    
    weak var delegate: DeviceListDelegate?
    
    @IBOutlet private var tableView: UITableView?
    @IBOutlet private var cancelButton: UIButton?
    
    var deviceList: [Device] = [] {
        didSet {
            tableView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(UINib(nibName: callClassName, bundle: nil), forCellReuseIdentifier: callClassName)
    }
}

extension DeviceListViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return deviceList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: callClassName, for: indexPath) as! DeviceTableViewCell
        let device = deviceList[indexPath.row]

        cell.applicationLabel.text = device.application
        cell.nameLabel.text = device.name
        cell.idLabel.text = device.id
        return cell
    }
}

private extension DeviceListViewController {
    @IBAction func cancel(_: Any) {
        delegate?.deviceList(didCancel: self)
    }
}
