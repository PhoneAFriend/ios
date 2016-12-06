//
//  InboxTableViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/22/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase
extension InboxTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
class InboxTableViewController : UITableViewController {
    
    let cellIdentifier = "messageCell"
    var messageToPass : Message! = nil
    var reload : Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    var filterMessages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserMessages(currentUser!.username!)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filterMessages = messages.filter { message in
            return message.message.lowercaseString.containsString(searchText.lowercaseString) || message.senderUsername.lowercaseString.containsString(searchText.lowercaseString) || message.subject.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    @IBAction func refreshPressed(sender: AnyObject) {
       /* messages.removeAll()
        reload = true
        tableView.reloadData()
        FIRDatabase.database().reference().child("messages").queryOrderedByChild("recipientUsername").queryEqualToValue(currentUser!.username!).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            if snapshot.childrenCount != 0 {
                for messageSnapshot in snapshot.children {
                    let message = Message(snapshot: messageSnapshot as! FIRDataSnapshot)
                    messages.append(message)
                }
            }
            messages = messages.reverse()
            self.reload = false
            self.tableView.reloadData()
        })
        */
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var message : Message
        
        if searchController.active && searchController.searchBar.text != "" {
            message = filterMessages[indexPath.row]
        } else {
            message = messages[indexPath.row]
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! InboxTableViewCell!
        cell.configure(message)
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filterMessages.count
        }
        if reload {
            return 0
        } else {
            return messages.count
        }
    }
    
    func fetchUserMessages(username: String) {
        FIRDatabase.database().reference().child("messages").queryOrderedByChild("recipientUsername").queryEqualToValue(username).observeEventType(.Value, withBlock: { (snapshot) -> Void in
            var newMessages = [Message]()
            if snapshot.childrenCount != 0{
                for messageSnapShot in snapshot.children {
                    let post = Message(snapshot: messageSnapShot as! FIRDataSnapshot)
                    
                    newMessages.append(post)
                }
                newMessages = newMessages.reverse()
                messages = newMessages
                self.tableView.reloadData()
            }
            
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "InboxToMessage" {
            let nextScene =  segue.destinationViewController as! MessageViewController
            nextScene.message = messageToPass
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if searchController.active && searchController.searchBar.text != "" {
            messageToPass = filterMessages[indexPath.row]
        } else {
            messageToPass = messages[indexPath.row]
        }
        self.performSegueWithIdentifier("InboxToMessage", sender: nil)
    }
    
    @IBAction func unwindToMessages(segue: UIStoryboardSegue) {}
    

}
