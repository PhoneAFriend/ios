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
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func createNewUser(sender: AnyObject) {
        clearData()
        if nameField.text! != "" && emailField.text! != "" && passwordField.text! != "" && confirmPasswordField.text! != "" && checkPasswordValidity(passwordField.text!, secondPass: confirmPasswordField.text!)  {
            let ref = FIRDatabase.database().reference()
            print(ref)
            print("Sign in clicked", terminator: "")
            ref.child("users")
                .queryOrderedByChild("username")
                .queryEqualToValue(nameField.text!)
                .observeSingleEventOfType(.Value, withBlock: { snapshot in
                    if !snapshot.exists(){
                        print("Made it to unique username")
                        //do stuff with unique username
                        FIRAuth.auth()?.createUserWithEmail(self.emailField.text!, password: self.passwordField.text!, completion: {(user, error) in
                            if error != nil {
                                print(error)
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.errorLabel.text! = "Error creating user. Email already used."
                                })
                            }
                            else {
                                print("Made it to user save")
                                let uid = user!.uid
                                let username = self.nameField.text!
                                let useremail = user!.email
                                self.saveUserToDB(username, id: uid, useremail: useremail!)
                                currentUser?.username = username
                                currentUser?.useremail = user!.email
                                currentUser?.id = user!.uid
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.performSegueWithIdentifier("SegueToHomePage", sender: self)
                                })
                            }
                        })
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.errorLabel.text! = "Username already taken. Try again!"
                        })
                    }
                    }) { error in
                    }
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad();

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
    
    func saveUserToDB(username: String, id: String, useremail: String) {
        let ref = FIRDatabase.database().reference()
        
        let key = ref.child("users").childByAutoId().key
        
        let user = ["id": id,
                    "username": username,
                    "useremail": useremail]
        
        let childUpdates = ["/users/\(key)": user]
        ref.updateChildValues(childUpdates)
    }
    func clearData(){
        currentUser = nil
        posts.removeAll()
        activeContacts.removeAll()
        inactiveContacts.removeAll()
        displayContacts.removeAll()
        messages.removeAll()
        userPosts.removeAll()
    }
    
}
