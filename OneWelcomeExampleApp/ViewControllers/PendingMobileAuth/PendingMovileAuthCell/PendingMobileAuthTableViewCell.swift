//
//  PendingMobileAuthTableViewCell.swift
//  OneginiExampleAppSwift
//
//  Created by Stanisław Brzeski on 21/08/2018.
//  Copyright © 2022 OneWelcome. All rights reserved.
//

import UIKit
import OneginiSDKiOS

class PendingMobileAuthTableViewCell: UITableViewCell {
    @IBOutlet var container: UIView!
    @IBOutlet var profileLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var expireTimeLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!

    func setup(pendingMobileAuthEntity: PendingMobileAuthRequest) {
        profileLabel.text = pendingMobileAuthEntity.userProfile.profileId
        messageLabel.text = pendingMobileAuthEntity.message
        
        guard let date = pendingMobileAuthEntity.date else {

            timeLabel.text = ""
            expireTimeLabel.text = ""
            return
        }
        
        timeLabel.text = DateFormatter.localizedString(from: date,
                                                       dateStyle: DateFormatter.Style.none,
                                                       timeStyle: DateFormatter.Style.medium)
        
        let expireTime = date.addingTimeInterval(TimeInterval(pendingMobileAuthEntity.timeToLive))
        expireTimeLabel.text = "Expiration time: " + DateFormatter.localizedString(from: expireTime,
                                                                                   dateStyle: DateFormatter.Style.none,
                                                                                   timeStyle: DateFormatter.Style.medium)

    }
}
