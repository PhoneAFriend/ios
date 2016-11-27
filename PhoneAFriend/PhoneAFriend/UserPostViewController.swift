//
//  UserPostViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/26/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase

class UserPostViewController : UIViewController {
    var post : Post! = nil
    
    
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var answeredButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        answeredButton.layer.cornerRadius = 10
        questionText.layer.borderColor = UIColor.blackColor().CGColor
        questionText.layer.borderWidth = 1
        if post != nil {
            titleText.text = post.questionTitle!
            subject.text = post.subject!
            questionText.text = post.questionText!
        }
        
    }
    @IBAction func deletePost(sender: AnyObject) {
        userPosts.removeAll()
        UserPostsTableViewController().tableView.reloadData()
        UserPostsTableViewController().reload = true
        post.ref?.removeValue()
        FIRDatabase.database().reference().child("posts").queryOrderedByChild("postedBy").queryEqualToValue(currentUser!.username!).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            if snapshot.childrenCount != 0 {
                for postSnapshot in snapshot.children {
                    let post = Post(snapshot: postSnapshot as! FIRDataSnapshot)
                    userPosts.append(post)
                }
            }
            UserPostsTableViewController().reload = false
            UserPostsTableViewController().tableView.reloadData()
            self.navigationController?.popViewControllerAnimated(true)

        })
    }
    @IBAction func answered(sender: AnyObject) {
        userPosts.removeAll()
        UserPostsTableViewController().tableView.reloadData()
        UserPostsTableViewController().reload = true
        post.ref?.removeValue()
        FIRDatabase.database().reference().child("posts").queryOrderedByChild("postedBy").queryEqualToValue(currentUser!.username!).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            if snapshot.childrenCount != 0 {
                for postSnapshot in snapshot.children {
                    let post = Post(snapshot: postSnapshot as! FIRDataSnapshot)
                    userPosts.append(post)
                }
            }
            UserPostsTableViewController().reload = false
            UserPostsTableViewController().tableView.reloadData()
            self.navigationController?.popViewControllerAnimated(true)

        })
    }
}
