//
//  MessagesTableViewCell.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 12/3/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    func configure(username: String) {
        usernameLabel.text = username
    }

}
