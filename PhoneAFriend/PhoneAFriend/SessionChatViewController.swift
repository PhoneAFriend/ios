//
//  SessionChatViewController.swift
//  PhoneAFriend
//
//  Created by Michael Elliott on 12/5/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit

class SessionChatViewController: UIViewController {
    
    @IBAction func quitButtonTouched(sender: AnyObject) {
        print("Quit button pressed")
        twilioClient?.hangUp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        UIDevice.currentDevice().setValue(Int(UIInterfaceOrientation.LandscapeLeft.rawValue), forKey: "orientation")
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
