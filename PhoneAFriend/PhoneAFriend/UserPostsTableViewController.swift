//
//  UserPostsTableViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/26/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase

class UserPostsTableViewController : UITableViewController {
    let cellIdentifier = "userPostCell"
    var postToPass : Post! = nil
    var reload : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let post = userPosts[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! UserPostsTableViewCell!
        cell.configure(post.questionTitle!, subject: post.subject!)
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reload {
            return 0
        } else {
            return userPosts.count
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "UserPostsToUserPost" {
            let nextScene =  segue.destinationViewController as! UserPostViewController
            nextScene.post = postToPass
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        postToPass = userPosts[indexPath.row]
        self.performSegueWithIdentifier("UserPostsToUserPost", sender: nil)
    }
    
    @IBAction func unwindToUserPosts(segue: UIStoryboardSegue){}
    
    func refreshData(){
        userPosts.removeAll()
        tableView.reloadData()
        reload = true
        FIRDatabase.database().reference().child("posts").queryOrderedByChild("postedBy").queryEqualToValue(currentUser!.username!).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            if snapshot.childrenCount != 0 {
                for postSnapshot in snapshot.children {
                    let post = Post(snapshot: postSnapshot as! FIRDataSnapshot)
                    userPosts.append(post)
                }
            }
            self.reload = false
            self.tableView.reloadData()
        })
    }
}
