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

extension PostTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

class PostTableViewController: UITableViewController {
   
    let cellIdentifier = "postCell"
    var filteredPosts = [Post]()
    var searchActive: Bool = false
    var postToPass : Post! = nil
    var post: Post!
    var postArray = [Post]()
    var ref: FIRDatabaseReference!
    var reload: Bool = false
    private var databaseHandle: FIRDatabaseHandle!
    let searchController = UISearchController(searchResultsController: nil)

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func viewDidLoad() {
        FIRDatabase.database().reference().child("TwilioServer").queryOrderedByChild("url").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let data = snapshot.value as! Dictionary<String, String>
            print(data["url"])
        })
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        ref = FIRDatabase.database().reference()
        startObservingDatabase()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PostTableViewController.reloadPosts(_:)),name:"reloadPosts", object: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    
    func reloadPosts(notification: NSNotification) {
        postArray.removeAll()
        reload = true
        tableView.reloadData()
        startObservingDatabase()
    }
    
    
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
            filteredPosts = postArray.filter({dictionary in
                let questionTextTemp : NSString = dictionary.questionText!
                let postedBy : NSString = dictionary.postedBy!
                let questionTitleTemp : NSString = dictionary.questionTitle!
                let subjectTemp : NSString = dictionary.subject!
                let datePostedTemp : NSString = dictionary.datePosted!
                let answeredTemp : NSString = dictionary.answered!
                let range = questionTextTemp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                let range2 = postedBy.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                let range3 = questionTitleTemp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                let range4 = subjectTemp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                let range5 = datePostedTemp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                let range6 = answeredTemp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range.location != NSNotFound || range2.location != NSNotFound || range3.location != NSNotFound || range4.location != NSNotFound || range5.location != NSNotFound || range6.location != NSNotFound
            })
        
        self.tableView.reloadData()
    }

    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if searchController.active && searchController.searchBar.text != "" {
            post = filteredPosts[indexPath.row]
        } else {
            post = postArray[indexPath.row]
        }
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! PostTableViewCell!
        cell.configure((post.questionTitle)!, answered: post.answered!, datePosted: post.datePosted!, postedBy: post.postedBy!, questionImageURL: post.questionImageURL!, questionText: post.questionText!, subject: post.subject!)
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredPosts.count
        }
        if reload {
            return 0
        }
        return postArray.count
    }
    
    func startObservingDatabase () {
        reload = false
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
        if searchController.active && searchController.searchBar.text != "" {
            postToPass = postArray[indexPath.row]
        } else {
            postToPass = postArray[indexPath.row]
        }
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
