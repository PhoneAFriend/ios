//
//  ContactTableViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/16/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase
extension ContactTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
class ContactTableViewController : UITableViewController {
    var contactToPass: String! = ""
    let cellIdentifier = "contactCell"
    var usernameToPass : String = ""
    var reload : Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    var filteredContacts = [String]()
    override func viewDidLoad(){
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ContactTableViewController.reloadContacts(_:)),name:"reloadContacts", object: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar

    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredContacts = displayContacts.filter { contact in
            return contact.lowercaseString.containsString(searchText.lowercaseString)
        }
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var contact = ""
        if searchController.active && searchController.searchBar.text != "" {
            contact = filteredContacts[indexPath.row]
        } else {
            contact = displayContacts[indexPath.row]
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! ContactTableViewCell!
        cell.configure(contact)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if searchController.active && searchController.searchBar.text != "" {
            contactToPass = filteredContacts[indexPath.row]
        } else {
            contactToPass = displayContacts[indexPath.row]
        }
        
        let alert = UIAlertController(title: contactToPass, message: "What would you like to do?", preferredStyle: .Alert)
        let message = UIAlertAction(title: "Message", style: .Default, handler: { (action: UIAlertAction) in
            self.usernameToPass = self.contactToPass
            self.performSegueWithIdentifier("contactToMessage", sender: nil)
        })
        let unfriend = UIAlertAction(title: "Unfriend", style: .Default, handler: { (action: UIAlertAction) in
            let unfriendalert = UIAlertController(title: "Unfriend Contact", message: "Are you sure you want to unfriend this contact?", preferredStyle: .Alert)
            let removeAction = UIAlertAction(title: "Unfriend", style: .Default, handler: { (action: UIAlertAction) in
                self.doUnfriend(self.contactToPass, index: indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                
                
            })
            unfriendalert.addAction(removeAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in
            })
            unfriendalert.addAction(cancelAction)
            self.presentViewController(unfriendalert, animated: true, completion: nil)
        })
        let startSession = UIAlertAction(title: "Start Session", style: .Default, handler: { (action: UIAlertAction) in
            //MICHAEL ADD YOUR START SESSION TRANSITIONS HERE
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) in
            
        })
        alert.addAction(message)
        alert.addAction(unfriend)
        alert.addAction(startSession)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredContacts.count
        }
        if reload {
            return 0
        } else {
            return displayContacts.count
        }
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
            let nextScene =  segue.destinationViewController as! NewMessageTableViewController
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
