//
//  MessageViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/22/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase

class MessageViewController: UITableViewController {
    
    var message : Message! = nil
    var usernameToPass : String = ""
    var subjectToPass: String = ""
    var postKeyToPass: String = ""
    
    @IBOutlet weak var subjectLabel: UITextView!
    
    @IBOutlet weak var sentFromLabel: UITextView!
    @IBOutlet weak var messageLabel: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sentFromLabel.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 0)
        subjectLabel.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 0)
        messageLabel.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 0)

        if message != nil {
            subjectLabel.text = message.subject
            sentFromLabel.text = message.senderUsername
            messageLabel.text = message.message
        }
        self.automaticallyAdjustsScrollViewInsets = false
    }

    @IBAction func replyPressed(sender: AnyObject) {
        usernameToPass = message.senderUsername
        subjectToPass = message.subject
        postKeyToPass = message.postKey
        self.performSegueWithIdentifier("MessageToReply", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MessageToReply" {
            let nextScene =  segue.destinationViewController as! NewMessageTableViewController
            nextScene.username = usernameToPass
            nextScene.subject = subjectToPass
            nextScene.postKey = postKeyToPass
        }
    }
}
