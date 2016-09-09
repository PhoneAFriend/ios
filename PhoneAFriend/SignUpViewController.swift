//
//  SignUpViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 9/8/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class SignUpViewController : UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBAction func createNewUser(sender: AnyObject) {
        if nameField.text! != "" && emailField.text! != "" && passwordField.text! != "" && confirmPasswordField.text! != "" && checkPasswordValidity(passwordField.text!, secondPass: confirmPasswordField.text!)  {
            FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!, completion: {(user, error) in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.errorLabel.text! = "Error creating user. Email already used."
                    })
                }
                else {
                    let user = FIRAuth.auth()?.currentUser
                    if let user = user {
                        let changeRequest = user.profileChangeRequest()
                        changeRequest.displayName = self.nameField.text!
                        changeRequest.commitChangesWithCompletion { error in
                            if error != nil {
                                self.errorLabel.text! = "Unknown error occured"
                            } else {
                                currentUser = CurrentUser(name: user.displayName!, email: user.email!, uid: user.uid)
                                currentUsername = (user.displayName!)

                                dispatch_async(dispatch_get_main_queue(), {
                                    self.performSegueWithIdentifier("SegueToHomePage", sender: self)
                                })
                            }
                        }
                    }
                }
            })
        }
        else {
            errorLabel.text = "Invalid input in one of the registration fields. Please fix and try again."
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func checkPasswordValidity(firstPass : String, secondPass : String) -> Bool{
        if firstPass != secondPass {
            dispatch_async(dispatch_get_main_queue(), {
                self.errorLabel.text! = "Passwords do not match."
            })
            return false
        }
        if firstPass.characters.count < 8 {
            dispatch_async(dispatch_get_main_queue(), {
                self.errorLabel.text! = "Password must be at least eight characters."
            })
            return false
        }
        return true
    }
    
}
