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

class LoginViewController: UIViewController {

    @IBOutlet weak var profilesTableView: UITableView?
    @IBOutlet weak var authenticatorsTableView: UITableView?
    
    var profiles = [ONGUserProfile]() {
        didSet {
            if let tableView = profilesTableView {
                tableView.reloadData()
            }
        }
    }
    var authenticators = [ONGAuthenticator]() {
        didSet {
            if let tableView = authenticatorsTableView {
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        guard let profilesTableView = profilesTableView,
            let authenticatorsTableView = authenticatorsTableView else { return }
        profilesTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileIdCell")
        authenticatorsTableView.register(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
    }
    
}

extension LoginViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == profilesTableView {
            return profiles.count
        } else if tableView == authenticatorsTableView {
            return 4
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == profilesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileIdCell", for: indexPath) as! ProfileTableViewCell
            cell.profileIdLabel.text = profiles[indexPath.row].profileId
            return cell
        }
        if tableView == authenticatorsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonTableViewCell
            cell.button.setTitle("Face ID", for: .normal)
            return cell
        }
        return UITableViewCell()
    }
}

extension LoginViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == profilesTableView {
            let cell = tableView.cellForRow(at: indexPath) as! ProfileTableViewCell
            cell.tickImage.image = #imageLiteral(resourceName: "tick")
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == profilesTableView {
            let cell = tableView.cellForRow(at: indexPath) as! ProfileTableViewCell
            cell.tickImage.image = nil
        }
    }
}
