//
//  PendingMobileAuthTableViewCell.swift
//  OneginiExampleAppSwift
//
//  Created by Stanisław Brzeski on 21/08/2018.
//  Copyright © 2018 Onegini. All rights reserved.
//

import UIKit

class PendingMobileAuthTableViewCell: UITableViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var expireTimeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func setup(mobileAuthEntity: MobileAuthEntity) {
        profileLabel.text = mobileAuthEntity.pendingMobileAuthRequest.userProfile.profileId
        messageLabel.text = mobileAuthEntity.pendingMobileAuthRequest.message
        guard let date = mobileAuthEntity.pendingMobileAuthRequest.date else {
            timeLabel.text = ""
            expireTimeLabel.text = ""
            return
        }
        timeLabel.text = DateFormatter.localizedString(from: date, dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.medium)
        guard let timeToLive = mobileAuthEntity.pendingMobileAuthRequest.timeToLive else {
            expireTimeLabel.text = ""
            return
        }
        expireTimeLabel.text = "Expiration time: " + DateFormatter.localizedString(from: date.addingTimeInterval(timeToLive.doubleValue), dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.medium)
    }
}
