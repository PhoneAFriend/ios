//
//  ContactTableViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/16/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase

class ContactTableViewController : UITableViewController {
    
    let cellIdentifier = "contactCell"
    var usernameToPass : String = ""
    var reload : Bool = false
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ContactTableViewController.reloadContacts(_:)),name:"reloadContacts", object: nil)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let contact = displayContacts[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! ContactTableViewCell!
        cell.configure(contact)
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reload {
            return 0
        } else {
            return displayContacts.count
        }
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let message = UITableViewRowAction(style: .Normal, title: "Message") { action, index in
            self.usernameToPass = displayContacts[indexPath.row]
            self.performSegueWithIdentifier("contactToMessage", sender: nil)

        }
        message.backgroundColor = UIColor(netHex: 0x2196f3)
        
        let unfriend = UITableViewRowAction(style: .Normal, title: "Unfriend") { action, index in
            let alert = UIAlertController(title: "Unfriend Contact", message: "Are you sure you want to unfriend this contact?", preferredStyle: .Alert)
            let removeAction = UIAlertAction(title: "Unfriend", style: .Default, handler: { (action: UIAlertAction) in
                self.doUnfriend(displayContacts[indexPath.row], index: indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)

                
            })
            alert.addAction(removeAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in
            })
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        unfriend.backgroundColor = UIColor.redColor()
        return [unfriend, message]
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    func doUnfriend(username: String, index: Int) {
        displayContacts.removeAtIndex(index)
        print(displayContacts.count)
        let activeIndex = activeContacts.indexOf({$0.username1 == username})
        if activeIndex != nil {
            let contact = activeContacts[activeIndex!]
            contact.u21 = false
            inactiveContacts.append(contact)
            activeContacts.removeAtIndex(activeIndex!)
            contact.ref.updateChildValues(["u21":false])
        } else {
            let activeIndex2 = activeContacts.indexOf({$0.username2 == username})
            if activeIndex2 != nil {
                let contact = activeContacts[activeIndex2!]
                contact.u12 = false
                inactiveContacts.append(contact)
                activeContacts.removeAtIndex(activeIndex2!)
                contact.ref.updateChildValues(["u12":false])
            } else {
                print("Something weird happened")
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "contactToMessage" {
            let nextScene =  segue.destinationViewController as! NewMessageViewController
            nextScene.username = usernameToPass
        }
    }
    
    @IBAction func unwindToContacts(segue: UIStoryboardSegue){}
    
    func initialLoad() {
       
        fetchUsername1Contacts(currentUser!.username!, completion: { (boolValue) -> Void in
            self.fetchUsername2Contacts(currentUser!.username!, completion: { (boolValue) -> Void in
                self.reload = false
                self.tableView.reloadData()
            })
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
    
    func reloadContacts(notification: NSNotification) {
        reload = true
        tableView.reloadData()
        /*displayContacts.removeAll()
        activeContacts.removeAll()
        inactiveContacts.removeAll()
        initialLoad()*/
        reload = false
        tableView.reloadData()
        print(displayContacts.count)
    }

}
