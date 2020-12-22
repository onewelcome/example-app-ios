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
import UserNotifications
import WidgetKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var navigationController = AppAssembly.shared.resolver.resolve(UINavigationController.self)
    var appRouter = AppAssembly.shared.resolver.resolve(AppRouterProtocol.self)
    weak var pushMobileAuthEnrollment: PushMobileAuthEntrollmentProtocol?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        oneginiSDKStartup()
        return true
    }

    func oneginiSDKStartup() {
        guard let appRouter = appRouter else { fatalError() }
        appRouter.setupStartupPresenter()
    }

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        pushMobileAuthEnrollment?.enrollForPushMobileAuth(deviceToken: deviceToken)
    }

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError _: Error) {
        let mappedError = AppError(title: "Push mobile auth enrollment error", errorDescription: "Something went wrong.")
        pushMobileAuthEnrollment?.enrollForPushMobileAuthFailed(mappedError)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
