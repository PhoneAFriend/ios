//
//  LoginViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 9/8/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func signInPressed(sender: AnyObject) {
        if emailField.text! != "" && passwordField != "" {
            FIRAuth.auth()?.signInWithEmail(emailField.text!, password: passwordField.text!, completion: {(user, error) in
                if error != nil {
                    self.errorLabel.text = "Error. Incorrect Email/Password combination."
                }
                else {
                    currentUser = CurrentUser(name: (user?.displayName)!, email: user!.email!, uid: user!.uid)
                    currentUsername = (user?.displayName!)!
                    dispatch_async(dispatch_get_main_queue(), {
                        self.performSegueWithIdentifier("SegueFromLoginToHomePage", sender: self)
                    })
                }
            })
        }
    }
    
}
