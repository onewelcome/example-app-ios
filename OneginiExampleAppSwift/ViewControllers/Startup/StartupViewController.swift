//
// Copyright (c) 2016 Onegini. All rights reserved.
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

enum State {
    case loading
    case loaded
}

class StartupViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
 
    var state: State = .loading {
        didSet {
            if state == .loaded {
                hideActivityIndicator()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        navigationController?.navigationBar.isHidden = true
        if state == .loading {
            showActivityIndicator()
        }
    }
    
    func showActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}
