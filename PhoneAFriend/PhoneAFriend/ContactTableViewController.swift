//
//  ContactTableViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/16/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit

class ContactTableViewController : UITableViewController {
    
    let cellIdentifier = "contactCell"
    
    override func viewDidLoad(){
        super.viewDidLoad()
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
        return displayContacts.count
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let message = UITableViewRowAction(style: .Normal, title: "Message") { action, index in
            
        }
        message.backgroundColor = UIColor(netHex: 0x2196f3)
        let unfriend = UITableViewRowAction(style: .Normal, title: "Unfriend") { action, index in
            self.doUnfriend(displayContacts[indexPath.row], index: indexPath.row)
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
        let activeIndex = activeContacts.indexOf({$0.username1 == username})
        if activeIndex != nil {
            
        } else {
            let activeIndex2 = activeContacts.indexOf({$0.username2 == username})
            if activeIndex2 != nil {
                
            } else {
                print("Something weird happened")
            }
        }
    }
}
