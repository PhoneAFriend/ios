//
//  NewMessageTableViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 12/3/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase

class NewMessageTableViewController: UITableViewController {
    //
    //  NewMessageViewController.swift
    //  PhoneAFriend
    //
    //  Created by Cody Miller on 11/21/16.
    //  Copyright © 2016 seniorDesign. All rights reserved.
    
    @IBOutlet weak var usernameText: UITextView!
    
    @IBOutlet weak var subjectTextField: UITextView!
    @IBOutlet weak var messageTextView: UITextView!
    
        var username : String = ""
        var subject : String = ""
        var message : String = ""
        var postKey : String = ""
        
        override func viewDidLoad() {
            super.viewDidLoad()
            usernameText.text = username
            if subject != "" {
                subjectTextField.text = subject
            }
            usernameText.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 0)
            subjectTextField.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 0)
            messageTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 0)
        }
        
    @IBAction func sendTouched(sender: AnyObject) {
        
        subject = subjectTextField.text!
        message = messageTextView.text!
        if subject == "" {
            let alert =  UIAlertController(title: "Invalid Submission", message: "You need to input a subject before you can send the message.", preferredStyle: .Alert)
            let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) in
            })
            alert.addAction(cancelButton)
            self.presentViewController(alert, animated: true, completion: nil)
        } else if message == "" {
            // No message was entered
            //create alert and make the user click send again
            let alert =  UIAlertController(title: "Invalid Submission", message: "You need to input a message before you can send the message.", preferredStyle: .Alert)
            let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) in
            })
            alert.addAction(cancelButton)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            // Good to go. Send the message
            
            let messageToSend = Message(senderUsername: currentUser!.username!, recipientUsername: username, subject: subject, message: message, unread: true, postKey: postKey)
            sendMessage(messageToSend)
        }
        self.navigationController?.popViewControllerAnimated(true)
        
    }
        func sendMessage(messageToSend: Message) {
            let key = FIRDatabase.database().reference().child("messages").childByAutoId().key
            let newMessage = ["recipientUsername": messageToSend.recipientUsername,
                              "senderUsername": messageToSend.senderUsername,
                              "subject": messageToSend.subject,
                              "message": messageToSend.message,
                              "unread": true,
                              "postKey": messageToSend.postKey
            ]
            let childUpdates = ["/messages/\(key)": newMessage]
            FIRDatabase.database().reference().updateChildValues(childUpdates)
        }
        
    

}
