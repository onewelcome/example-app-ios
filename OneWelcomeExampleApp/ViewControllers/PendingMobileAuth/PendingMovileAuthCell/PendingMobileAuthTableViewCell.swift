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
        profileLabel.text = pendingMobileAuthEntity.userProfile?.profileId
        messageLabel.text = pendingMobileAuthEntity.message
        
        if let date = pendingMobileAuthEntity.date {
            timeLabel.text = DateFormatter.localizedString(from: date,
                                                           dateStyle: DateFormatter.Style.none,
                                                           timeStyle: DateFormatter.Style.medium)
            let formattedTimeToLive = DateFormatter.localizedString(from: date.addingTimeInterval(pendingMobileAuthEntity.timeToLive),
                                                         dateStyle: DateFormatter.Style.none,
                                                         timeStyle: DateFormatter.Style.medium)
            expireTimeLabel.text = "Expiration time: "+formattedTimeToLive
            
        } else {
            timeLabel.text = ""
            expireTimeLabel.text = ""
        }
    }
}
