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

class TabBarController: UITabBarController {
    func setup(navigationController: UINavigationController, pendingMobileAuthViewController : UIViewController, delegate : UITabBarControllerDelegate){
        self.viewControllers = [navigationController, pendingMobileAuthViewController]
        self.delegate = delegate;
        let tabBarHome = self.tabBar.items![0]
        tabBarHome.title = "User"
        tabBarHome.image = #imageLiteral(resourceName: "tabBarUserProfile")
        tabBarHome.image = tabBarHome.image?.stretchableImage(withLeftCapWidth: 30, topCapHeight: 30)
        tabBar.tintColor = UIColor(red: 0 / 255, green: 113 / 255, blue: 155 / 255, alpha: 1)
        let tabBarPending = self.tabBar.items![1]
        tabBarPending.title = "Notifications"
        tabBarPending.image = #imageLiteral(resourceName: "tabBarNotification")
        tabBarPending.imageInsets = UIEdgeInsetsMake(0,0,0,0)
        self.tabBar.isTranslucent = false
    }
}
