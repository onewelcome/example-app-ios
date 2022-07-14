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

class AuthenticatorsViewController: UIViewController {
    @IBOutlet var authenticatorsTableView: UITableView?

    var selectedRow: Int?

    weak var authenticatorsViewToPresenterProtocol: AuthenticatorsViewToPresenterProtocol?
    var authenticatorsList = [Authenticator]() {
        didSet {
            authenticatorsTableView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let authenticatorsTableView = authenticatorsTableView {
            authenticatorsTableView.register(UINib(nibName: "AuthenticatorTableViewCell", bundle: nil), forCellReuseIdentifier: "AuthenticatorTableViewCell")
        }
    }

    @IBAction func backPressed(_: Any) {
        authenticatorsViewToPresenterProtocol?.popToDashboardView()
    }
}

extension AuthenticatorsViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return authenticatorsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuthenticatorTableViewCell", for: indexPath) as! AuthenticatorTableViewCell
        let authenticator = authenticatorsList[indexPath.row]
        cell.setupCell(authenticator)
        cell.authenticatorsViewController = self
        cell.selectedRow = { selectedCell in
            let selectedIndex = self.authenticatorsTableView?.indexPath(for: selectedCell)
            self.authenticatorsTableView?.selectRow(at: selectedIndex, animated: true, scrollPosition: .none)
        }
        return cell
    }

    func registerAuthenticator(_ authenticator: Authenticator) {
        authenticatorsViewToPresenterProtocol?.registerAuthenticator(authenticator)
    }

    func deregisterAuthenticator(_ authenticator: Authenticator) {
        authenticatorsViewToPresenterProtocol?.deregisterAuthenticator(authenticator)
    }

    func finishDeregistrationAnimation() {
        guard let indexPathForSelectedRow = authenticatorsTableView?.indexPathForSelectedRow else { return }
        let selectedCell = authenticatorsTableView?.cellForRow(at: indexPathForSelectedRow) as! AuthenticatorTableViewCell
        selectedCell.deregistrationFinished()
    }
}
