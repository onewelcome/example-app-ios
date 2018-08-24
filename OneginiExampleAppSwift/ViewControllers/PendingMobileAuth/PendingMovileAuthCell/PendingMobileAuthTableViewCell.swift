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
        container.layer.cornerRadius = 5;
        container.layer.masksToBounds = true;
        self.backgroundColor = UIColor.clear
        
        profileLabel.text = mobileAuthEntity.pendingMobileAuthRequest.userProfile.profileId
        messageLabel.text = mobileAuthEntity.pendingMobileAuthRequest.message
        timeLabel.text = DateFormatter.localizedString(from: mobileAuthEntity.pendingMobileAuthRequest.date!, dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.medium)
        expireTimeLabel.text = "Expiration time: " + DateFormatter.localizedString(from: mobileAuthEntity.pendingMobileAuthRequest.date!.addingTimeInterval((mobileAuthEntity.pendingMobileAuthRequest.timeToLive?.doubleValue)!), dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.medium)
    }
    
    func setup() {
        container.layer.cornerRadius = 5;
        container.layer.masksToBounds = true;
        self.backgroundColor = UIColor.clear
        profileLabel.text = ""
        messageLabel.text = "Pull to refresh"
        timeLabel.text = ""
        expireTimeLabel.text = ""
    }
}
