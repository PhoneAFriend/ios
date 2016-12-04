//
//  UserTableViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/9/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import Firebase
import FirebaseDatabase
import UIKit

class UserTableViewController : UITableViewController {
    let cellIdentifier = "userCell"
    var users = [User]()
    var usernameToPass: String = ""
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! UserTableViewCell!
        cell.configure(user.username!)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let alert = UIAlertController(title: users[indexPath.row].username, message: "What would you like to do?", preferredStyle: .Alert)
        let add = UIAlertAction(title: "Add as Contact", style: .Default, handler: { (action: UIAlertAction) in
            self.addUser(self.users[indexPath.row].username!)
        })
        let message = UIAlertAction(title: "Message", style: .Default, handler: { (action: UIAlertAction) in
            self.usernameToPass = self.users[indexPath.row].username!
            self.performSegueWithIdentifier("UsersToMessage", sender: nil)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) in
            
        })
        alert.addAction(add)
        alert.addAction(message)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func addUser(username: String){
        if currentUser?.username == username {
            let alert = UIAlertController(title: "Adding Yourself", message: "You can't add yourself as a contact", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in
            })
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        } else if displayContacts.contains(username) {
            let alreadyContactAlert = UIAlertController(title: "Already a Contact", message: "This user is already in your contact list", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in
            })
            alreadyContactAlert.addAction(cancelAction)
            self.presentViewController(alreadyContactAlert, animated: true, completion: nil)
        } else {
            let userFound1 = inactiveContacts.indexOf({$0.username2 == username})
            if userFound1 != nil {
                inactiveContacts[userFound1!].u12 = true
                let contact = inactiveContacts[userFound1!]
                let username = contact.username2
                displayContacts.append(username)
                activeContacts.append(contact)
                inactiveContacts.removeAtIndex(userFound1!)
                contact.ref.updateChildValues(["u12":true])
                NSNotificationCenter.defaultCenter().postNotificationName("reloadContacts", object: nil)
            } else {
                let userFound2 = inactiveContacts.indexOf({$0.username1 == username})
                if userFound2 != nil {
                    inactiveContacts[userFound2!].u21 = true
                    let contact = inactiveContacts[userFound2!]
                    let username = contact.username1
                    displayContacts.append(username)
                    activeContacts.append(contact)
                    inactiveContacts.removeAtIndex(userFound2!)
                    contact.ref.updateChildValues(["u21":true])
                    NSNotificationCenter.defaultCenter().postNotificationName("reloadContacts", object: nil)
                } else {
                    /*FIRDatabase.database().reference().child("Contacts").queryOrderedByChild("username1").queryEqualToValue(username).queryOrderedByChild("username2").queryEqualToValue(currentUser?.username).observeEventType(.Value, withBlock: { (snapshot) -> Void in
                        if snapshot.childrenCount != 0 {
                            let contact = Contact(snapshot: snapshot)
                            contact.u21 = true
                            activeContacts.append(contact)
                            displayContacts.append(username)
                            ContactTableViewController().dispContacts.append(username)
                            contact.ref.updateChildValues(["u21":true])
                            ContactTableViewController().insertData(contact)

                        } else {
                            let contact = Contact(u12: true, u21: false, username1: currentUser!.username!, username2: username)
                            activeContacts.append(contact)
                            displayContacts.append(username)
                            ContactTableViewController().dispContacts.append(username)
                            let key = FIRDatabase.database().reference().child("Contacts").childByAutoId().key
                            let newPost = ["u12" : true,
                                "u21" : false,
                                "username1" : currentUser!.username!,
                                "username2" : username,
                            ]
                            let childUpdates = ["/Contacts/\(key)": newPost]
                            FIRDatabase.database().reference().updateChildValues(childUpdates)
                            ContactTableViewController().insertData(contact)

                        }
                        
                    })*/
                    let contact = Contact(u12: true, u21: false, username1: currentUser!.username!, username2: username)
                    activeContacts.append(contact)
                    displayContacts.append(username)
                    let key = FIRDatabase.database().reference().child("Contacts").childByAutoId().key
                    let newPost = ["u12" : true,
                                   "u21" : false,
                                   "username1" : currentUser!.username!,
                                   "username2" : username,
                    ]
                    let childUpdates = ["/Contacts/\(key)": newPost]
                    FIRDatabase.database().reference().updateChildValues(childUpdates)
                    NSNotificationCenter.defaultCenter().postNotificationName("reloadContacts", object: nil)
                }
            }
            
            
            
            
        }
        let added = UIAlertController(title: "Added!", message: "User was successfully added to your contact list.", preferredStyle: .ActionSheet)
        let dismiss = UIAlertAction(title: "Dismiss", style: .Cancel, handler: { (action: UIAlertAction) in
        })
        added.addAction(dismiss)
        self.presentViewController(added, animated: true, completion: nil)

        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "UsersToMessage" {
            let nextScene =  segue.destinationViewController as! NewMessageTableViewController
            nextScene.username = usernameToPass
        }
    }
    
    @IBAction func unwindToUserLookup(segue: UIStoryboardSegue) {}
}
