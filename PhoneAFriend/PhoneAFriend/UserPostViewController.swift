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
        if post != nil {
            questionText.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 0)
            
            titleText.text = post.questionTitle!
            subject.text = post.subject!
            questionText.text = post.questionText!
        }
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    
    @IBAction func deletePost(sender: AnyObject) {
        post.ref?.removeValue()
        NSNotificationCenter.defaultCenter().postNotificationName("reloadPosts", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadUserPosts", object: nil)
        self.navigationController?.popViewControllerAnimated(true)

    }
    @IBAction func answered(sender: AnyObject) {
        post.ref?.updateChildValues(["answered" : "true"])
        NSNotificationCenter.defaultCenter().postNotificationName("reloadPosts", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("reloadUserPosts", object: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
}
