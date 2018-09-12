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

class PendingMobileAuthViewController: UIViewController, PendingMobileAuthPresenterViewDelegate {
    var pendingMobileAuths = Array<ONGPendingMobileAuthRequest>() {
        didSet {
            pendingMobileAuthTableView.reloadData()
        }
    }

    weak var pendingMobileAuthPresenter: PendingMobileAuthPresenterProtocol?

    @IBOutlet var pendingMobileAuthTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRefreshControl()
        pendingMobileAuthTableView.register(UINib(nibName: "PendingMobileAuthTableViewCell", bundle: nil), forCellReuseIdentifier: "pendingMobileAuthCell")
        pendingMobileAuthTableView.register(UINib(nibName: "PullToRefreshTableViewCell", bundle: nil), forCellReuseIdentifier: "pullToRefreshCell")
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white
        pendingMobileAuthTableView.backgroundView = refreshControl
        refreshControl.addTarget(self, action: #selector(reloadData(_:)), for: .valueChanged)
    }

    @objc func reloadData(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        pendingMobileAuthPresenter?.reloadPendingMobileAuth()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pendingMobileAuthPresenter?.reloadPendingMobileAuth()
    }
}

extension PendingMobileAuthViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return max(pendingMobileAuths.count, 1)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if pendingMobileAuths.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "pendingMobileAuthCell", for: indexPath) as! PendingMobileAuthTableViewCell
            cell.setup(pendingMobileAuthEntity: pendingMobileAuths[indexPath.row])
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "pullToRefreshCell", for: indexPath)
        }
    }
}

extension PendingMobileAuthViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pendingTransaction = pendingMobileAuths[indexPath.row]
        pendingMobileAuthPresenter?.handlePendingMobileAuth(pendingTransaction)
        pendingMobileAuthPresenter?.reloadPendingMobileAuth()
    }
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        if pendingMobileAuths.count > 0 {
            return 135
        } else {
            return 50
        }
    }
}
