//
//  InboxTableViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/22/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase

class InboxTableViewController : UITableViewController {
    
    let cellIdentifier = "messageCell"
    var messageToPass : Message! = nil
    var reload : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func refreshPressed(sender: AnyObject) {
        messages.removeAll()
        reload = true
        tableView.reloadData()
        FIRDatabase.database().reference().child("messages").queryOrderedByChild("recipientUsername").queryEqualToValue(currentUser!.username!).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            if snapshot.childrenCount != 0 {
                for messageSnapshot in snapshot.children {
                    let message = Message(snapshot: messageSnapshot as! FIRDataSnapshot)
                    messages.append(message)
                }
            }
            self.reload = false
            self.tableView.reloadData()
        })
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! InboxTableViewCell!
        cell.configure(message)
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reload {
            return 0
        } else {
            return messages.count
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "InboxToMessage" {
            let nextScene =  segue.destinationViewController as! MessageViewController
            nextScene.message = messageToPass
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        messageToPass = messages[indexPath.row]
        self.performSegueWithIdentifier("InboxToMessage", sender: nil)
    }
    

}
