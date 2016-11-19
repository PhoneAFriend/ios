//
//  UserLookupViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 10/30/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase
class UserLookupController: UIViewController {
    
    var users = [User]()
    
    
    @IBOutlet weak var lookupButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    let cellIdentifier = "usernameCell"
    @IBAction func lookupButtonPressed(sender: AnyObject) {
        let searchTerm = searchTextField.text!
        if searchTerm.characters.count == 0{
            dispatch_async(dispatch_get_main_queue(), {
                self.errorLabel.text = "Error, no username or email was inputted"
            })
        } else {
            let ref = FIRDatabase.database().reference()
            print(searchTerm+"\\uf8ff")
            ref.child("users").queryOrderedByChild("username").queryStartingAtValue(searchTerm).queryEndingAtValue(searchTerm+"\u{f8ff}").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                if value != nil {
                    self.convertSnapshot(snapshot, completionHandler: { (success) -> Void in
                        
                        if success {
                            self.performSegueWithIdentifier("userFoundSegue", sender: nil)
                        }
                    })
                    
                    
                    
                } else {
                    self.errorLabel.text = "Error, no username found"
                }
                
            }) { (error) in
                print(error.localizedDescription)
        }
    }
    }

    func convertSnapshot(snapshot: FIRDataSnapshot,completionHandler: CompletionHandler) {
        var foundUsers = [User]()
    
        for userSnapShot in snapshot.children {
            let user = User(snapshot: userSnapShot as! FIRDataSnapshot)
            print(user.useremail)
            foundUsers.append(user)
        }
        self.users = foundUsers
        completionHandler(success: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lookupButton.layer.cornerRadius = 5
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "userFoundSegue" {
            let nextScene =  segue.destinationViewController as! UserTableViewController
            nextScene.users = users
        }
    }
   
    
}
