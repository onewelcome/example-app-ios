//  Copyright © 2023 OneWelcome. All rights reserved.

import Foundation

enum AllowedIdentityProviders: String {
    case qrCode = "qr_registration"
    case stateless = "stateless-test"
    case twoWayStateless = "stateless"
    case twoStep = "New2step"
}
