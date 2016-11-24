//
//  MessageViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/22/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase

class MessageViewController: UIViewController {
    
    var message : Message! = nil
    var usernameToPass : String = ""
    var subjectToPass: String = ""
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var sentFromLabel: UILabel!
    @IBOutlet weak var messageLabel: UITextView!
    @IBOutlet weak var replyButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replyButton.layer.cornerRadius = 10
        if message != nil {
            subjectLabel.text = message.subject
            sentFromLabel.text = message.senderUsername
            messageLabel.text = message.message
        }
        
    }
    @IBAction func replyPressed(sender: AnyObject) {
        usernameToPass = message.senderUsername
        subjectToPass = message.subject
        self.performSegueWithIdentifier("MessageToReply", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MessageToReply" {
            let nextScene =  segue.destinationViewController as! NewMessageViewController
            nextScene.username = usernameToPass
            nextScene.subject = subjectToPass
        }
    }
}
