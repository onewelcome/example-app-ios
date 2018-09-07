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

@testable import OneginiExampleAppSwift
import UIKit

class LoginInteractorMock: LoginInteractorProtocol {
    func userProfiles() -> Array<NSObject & UserProfileProtocol> {
        return [UserProfileStub("profile1")]
    }

    func authenticators(profile _: NSObject & UserProfileProtocol) -> [NSObject & AuthenticatorProtocol] {
        return [AuthenticatorStub(identifier: "authenticator1", name: "authenticator1", type: ONGAuthenticatorType.PIN, isRegistered: true, isPreferred: true)]
    }

    var loginCalled = false
    func login(profile _: NSObject & UserProfileProtocol) {
        loginCalled = true
    }

    var handleLoginCalled = false
    func handleLogin(loginEntity _: PinViewControllerEntityProtocol) {
        handleLoginCalled = true
    }
}
