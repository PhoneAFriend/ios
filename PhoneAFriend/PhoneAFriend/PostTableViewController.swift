//
//  PostTableViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 10/31/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class PostTableViewController: UITableViewController {
   
    let cellIdentifier = "postCell"
    var postToPass : Post! = nil
    var post: Post!
    var postArray = [Post]()
    var ref: FIRDatabaseReference!
    var reload: Bool = false
    private var databaseHandle: FIRDatabaseHandle!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        startObservingDatabase()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PostTableViewController.reloadPosts(_:)),name:"reloadPosts", object: nil)
        
    }
    
    func reloadPosts(notification: NSNotification) {
        postArray.removeAll()
        reload = true
        tableView.reloadData()
        startObservingDatabase()
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
        let post = postArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! PostTableViewCell!
        print(post.questionTitle!, terminator: "")
        cell.configure((post.questionTitle)!, answered: post.answered!, datePosted: post.datePosted!, postedBy: post.postedBy!, questionImageURL: post.questionImageURL!, questionText: post.questionText!, subject: post.subject!)
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reload {
            return 0
        } else {
            return postArray.count
        }
    }
    
    func startObservingDatabase () {
        ref.child("posts").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            var newPosts = [Post]()
            
            for postSnapShot in snapshot.children {
                let post = Post(snapshot: postSnapShot as! FIRDataSnapshot)
                
                newPosts.append(post)
            }
            newPosts = newPosts.reverse()
            self.postArray = newPosts
            self.tableView.reloadData()
        })
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PostsToPost" {
            let nextScene =  segue.destinationViewController as! PostViewController
            nextScene.post = postToPass
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        postToPass = postArray[indexPath.row]
        self.performSegueWithIdentifier("PostsToPost", sender: nil)
    }

    func refreshData(){
        postArray.removeAll()
        tableView.reloadData()
        reload = true
        FIRDatabase.database().reference().child("posts").observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            if snapshot.childrenCount != 0 {
                for postSnapshot in snapshot.children {
                    let post = Post(snapshot: postSnapshot as! FIRDataSnapshot)
                    self.postArray.append(post)
                }
            }
            self.reload = false
            self.tableView.reloadData()
        })
    }

}
