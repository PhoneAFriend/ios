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
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.dispContacts = displayContacts
    }
    var dispContacts = [String]()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.dispContacts = displayContacts
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let contact = dispContacts[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! ContactTableViewCell!
        cell.configure(contact)
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dispContacts.count
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let message = UITableViewRowAction(style: .Normal, title: "Message") { action, index in
            self.usernameToPass = self.dispContacts[indexPath.row]
            self.performSegueWithIdentifier("contactToMessage", sender: nil)

        }
        message.backgroundColor = UIColor(netHex: 0x2196f3)
        
        let unfriend = UITableViewRowAction(style: .Normal, title: "Unfriend") { action, index in
            let alert = UIAlertController(title: "Unfriend Contact", message: "Are you sure you want to unfriend this contact?", preferredStyle: .Alert)
            let removeAction = UIAlertAction(title: "Unfriend", style: .Default, handler: { (action: UIAlertAction) in
                self.doUnfriend(self.dispContacts[indexPath.row], index: indexPath.row)
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
        dispContacts.removeAtIndex(index)
        displayContacts.removeAtIndex(index)
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
    
    func insertData(contact:Contact){
        let indexPath = NSIndexPath(forRow: dispContacts.count-1, inSection: 0)
        
        self.tableView.beginUpdates()
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.tableView.endUpdates()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "contactToMessage" {
            let nextScene =  segue.destinationViewController as! NewMessageViewController
            nextScene.username = usernameToPass
        }
    }

}
