//
//  dataLoadViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 9/8/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit

class DataLoadViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if currentUsername == "" {
            performSegueToLoginPage()
        } else {
            //load data as well
            performSegueToHomePage()
        }
    }
    
    
    func performSegueToLoginPage(){
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("segueToLandingPage", sender: self)
        })
    }
    
    func performSegueToHomePage(){
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("SegueFromLoadToHomePage", sender: self)
        })
    }

}