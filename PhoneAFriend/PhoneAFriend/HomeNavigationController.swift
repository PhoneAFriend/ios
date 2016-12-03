//
//  HomeNavigationController.swift
//  PhoneAFriend
//
//  Created by Cody Miller on 10/24/16.
//  Copyright © 2016 seniorDesign. All rights reserved.
//

import UIKit

class HomeNavigationController : UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = UIColor(netHex: 0x2196f3)
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
}
