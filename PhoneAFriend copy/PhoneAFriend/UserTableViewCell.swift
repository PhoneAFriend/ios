//
//  UserTableViewCell.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/9/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import Foundation
import UIKit

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    func configure(username: String){
        usernameLabel.text = username
    }
}