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
    override func viewDidLoad(){
        self.hideKeyboardWhenTappedAround() 
        super.viewDidLoad()
        answerTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 0)

        if answer != nil {
            answerTextView.text = answer.answerText
        }
        self.automaticallyAdjustsScrollViewInsets = false
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
