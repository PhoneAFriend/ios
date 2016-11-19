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
    var imageUrlToPass: String!
    var post: Post!
    var postArray = [Post]()
    var ref: FIRDatabaseReference!
    private var databaseHandle: FIRDatabaseHandle!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = FIRDatabase.database().reference()
        startObservingDatabase()

        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
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
        print(post.questionTitle!)
        cell.configure((post.questionTitle)!, answered: post.answered!, datePosted: post.datePosted!, postedBy: post.postedBy!, questionImageURL: post.questionImageURL!, questionText: post.questionText!, subject: post.subject!)
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func startObservingDatabase () {
        databaseHandle = ref.child("posts").observeEventType(.Value, withBlock: { (snapshot) in
            var newPosts = [Post]()
            
            for postSnapShot in snapshot.children {
                let post = Post(snapshot: postSnapShot as! FIRDataSnapshot)
                
                newPosts.append(post)
            }
            
            self.postArray = newPosts
            self.tableView.reloadData()
        })
        
    }


}
