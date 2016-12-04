//
//  ContactTableViewCell.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/16/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    func configure(username: String){
        usernameLabel.text = username
    }
    
}
