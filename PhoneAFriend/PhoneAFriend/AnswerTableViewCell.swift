//
//  AnswerTableViewCell.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/28/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var upvoteLabel: UILabel!
    @IBOutlet weak var answerText: UILabel!
    func configure(answer: Answer) {
        answerText.text = answer.answerText
        upvoteLabel.text = "Upvotes: " + String(answer.upvotes)
    }
}
