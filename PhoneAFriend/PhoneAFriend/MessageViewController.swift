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
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var subjectLabel: UITextField!
    @IBOutlet weak var sentFromLabel: UITextField!
    @IBOutlet weak var messageLabel: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
