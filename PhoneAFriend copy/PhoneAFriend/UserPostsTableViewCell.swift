//
//  UserPostsTableViewCell.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/26/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit

class UserPostsTableViewCell : UITableViewCell {
    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var subjectTextField: UILabel!
    @IBOutlet weak var answeredLabel: UILabel!
    func configure(title: String, subject: String, answered: String) {
        titleTextField.text = title
        subjectTextField.text = subject
        if answered == "false" {
            answeredLabel.text = "Unanswered"
            
        } else {
            answeredLabel.text = "Answered"
        }
    }
}
