//
//  SessionsTableViewCell.swift
//  
//
//  Created by Cody Miller on 12/2/16.
//
//

import UIKit

class SessionsTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    func configure(session: Session){
        if session.recipientName == currentUser!.username! {
            usernameLabel.text = session.senderName
        } else {
            usernameLabel.text = session.recipientName
        }
    }

}
