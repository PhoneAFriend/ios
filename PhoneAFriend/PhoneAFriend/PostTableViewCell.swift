//
//  PostTableViewCell.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 10/31/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    var answeredBool: String = ""
    var questionImageURL_Var: String = ""
    var datePostedOn: String = ""
    var questionText_Var: String = ""
    @IBOutlet weak var answeredLabel: UILabel!
    @IBOutlet weak var postedByHolder: UILabel!
    @IBOutlet weak var questionTitleHolder: UILabel!
    func configure(questionTitle : String, answered: String, datePosted: String, postedBy: String, questionImageURL: String, questionText: String, subject: String) {
        postedByHolder.text = "Posted to " + subject + " by " + postedBy
        answeredBool = answered
        questionImageURL_Var = questionImageURL
        datePostedOn = datePosted
        questionText_Var = questionText
        questionTitleHolder.text = questionTitle
        if answered == "false" {
            answeredLabel.text = "Unanswered"
        } else {
            answeredLabel.text = "Answered"
        }
        preservesSuperviewLayoutMargins = false
        separatorInset = UIEdgeInsetsZero
        layoutMargins = UIEdgeInsetsZero
    }
}
