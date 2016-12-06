//
//  PostViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/24/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase

class PostViewController : UIViewController {
    var post : Post! = nil
    var imageURLToPass : String! = ""
    var usernameToPass : String! = ""
    var subjectToPass : String! = ""
    var postKeyToPass : String! = ""
    var keyToPass : String! = ""
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var viewImageButton: UIButton!
    @IBOutlet weak var answerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        questionTextView.textContainerInset = UIEdgeInsetsMake(10, 7, 10, 0)
        
        if post != nil {
            titleTextField.text = post.questionTitle
            subjectTextField.text = post.subject
            questionTextView.text = post.questionText
        }
        
    }
    
    @IBAction func viewPressed(sender: AnyObject) {
        if post.questionImageURL != "None"{
            imageURLToPass = post.questionImageURL
            self.performSegueWithIdentifier("PostToPhoto", sender: nil)
        } else {
            let alert = UIAlertController(title: "No Image Available", message: "No image was uploaded with this post", preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in })
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    @IBAction func replyPressed(sender: AnyObject) {
        usernameToPass = post.postedBy
        subjectToPass = post.questionTitle
        postKeyToPass = post.ref?.key
        self.performSegueWithIdentifier("PostToMessage", sender: nil)
    }
    @IBAction func answerPressed(sender: AnyObject) {
        keyToPass = post.key
        self.performSegueWithIdentifier("showAnswers", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PostToPhoto" {
            let nextScene =  segue.destinationViewController as! PostImageViewController
            nextScene.imageURL = imageURLToPass
        } else if segue.identifier == "PostToMessage" {
            let nextScene =  segue.destinationViewController as! NewMessageTableViewController
            nextScene.username = usernameToPass
            nextScene.subject = subjectToPass
            nextScene.postKey = postKeyToPass
        } else if segue.identifier == "showAnswers" {
            let nextScene =  segue.destinationViewController as! AnswerTableViewController
            nextScene.key = keyToPass

        }
    }
    
    @IBAction func unwindToPost(segue: UIStoryboardSegue) {}
}
