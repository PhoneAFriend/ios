//
//  AnswerTableViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/28/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase

class AnswerTableViewController : UITableViewController {
    var key: String! = ""
    var answerArray = [Answer]()
    var reload: Bool = false
    let cellIdentifier = "answerCell"
    var keyToPass: String! = ""
    var answerToPass : Answer! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AnswerTableViewController.loadAnswers(_:)),name:"reloadAnswers", object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let answer = answerArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! AnswerTableViewCell!
        cell.configure(answer)
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reload {
            return 0
        } else {
            return answerArray.count
        }
    }
    @IBAction func addAnswer(sender: AnyObject) {
        keyToPass = key
        self.performSegueWithIdentifier( "AnswersToPost", sender: nil)
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        answerToPass = answerArray[indexPath.row]
        self.performSegueWithIdentifier("AnswersToAnswer", sender: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AnswersToPost" {
            let nextScene =  segue.destinationViewController as! PostAnswerViewController
            nextScene.key = keyToPass
        } else if segue.identifier == "AnswersToAnswer" {
            let nextScene =  segue.destinationViewController as! AnswerViewController
            nextScene.answer = answerToPass
        }
    }
    func initialLoad() {
        FIRDatabase.database().reference().child("answers").queryOrderedByChild("key").queryEqualToValue(key).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
            if snapshot.childrenCount != 0 {
                for answerSnapshot in snapshot.children {
                    let answer = Answer(snapshot: answerSnapshot as! FIRDataSnapshot)
                    self.answerArray.append(answer)
                }
                self.tableView.reloadData()
                self.reload = false
            } else {
                let alert = UIAlertController(title: "No Answers Available", message: "There are currently no answers to this post. Add an answer using the add button in the top right corner", preferredStyle: .Alert)
                let cancel = UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in })
                alert.addAction(cancel)
                self.reload = false
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    func loadAnswers(notification: NSNotification) {
        answerArray.removeAll()
        initialLoad()
    }
}
