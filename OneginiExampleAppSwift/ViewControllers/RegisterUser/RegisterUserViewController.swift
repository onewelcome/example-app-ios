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



class RegisterUserViewController: UIViewController {

    @IBOutlet weak var identityProvidersTableView: UITableView?
    
    var registerUserViewToPresenterProtocol: RegisterUserViewToPresenterProtocol? = nil
    
    var identityProviders = [ONGIdentityProvider]() {
        didSet  {
            if let identityProvidersTableView = identityProvidersTableView {
                identityProvidersTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        if let identityProvidersTableView = identityProvidersTableView {
            identityProvidersTableView.register(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonCell")
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        registerUserViewToPresenterProtocol?.signUp()
    }
    
}

extension RegisterUserViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return identityProviders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonTableViewCell
        let identityProviderName = identityProviders[indexPath.row].name
        cell.button.setTitle(identityProviderName, for: .normal)
        return cell
    }
}
