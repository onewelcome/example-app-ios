//
//  PendingMobileAuthTableViewCell.swift
//  OneginiExampleAppSwift
//
//  Created by Stanisław Brzeski on 21/08/2018.
//  Copyright © 2018 Onegini. All rights reserved.
//

import UIKit

class PendingMobileAuthTableViewCell: UITableViewCell {
    @IBOutlet var container: UIView!
    @IBOutlet var profileLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var expireTimeLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!

    func setup(pendingMobileAuthEntity: PendingMobileAuthRequest) {
        profileLabel.text = pendingMobileAuthEntity.userProfile.profileId
        messageLabel.text = pendingMobileAuthEntity.message

        if let date = pendingMobileAuthEntity.date {
            timeLabel.text = DateFormatter.localizedString(from: date, dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.medium)
            if let timeToLive = pendingMobileAuthEntity.timeToLive {
                expireTimeLabel.text = "Expiration time: " + DateFormatter.localizedString(from: date.addingTimeInterval(timeToLive.doubleValue), dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.medium)
            } else {
                expireTimeLabel.text = ""
            }
        } else {
            timeLabel.text = ""
            expireTimeLabel.text = ""
        }
    }
}
