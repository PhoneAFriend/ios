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
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var viewImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTextView.layer.borderColor = UIColor.blackColor().CGColor
        questionTextView.layer.borderWidth = 1
        viewImageButton.layer.cornerRadius = 10
        if post != nil {
            titleTextField.text = post.questionTitle
            subjectTextField.text = post.subject
            questionTextView.text = post.questionText
        }
        
    }
    
    @IBAction func viewPressed(sender: AnyObject) {
        if post.questionImageURL != "nil"{
            imageURLToPass = post.questionImageURL
            self.performSegueWithIdentifier("PostToPhoto", sender: nil)
        }
    }
    @IBAction func replyPressed(sender: AnyObject) {
        usernameToPass = post.postedBy
        subjectToPass = post.subject
        self.performSegueWithIdentifier("PostToMessage", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PostToPhoto" {
            let nextScene =  segue.destinationViewController as! PostImageViewController
            nextScene.imageURL = imageURLToPass
        } else if segue.identifier == "PostToMessage" {
            let nextScene =  segue.destinationViewController as! NewMessageViewController
            nextScene.username = usernameToPass
            nextScene.subject = subjectToPass
        }
    }
    
    @IBAction func unwindToPost(segue: UIStoryboardSegue) {}
}
