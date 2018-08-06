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

class ProfileViewController: UIViewController {

    let profileViewToPresenterProtocol: ProfileViewToPresenterProtocol
    
    init(_ profileViewToPresenterProtocol: ProfileViewToPresenterProtocol) {
        self.profileViewToPresenterProtocol = profileViewToPresenterProtocol
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func backPressed(_ sender: Any) {
        profileViewToPresenterProtocol.popToDashboardView()
    }
    
    @IBAction func disconnectProfile(_ sender: Any) {
        profileViewToPresenterProtocol.setupDisconnectPresenter()
    }
    
    @IBAction func deviceList(_ sender: Any) {
        
    }
    
    @IBAction func changePassword(_ sender: Any) {
        
    }
    
    @IBAction func changeProfileName(_ sender: Any) {
        
    }
    
    
    
}
