//
//  PendingMobileAuthTableViewCell.swift
//  OneginiExampleAppSwift
//
//  Created by Stanisław Brzeski on 21/08/2018.
//  Copyright © 2018 Onegini. All rights reserved.
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
        
        if let date = pendingMobileAuthEntity.date {
            timeLabel.text = DateFormatter.localizedString(from: date,
                                                           dateStyle: DateFormatter.Style.none,
                                                           timeStyle: DateFormatter.Style.medium)
            expireTimeLabel.text = pendingMobileAuthEntity.timeToLive
                .flatMap { TimeInterval($0) }
                .flatMap { DateFormatter.localizedString(from: date.addingTimeInterval($0),
                                                         dateStyle: DateFormatter.Style.none,
                                                         timeStyle: DateFormatter.Style.medium)}
                .flatMap { "Expiration time: " + $0 } ?? ""
            
        } else {
            timeLabel.text = ""
            expireTimeLabel.text = ""
        }
    }
}
