//
//  UpdateEmailViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/28/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase

class UpdateEmailViewController : UIViewController {
    @IBOutlet weak var newEmailText: UITextField!
    @IBOutlet weak var confirmEmailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func UpdatePressed(sender: AnyObject) {
        if newEmailText.text?.lowercaseString == confirmEmailText.text?.lowercaseString && newEmailText.text != "" && confirmEmailText.text != "" {
            let userToUpdate = FIRDatabase.database().reference().child("users").child(currentUser!.username!)
            FIRAuth.auth()!.currentUser!.updateEmail(newEmailText.text!) { error in
                if error == nil {
                    userToUpdate.updateChildValues(["email": self.newEmailText.text!])
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    let alert = UIAlertController(title: "Unable to Update", message: "Unable to update to this email. It may already be in use.", preferredStyle: .Alert)
                    let cancel = UIAlertAction(title: "Cancel", style: .Default, handler: { Void in })
                    alert.addAction(cancel)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
