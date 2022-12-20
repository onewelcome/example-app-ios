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
    func setIconForMode(_ iconMode: WelcomeInteractor.IconMode)
}

class WelcomeInteractor: WelcomeInteractorProtocol {
    enum IconMode: String {
        case light = "AppIcon"
        case dark = "AppIconDark"
    }

    func setIconForMode(_ iconMode: IconMode) {
        guard UIApplication.shared.supportsAlternateIcons else { return }
        
        let currentMode = IconMode(rawValue: UIApplication.shared.alternateIconName ?? IconMode.light.rawValue)
        guard iconMode != currentMode else { return }

        UIApplication.shared.setAlternateIconName(iconMode.rawValue) { error in
            if let error = error {
                print("Failed request to update the app’s icon: \(error)")
            }
        }
    }
}
