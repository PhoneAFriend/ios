//
//  SessionsTableTableViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 12/2/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase

class SessionsTableTableViewController: UITableViewController {
    
    var sessions = [Session]()
    var sessionToPass : Session! = nil
    let cellIdentifier = "sessionCell"
    var reload = false
    override func viewDidLoad() {
        super.viewDidLoad()
        getSessions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let session = sessions[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! SessionsTableViewCell!
        cell.configure(session)
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reload {
            return 0
        } else {
            return sessions.count
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        sessionToPass = sessions[indexPath.row]
        self.performSegueWithIdentifier("SessionsToSession", sender: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SessionsToSession" {
            let nextScene =  segue.destinationViewController as! SessionViewController
            nextScene.session = sessionToPass
        }
    }
    
    @IBAction func refresh(sender: AnyObject) {
        self.reload = true
        self.tableView.reloadData()
        sessions.removeAll()
        getSessions()
        
    }

    func getSessions(){
        self.reload = false
        let ref = FIRDatabase.database().reference().child("Sessions")
        
        ref.queryOrderedByChild("senderName").queryEqualToValue(currentUser!.username!).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
            if snapshot.childrenCount != 0 {
                for sessionSnapshot in snapshot.children{
                    let session = Session(snapshot: sessionSnapshot as! FIRDataSnapshot)
                    self.sessions.append(session)
                }
                ref.queryOrderedByChild("recipientName").queryEqualToValue(currentUser!.username!).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                    if snapshot.childrenCount != 0 {
                        for sessionSnapshot in snapshot.children{
                            let session = Session(snapshot: sessionSnapshot as! FIRDataSnapshot)
                            self.sessions.append(session)
                        }
                        self.tableView.reloadData()
                        
                    } else {
                        self.tableView.reloadData()
                    }
                })
            } else {
                ref.queryOrderedByChild("recipientName").queryEqualToValue(currentUser!.username!).observeSingleEventOfType(.Value, withBlock: {(snapshot) in
                    if snapshot.childrenCount != 0 {
                        for sessionSnapshot in snapshot.children{
                            let session = Session(snapshot: sessionSnapshot as! FIRDataSnapshot)
                            self.sessions.append(session)
                        }
                        self.tableView.reloadData()
                    } else {
                        self.tableView.reloadData()
                    }
                })
            }
        })
    }
}
