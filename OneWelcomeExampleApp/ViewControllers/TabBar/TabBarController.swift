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

class TabBarController: UITabBarController {
    func setup(navigationController: UINavigationController,
               pendingMobileAuthViewController: UIViewController,
               applicationInfoViewController: UIViewController,
               delegate: UITabBarControllerDelegate) {
        viewControllers = [navigationController, pendingMobileAuthViewController, applicationInfoViewController]
        self.delegate = delegate
        tabBar.isTranslucent = false
        tabBar.tintColor = .appMain

        let tabBarHome = tabBar.items![0]
        tabBarHome.title = "User"
        tabBarHome.image = #imageLiteral(resourceName: "tabBarUserProfile")

        let tabBarPending = tabBar.items![1]
        tabBarPending.title = "Notifications"
        tabBarPending.image = #imageLiteral(resourceName: "tabBarNotification")

        let tabBarApplicationInfo = tabBar.items![2]
        tabBarApplicationInfo.title = "Application details"
        tabBarApplicationInfo.image = #imageLiteral(resourceName: "info")
    }
}
