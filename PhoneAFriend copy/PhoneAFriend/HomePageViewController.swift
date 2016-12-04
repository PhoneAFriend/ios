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
 
    }
    
    
    @IBAction func startASession(sender: AnyObject) {
    }
}
