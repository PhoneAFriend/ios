//
//  SessionPostViewController.swift
//  PhoneAFriend
//
//  Created by Michael Elliott on 12/5/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase

class SessionPostViewController: UITableViewController {
    
    @IBAction func quitButtonTouched(sender: AnyObject) {
        print("Quit button pressed")
        twilioClient?.hangUp()
    }
   
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    var imageURL : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(44,0,0,0)

        if activeSession?.postRef != ""{
            loadPostView()
            AppEvents.showLoadingOverlay("Loading Post")
        }
        // Do any additional setup after loading the view.
        UIDevice.currentDevice().setValue(Int(UIInterfaceOrientation.LandscapeLeft.rawValue), forKey: "orientation")
    }
    
    func loadPostView(){
        print(activeSession!.postRef!)
        FIRDatabase.database().reference().child("posts").queryOrderedByKey().queryEqualToValue(activeSession!.postRef!).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            print(snapshot.childrenCount)
            
            if snapshot.childrenCount != 0 {
                print(snapshot.childrenCount)
                for snap in snapshot.children{
                     let post = Post(snapshot: snap as! FIRDataSnapshot)
                    self.loadUI(post)
                }
                
            }
           
        })
        
    }
    
    func loadUI(post: Post) {
        postTitle.text = post.questionTitle
        questionText.text = post.questionText
        AppEvents.hideLoadingOverlay()

        if post.questionImageURL != "None"{
            let imageURL = post.questionImageURL!
            startDownload(imageURL)
        }
    }
    func startDownload(imageURL: String){
        if let url = NSURL(string: imageURL) {
            if let data = NSData(contentsOfURL: url) {
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        UIDevice.currentDevice().setValue(Int(UIInterfaceOrientation.LandscapeLeft.rawValue), forKey: "orientation")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // Force view to portrait
    func canRotate() -> Void {}
}
