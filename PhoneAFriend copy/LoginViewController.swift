//
//  LoginViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 9/8/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func signInPressed(sender: AnyObject) {
        clearData()
        if emailField.text! != "" && passwordField != "" {
            FIRAuth.auth()?.signInWithEmail(emailField.text!, password: passwordField.text!, completion: {(user, error) in
                if error != nil {
                    print(error)
                    
                    self.errorLabel.text = "Error. Incorrect Email/Password combination."
                }
                else {
                    self.getCurrentUsername(self.emailField.text!.lowercaseString) { (boolValue) ->() in
                        if boolValue {
                            self.fetchUsername1Contacts((currentUser!.username)!) { (boolValue) -> () in
                                if boolValue {
                                    self.fetchUsername2Contacts(currentUser!.username!) { (boolValue) -> () in
                                        if boolValue {
                                            self.fetchUserMessages(currentUser!.username!) { (boolValue) -> () in
                                                if boolValue {
                                                    TwilioClient.configure()
                                                    dispatch_async(dispatch_get_main_queue(), {
                                                        self.performSegueWithIdentifier("SegueFromLoginToHomePage", sender: self)
                                                    })
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            })
        }
    }

    func getCurrentUsername(email: String, completion: (result: Bool)->()){
        FIRDatabase.database().reference().child("users").queryOrderedByChild("useremail").queryEqualToValue(email).observeEventType(.Value, withBlock: { (snapshot) -> Void in
            if (snapshot.value != nil) {
                for userSnapshot in snapshot.children {
                    currentUser = User(snapshot: userSnapshot as! FIRDataSnapshot)
                }
                completion(result: true)
            }
            else {
                print("No user with that email found")
                completion(result: false)
            }
        })
    }
    
    func fetchUsername1Contacts(username: String, completion: (result: Bool)->()) {
        FIRDatabase.database().reference().child("Contacts").queryOrderedByChild("username1").queryEqualToValue(username).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            if (snapshot.childrenCount != 0) {
                for contactSnapshot in snapshot.children {
                    let contact = Contact(snapshot: contactSnapshot as! FIRDataSnapshot)
                    if contact.u12 == true{
                        activeContacts.append(contact)
                        displayContacts.append(contact.username2)
                    } else {
                        inactiveContacts.append(contact)
                    }
                }
                completion(result: true)
            } else {
                completion(result: true)
            }
        })
    }
    
    func fetchUsername2Contacts(username: String, completion: (result: Bool)->()) {
        FIRDatabase.database().reference().child("Contacts").queryOrderedByChild("username2").queryEqualToValue(username).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            if (snapshot.childrenCount != 0) {
                
                for contactSnapshot in snapshot.children {
                    let contact = Contact(snapshot: contactSnapshot as! FIRDataSnapshot)
                    if contact.u21 == true{
                        activeContacts.append(contact)
                        displayContacts.append(contact.username1)
                    } else {
                        inactiveContacts.append(contact)
                    }
                   
                }
                completion(result: true)
            } else {
                completion(result: true)
            }
        })
    }
    
    func fetchUserMessages(username: String, completion: (result: Bool) -> () ) {
        FIRDatabase.database().reference().child("messages").queryOrderedByChild("recipientUsername").queryEqualToValue(username).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            if snapshot.childrenCount != 0 {
                for messageSnapshot in snapshot.children {
                    let message = Message(snapshot: messageSnapshot as! FIRDataSnapshot)
                    messages.insert(message, atIndex: messages.startIndex)
                }
                
            }
            completion(result: true)
        })
    }
    
    func fetchUserPosts(username: String, completion: (result: Bool) -> ()) {
        FIRDatabase.database().reference().child("posts").queryOrderedByChild("postedBy").queryEqualToValue(username).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            if snapshot.childrenCount != 0 {
                for postSnapshot in snapshot.children {
                    let post = Post(snapshot: postSnapshot as! FIRDataSnapshot)
                    userPosts.insert(post, atIndex: userPosts.startIndex)
                }
            }
            completion(result: true)
        })
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
