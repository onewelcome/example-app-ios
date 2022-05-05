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

protocol LoginViewDelegate: class {
    
    func loginView(_ loginView: UIViewController, didLoginProfile profile: UserProfile, withAuthenticator authenticator: Authenticator?)
    func loginView(profilesInLoginView loginView: UIViewController) -> [UserProfile]
    func loginView(_ loginView: UIViewController, authenticatorsForProfile profile: UserProfile) -> [Authenticator]
    func loginView(_ loginView: UIViewController, implicitDataForProfile profile: UserProfile, completion: @escaping (String?) -> Void)
}

class LoginViewController: UIViewController {
    @IBOutlet var profilesTableView: UITableView?
    @IBOutlet var authenticatorsTableView: UITableView?

    @IBOutlet var implicitData: UILabel!

    var profiles = [UserProfile]() {
        didSet {
            if let tableView = profilesTableView {
                tableView.reloadData()
            }
        }
    }

    var authenticators = [Authenticator]() {
        didSet {
            if let tableView = authenticatorsTableView {
                tableView.reloadData()
            }
        }
    }

    weak var loginDelegate: LoginViewDelegate?
    var selectedProfile: UserProfile!// = UserProfileImplementation(profileId: "FakeId") //TODO: solve somehow

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        guard let profilesTableView = profilesTableView,
            let authenticatorsTableView = authenticatorsTableView,
            let loginDelegate = loginDelegate else { return }
        profilesTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileIdCell")
        authenticatorsTableView.register(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
    
        profiles = loginDelegate.loginView(profilesInLoginView: self)
        profilesTableView.reloadData()
        selectProfile(index: 0)
        loginDelegate.loginView(self, implicitDataForProfile: selectedProfile, completion: { (implicitDataString) in
            self.implicitData.text = implicitDataString
        })
        authenticators = loginDelegate.loginView(self, authenticatorsForProfile: selectedProfile)
    }

    func selectProfile(index: Int) {
        guard let profilesTableView = profilesTableView else { return }
        selectedProfile = profiles[index]
        if let indexPaths = profilesTableView.indexPathsForSelectedRows {
            for indexPath in indexPaths {
                profilesTableView.deselectRow(at: indexPath, animated: false)
                profilesTableView.delegate?.tableView?(profilesTableView, didDeselectRowAt: indexPath)
            }
        }
        let indexPath = IndexPath(row: index, section: 0)
        profilesTableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        profilesTableView.delegate?.tableView?(profilesTableView, didSelectRowAt: indexPath)
    }

    func reloadAuthenticators(){
        if let tableView = authenticatorsTableView {
            tableView.reloadData()
        }
    }
    
    @IBAction func login(_: Any) {
        guard let loginDelegate = loginDelegate else { return }
        loginDelegate.loginView(self, didLoginProfile: selectedProfile, withAuthenticator: nil)
    }
}

extension LoginViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection _: Int) -> Int {
        if tableView == profilesTableView {
            return profiles.count
        } else if tableView == authenticatorsTableView {
            return authenticators.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == profilesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileIdCell", for: indexPath) as! ProfileTableViewCell
            cell.profileIdLabel.text = profiles[indexPath.row].profileId

            cell.tickImage.image = profiles[indexPath.row].isEqual(to: selectedProfile) ? #imageLiteral(resourceName: "tick") : nil
            
            return cell
        }
        if tableView == authenticatorsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonTableViewCell
            let authenticatorName = authenticators[indexPath.row].name
            cell.title.text = authenticatorName
            return cell
        }
        return UITableViewCell()
    }
}

extension LoginViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == profilesTableView {
            let cell = tableView.cellForRow(at: indexPath) as! ProfileTableViewCell
            if !profiles[indexPath.row].isEqual(to: selectedProfile) {
                selectedProfile = profiles[indexPath.row]
                guard let loginDelegate = loginDelegate else { return }
                authenticators = loginDelegate.loginView(self, authenticatorsForProfile: selectedProfile)
            }
            
            loginDelegate?.loginView(self, implicitDataForProfile: selectedProfile, completion: { (implicitDataString) in
                self.implicitData.text = implicitDataString
            })
            cell.tickImage.image = #imageLiteral(resourceName: "tick")
        } else if tableView == authenticatorsTableView {
            let authenticator = authenticators[indexPath.row]
            loginDelegate?.loginView(self, didLoginProfile: selectedProfile, withAuthenticator: authenticator)
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView == profilesTableView {
            let cell = tableView.cellForRow(at: indexPath) as! ProfileTableViewCell
            cell.tickImage.image = nil
        }
    }
}
