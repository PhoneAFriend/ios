//
//  InboxTableViewCell.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/22/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit

class InboxTableViewCell: UITableViewCell {
    var message: Message!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    func configure(message: Message){
        subjectLabel.text = message.subject
        usernameLabel.text = message.senderUsername
    }
    
    
    
}
