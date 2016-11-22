//
//  NewMessageViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/21/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase

class NewMessageViewController : UIViewController {
    var username : String = ""
    var subject : String = ""
    var message : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.layer.cornerRadius = 10
        usernameLabel.text = "To: " + username
        if subject != "" {
            subjectTextField.text = subject
        }
        messageTextView.layer.borderColor = UIColor.blackColor().CGColor
        messageTextView.layer.borderWidth = 1.0
    }
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBAction func sendButtonTouched(sender: AnyObject) {
        subject = subjectTextField.text!
        message = messageTextView.text!
        if subject == "" {
            // No subject was entered
            // create alert and make the user click send again
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
            
        }
    }
    
}
