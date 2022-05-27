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

import Foundation

struct MobileAuthQueue {
    fileprivate var list = [PendingMobileAuthRequestContainter]()
    private let userClient: UserClient
    
    init(userClient: UserClient = sharedUserClient()) {
        self.userClient = userClient
    }
    
    mutating func enqueue(_ mobileAuthRequest: PendingMobileAuthRequestContainter) {
        if list.isEmpty {
            handleMobileAuthRequest(mobileAuthRequest)
        }
        list.append(mobileAuthRequest)
    }

    mutating func dequeue() {
        if !list.isEmpty {
            list.removeFirst()
            if let firstElement = list.first {
                handleMobileAuthRequest(firstElement)
            }
        }
    }

    fileprivate func handleMobileAuthRequest(_ mobileAuthRequest: PendingMobileAuthRequestContainter) {
        if let pendingTransaction = mobileAuthRequest.pendingTransaction {
            userClient.handlePendingMobileAuthRequest(pendingTransaction, delegate: mobileAuthRequest.delegate)
        } else if let otp = mobileAuthRequest.otp {
            userClient.handleOTPMobileAuthRequest(otp: otp, delegate: mobileAuthRequest.delegate)
        }
    }
}
