//
//  MoreViewController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 11/28/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit
import Firebase

class MoreViewController: UIViewController {
    
    @IBAction func logOutPressed(sender: AnyObject) {
        currentUser = nil
        posts.removeAll()
        activeContacts.removeAll()
        inactiveContacts.removeAll()
        displayContacts.removeAll()
        messages.removeAll()
        userPosts.removeAll()
        twilioClient!.hangUp()
        twilioClient = nil
        activeSession = nil
        dispatch_async(dispatch_get_main_queue(), {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
            self.navigationController?.presentViewController(homeVC, animated: false, completion: nil)
        })
        do {
            let unauth = try FIRAuth.auth()?.signOut()
        } catch {
            print(error)
        }
    }
}
