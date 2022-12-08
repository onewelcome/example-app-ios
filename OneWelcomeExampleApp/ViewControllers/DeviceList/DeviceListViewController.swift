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
    private var cancelButton: UIButton!
    
    weak var delegate: DeviceListDelegate?
    
    @IBOutlet private var tableView: UITableView?
    
    var deviceList: [Device] = [] {
        didSet {
            tableView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(UINib(nibName: callClassName, bundle: nil), forCellReuseIdentifier: callClassName)
//    }
//
//    override func loadView() {
//        super.loadView()
        configureCancelButton()
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
    //TODO: refactor
    func configureCancelButton() {
        let cancelButtonFrame = CGRect(x: view.frame.width - 70, y: 30, width: 70, height: 25)
        cancelButton = UIButton(frame: cancelButtonFrame)
        let cancelButtonStringAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Helvetica Neue", size: 17)!,
            .foregroundColor: UIColor.appMain,
        ]
        let cancelButtonString = NSAttributedString(string: "Cancel", attributes: cancelButtonStringAttributes)
        cancelButton.setTitleColor(.label, for: .normal)
        cancelButton.setAttributedTitle(cancelButtonString, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
//        cancelButton.addAction(UIAction.init(handler: { <#UIAction#> in
//            //TODO: sth like delegate?
//            @objc func cancelButtonPressed() {
//                dismiss(animated: false, completion: nil)
//        }), for: <#T##UIControl.Event#>)
        view.addSubview(cancelButton)
    }
    //TODO: sth like delegate?
//    @objc func cancelButtonPressed() {
//        delegate?.webView(didCancel: self)
//    }
//
    @objc func cancelButtonPressed() {
//        dismiss(animated: true, completion: nil)
        delegate?.deviceList(didCancel: self)
    }
}
