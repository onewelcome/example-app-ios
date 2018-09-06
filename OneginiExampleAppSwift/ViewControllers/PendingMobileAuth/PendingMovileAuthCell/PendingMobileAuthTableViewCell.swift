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

    func setup(pendingMobileAuthEntity: ONGPendingMobileAuthRequest) {
        profileLabel.text = pendingMobileAuthEntity.userProfile.profileId
        messageLabel.text = pendingMobileAuthEntity.message
        guard let date = pendingMobileAuthEntity.date else {
            timeLabel.text = ""
            expireTimeLabel.text = ""
            return
        }
        timeLabel.text = DateFormatter.localizedString(from: date, dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.medium)
        guard let timeToLive = pendingMobileAuthEntity.timeToLive else {
            expireTimeLabel.text = ""
            return
        }
        expireTimeLabel.text = "Expiration time: " + DateFormatter.localizedString(from: date.addingTimeInterval(timeToLive.doubleValue), dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.medium)
    }
}
