//
//  SessionTabBarController.swift
//  PhoneAFriend
//
//  Created by Michael Elliott on 12/3/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit

class SessionTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UIDevice.currentDevice().setValue(Int(UIInterfaceOrientation.LandscapeLeft.rawValue), forKey: "orientation")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Return view to portrait when segueing out
    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController()) {
            UIDevice.currentDevice().setValue(Int(UIInterfaceOrientation.Portrait.rawValue), forKey: "orientation")
        }
    }
    
    // Force view to portrait
    func canRotate() -> Void {}
}
