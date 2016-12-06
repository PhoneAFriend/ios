//
//  AnswerViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/29/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase

class AnswerViewController: UIViewController {
    var answer: Answer! = nil
    var imageURLToPass:String = ""
    var upvotes = [Upvote]()
    override func viewDidLoad(){
        self.hideKeyboardWhenTappedAround()
        super.viewDidLoad()
        answerTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 0)

        if answer != nil {
            answerTextView.text = answer.answerText
        }
        self.automaticallyAdjustsScrollViewInsets = false
    }

    @IBAction func upvotePressed(sender: AnyObject) {
        upvotes.removeAll()
        FIRDatabase.database().reference().child("upvotes").queryOrderedByChild("answerKey").queryEqualToValue(answer.key).observeEventType(.Value, withBlock: { (snapshot) in
            if snapshot.childrenCount != 0 {
                for data in snapshot.children{
                    let upvote = Upvote(snapshot: data as! FIRDataSnapshot)
                    self.upvotes.append(upvote)
                }
                let index = self.upvotes.indexOf({$0.username == currentUser!.username})
                print(index)
                if index != nil {
                    let alert = UIAlertController(title: "Upvoted", message: "You have used your one upvote on this question.", preferredStyle: .Alert)
                    let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in
                    })
                    alert.addAction(cancelAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    self.answer.ref.updateChildValues(["upvotes": self.answer.upvotes+1])
                    let upvoteKey = FIRDatabase.database().reference().childByAutoId().key
                    let upvote = ["username": currentUser!.username!,
                        "answerKey" : self.answer.key
                            ]
                    let childUpdates = ["/upvotes/\(upvoteKey)":upvote]
                    FIRDatabase.database().reference().updateChildValues(childUpdates)
                    NSNotificationCenter.defaultCenter().postNotificationName("reloadAnswers", object: nil)
                }
            } else {
                self.answer.ref.updateChildValues(["upvotes": self.answer.upvotes+1])
                let upvoteKey = FIRDatabase.database().reference().childByAutoId().key
                let upvote = ["username": currentUser!.username!,
                    "answerKey" : self.answer.key
                ]
                let childUpdates = ["/upvotes/\(upvoteKey)":upvote]
                FIRDatabase.database().reference().updateChildValues(childUpdates)
                NSNotificationCenter.defaultCenter().postNotificationName("reloadAnswers", object: nil)
            }
        })
    }
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var viewButton: UIButton!
    @IBAction func viewPressed(sender: AnyObject) {
        imageURLToPass = answer.answerImageURL
        self.performSegueWithIdentifier("answerToImage", sender: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "answerToImage" {
            let nextScene =  segue.destinationViewController as! PostImageViewController
            nextScene.imageURL = imageURLToPass
        }
    }
    
}
