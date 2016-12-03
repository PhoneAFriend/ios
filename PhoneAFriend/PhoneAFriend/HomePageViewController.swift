//
//  HomePageViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 9/9/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase

class HomePageViewController: UIViewController {
    @IBOutlet weak var userLookUpButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var searchPostButton: UIButton!
    @IBOutlet weak var sessionStartButton: UIButton!
    @IBOutlet weak var myPostsButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        userLookUpButton.layer.cornerRadius = 10
        postButton.layer.cornerRadius = 10
        searchPostButton.layer.cornerRadius = 10
        sessionStartButton.layer.cornerRadius = 10
        myPostsButton.layer.cornerRadius = 10
    }
    
    
    @IBAction func startASession(sender: AnyObject) {
    }
}
