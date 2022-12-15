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

protocol WelcomeInteractorProtocol: AnyObject {
    func handleInterfaceStyleChange(_ interfaceStyle: UIUserInterfaceStyle)
}

class WelcomeInteractor: WelcomeInteractorProtocol {
    func handleInterfaceStyleChange(_ interfaceStyle: UIUserInterfaceStyle) {
        AppIconSwitcher()?.setIconForMode(interfaceStyle.appIconName)
    }
}

private extension UIUserInterfaceStyle {
    var appIconName: AppIconSwitcher.IconMode {
        switch self {
        case .dark: return .dark
        default:
            return .light
        }
    }
}
